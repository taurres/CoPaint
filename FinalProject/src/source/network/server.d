module network.server;

import std.stdio;
import std.socket;
import core.thread.osthread;
import network.deque;
import network.packet;
import constants;

class Server {
    Socket listener;
    // initialize collection of sockets to keep track of clients
    Socket[] connectedClientList;
    int maxNoOfClients;
    auto dq = new Deque!(Packet);
    // redo deque
    auto redoDeque = new Deque!(Packet);

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
        byte[10240] buffer;

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
                Packet curPacket = deserializePacket(clientMessage.dup);
                if (curPacket.commandId == UNDO_COMMAND_ID) {
                    // if the current packet is a undo packet
                    this.handleUndo(client, curPacket);
                } else if (curPacket.commandId == REDO_COMMAND_ID) {
                    // if the current packet is a redo packet
                    if (this.redoDeque.size() > 0) {
                        Packet redoPacket = this.redoDeque.pop_back();
                        this.dq.push_back(redoPacket);
                        this.syncAllClients(client, redoPacket.serializePacket());
                    }
                } else {
                    // add the message to deque maintaining chat history
                    this.dq.push_back(curPacket);
                    // empty redo deque when new draw packet is received
                    this.redoDeque.clear();
                    // if client message contained bytes, broadcast it to all clients except current
                    this.syncClients(client, clientMessage.dup);
                }
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

    void syncClients(Socket client, scope const(void)[] clientMessage) {
        writeln("> client ", client.toHash(), " sent an update...");

        // loop through all clients that are currently connected to the server
        foreach (Socket broadcastClient ; this.connectedClientList) {
            if (client.toHash() != broadcastClient.toHash()) {
                writeln("Sending update to client ", broadcastClient.toHash(),  "...");
                // send the current client's message to other clients
                broadcastClient.send(clientMessage.dup);
            }
        }

        writeln("... all clients synced");
    }

    void syncAllClients(Socket client, scope const(void)[] clientMessage) {
                writeln("> client ", client.toHash(), " sent an update...");

        // loop through all clients that are currently connected to the server
        foreach (Socket broadcastClient ; this.connectedClientList) {
            writeln("Sending update to client ", broadcastClient.toHash(),  "...");
            // send the current client's message to other clients
            broadcastClient.send(clientMessage.dup);
            
        }

        writeln("... all clients synced");
    }

    void handleUndo(Socket client, Packet curPacket) {
        if (this.dq.size() > 0) {
            Packet prePacket = this.dq.pop_back();
            curPacket.x = prePacket.x;
            curPacket.y = prePacket.y;
            curPacket.preR = prePacket.preR;
            curPacket.preG = prePacket.preG;
            curPacket.preB = prePacket.preB;
            curPacket.brushSize = prePacket.brushSize;

            // add the previous packet to redo deque
            this.redoDeque.push_back(prePacket);

            // sync all clients
            this.syncAllClients(client, curPacket.serializePacket());
        }
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
            client.send(this.dq.at(pos).serializePacket());
            pos++;
        }

        writeln("> client ", client.toHash(),  " all catched up...");
    }
}

void main() {
    Server server = new Server();
    server.run();
}