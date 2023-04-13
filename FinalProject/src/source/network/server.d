// @file server.d
import std.stdio;
import std.socket;
import core.thread.osthread;
import Deque : Deque;
import packet;

class Server {
    Socket listener;
    // initialize collection of sockets to keep track of clients
    Socket[] connectedClientList;
    int maxNoOfClients;
    auto dq = new Deque!(Packet);

    this(string host="localhost", ushort port=8000, int maxNoOfClients=3) {
        writeln("Starting server...");

        writeln("\nCreating endpoint socket...");
        // creating socket for server to listen in and accept clients
        // ProtocolType.TCP : SocketType.STREAM :: ProtocolType.UDP : SocketType.DGRAM
        this.listener = new Socket(AddressFamily.INET, SocketType.STREAM, ProtocolType.TCP);

        // assign socket to a address with a port
        this.listener.bind(new InternetAddress(host, port));
        writeln("Server is listening on port 8000...");

        // enable socket to accept connections from another socket
        this.maxNoOfClients = maxNoOfClients;
        this.listener.listen(this.maxNoOfClients);
    }

    ~this() {
        // close server socket
        this.listener.shutdown(SocketShutdown.BOTH);
        this.listener.close();

        // close client sockets
        foreach (Socket client ; this.connectedClientList) {
            client.shutdown(SocketShutdown.BOTH);
            client.close();
        }
    }

    void run() {
        bool serverOnline = true;
        writeln("\nAwaiting client connections...");

        // start accepting client connections on main thread
        while (serverOnline) {
            auto newClient = this.listener.accept();

            if (this.connectedClientList.length < this.maxNoOfClients) {
                newClient.send("... connected to the server");

                // add new client on the connected client list
                this.connectedClientList ~= newClient;
                writeln("> client ", newClient.toHash(), " added to the client list...");

                // run each of the connected clients on a new thread
                new Thread({
                        this.runClient(newClient);
                    }).start();
            }
            else {
                newClient.send("... cannot connect to the server, maximum no. of clients reached");

                // close client socket
                newClient.shutdown(SocketShutdown.BOTH);
                newClient.close();
            }
        }
    }

    void runClient(Socket client) {
        bool clientRunning = true;
        writeln("client ", client.toHash(), " thread started...");

        // initialize buffer to pass data between server and clients
        byte[1024] buffer;

        // bring the client upto speed with previous updates
        this.fastForwardClient(client);

        while (clientRunning) {
            // recieve data from the client on current thread
            byte[] clientMessage = buffer[0 .. client.receive(buffer)];

            if (clientMessage.length == 0) {
                // if no bytes were present in the client message, client probably disconnected
                this.disconnectClient(client);
                clientRunning = false;
                break;
            }
            else if (clientMessage.length > 0) {
                // if client message contained bytes, broadcast it to all clients except current
                this.syncClients(client, clientMessage.dup);

                // add the message to deque maintaining chat history
                this.dq.push_back(deserializePacket(clientMessage.dup));
                // debug
                writeln(this.dq.at(this.dq.size()-1));
                writeln(this.dq.size());
                // debug
            }
        }
    }

    void disconnectClient(Socket client) {
        writeln("> client ", client.toHash(), " disconnected...");
        // close current client socket
        client.shutdown(SocketShutdown.BOTH);
        client.close();

        // get the index of the current client on the list of connected clients
        ulong i = getClientIdx(client);
        if (i >= 0) {
            // if index is valid, remove the current client from the list of connected clients
            this.connectedClientList = this.connectedClientList[0 .. i] ~ this.connectedClientList[i + 1 .. $];
            writeln("... client ", client.toHash(), " removed from the client list");
        }
        else {
            writeln("... client", client.toHash(), " not found in the client list");
        }
    }

    void syncClients(Socket client, byte[] clientMessage) {
        writeln("> client ", client.toHash(), " sent an update...");

        // loop through all clients that are currently connected to the server
        foreach (Socket broadcastClient ; this.connectedClientList) {
            if (client.toHash() != broadcastClient.toHash()) {
                writeln("Sending update to client ", broadcastClient.toHash(),  "...");
                // send the current client's message to other clients
                // broadcastClient.send(cast(char[])dup(cast(const(byte)[]) clientMessage)); //TODO: understand/simplify this line
                broadcastClient.send(clientMessage.dup);
            }
        }

        writeln("... all clients synced");
    }

    ulong getClientIdx(Socket client) {
        // linear search for current client
        foreach (i, Socket currClient ; this.connectedClientList) {
            if (client.toHash() == currClient.toHash()) {
                return i;
            }
        }

        return -1;
    }

    void fastForwardClient(Socket client) {
        writeln("> client ", client.toHash(),  " being fast-forwarded...");

        int pos = 0;
        while(pos < this.dq.size()) {
            writeln(this.dq.at(pos));
            // client.send(cast(char[])dup(cast(const(byte)[]) this.dq.at(pos)));
            pos++;
        }

        writeln("> client ", client.toHash(),  " all catched up...");
    }
}

void main() {
    Server server = new Server();
    server.run();
}