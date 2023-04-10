// @file server.d
import std.stdio;
import std.socket;
import core.thread.osthread;

class Server {
    Socket listener;
    // initialize collection of sockets to keep track of clients
    Socket[] connectedClientList;
    int maxNoOfClients;

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
        this.listener.close();

        foreach (Socket client ; this.connectedClientList) {
            client.close();
        }
    }

    void run() {
        bool serverOnline = true;
        writeln("\nAwaiting client connections...");

        while (serverOnline) {
            auto newClient = this.listener.accept();
            if (this.connectedClientList.length < this.maxNoOfClients) {
                newClient.send("... connected to the server");

                this.connectedClientList ~= newClient;
                writeln("> client ", newClient.toHash(), " added to the client list...");

                new Thread({
                        this.runClient(newClient);
                    }).start();
            }
            else {
                newClient.send("... cannot connect to the server, maximum no. of clients reached");
                newClient.shutdown(SocketShutdown.BOTH);
                newClient.close();
            }
        }
    }

    void runClient(Socket client) {
        bool clientRunning = true;
        writeln("client ", client.toHash(), " thread started...");

        byte[1024] buffer;

        while (clientRunning) {
            byte[] clientMessage = buffer[0 .. client.receive(buffer)];

            if (clientMessage.length == 0) {
                this.disconnectClient(client);
                clientRunning = false;
                break;
            }
            else if (clientMessage.length > 0) {
                this.syncClients(client, clientMessage);
            }
        }
    }

    void disconnectClient(Socket client) {
        writeln("> client ", client.toHash(), " disconnected...");
        client.shutdown(SocketShutdown.BOTH);
        client.close();
        ulong i = getClientIdx(client);
        if (i >= 0) {
            this.connectedClientList = this.connectedClientList[0 .. i] ~ this.connectedClientList[i + 1 .. $];
            writeln("... client ", client.toHash(), " removed from the client list");
        }
        else {
            writeln("... client", client.toHash(), " not found in the client list");
        }
    }

    void syncClients(Socket client, byte[] clientMessage) {
        writeln("> client ", client.toHash(), " sent an update...");

        foreach (Socket broadcastClient ; this.connectedClientList) {
            if (client.toHash() != broadcastClient.toHash()) {
                writeln("Sending update to client ", broadcastClient.toHash(),  "...");
                broadcastClient.send(cast(char[])dup(cast(const(byte)[]) clientMessage)); //TODO: understand/simplify this line
            }
        }

        writeln("... all clients synced");
    }

    ulong getClientIdx(Socket client) {
        foreach (i, Socket currClient ; this.connectedClientList) {
            if (client.toHash() == currClient.toHash()) {
                return i;
            }
        }

        return -1;
    }
}

void main() {
    Server server = new Server();
    server.run();
}