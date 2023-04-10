// @file server.d
import std.stdio;
import std.socket;

void main() {
    writeln("Starting server...");

    writeln("\nCreating endpoint socket...");
    auto listener = new Socket(AddressFamily.INET, SocketType.STREAM, ProtocolType.TCP);
    listener.bind(new InternetAddress("localhost", 8000));
    scope(exit) listener.close();
    writeln("Server is listening on port 8000...");

    int maxNoOfClients = 3;
    listener.listen(maxNoOfClients);

    auto clientReadSet = new SocketSet();
    Socket[] connectedClientList;

    byte[1024] buffer;

    writeln("\nAwaiting client connections...");
    bool serverOnline = true;

    while(serverOnline) {
        clientReadSet.reset();
        clientReadSet.add(listener);

        foreach(Socket client ; connectedClientList) {
            clientReadSet.add(client);
        }

        if(auto updatedCount = Socket.select(clientReadSet, null, null)) {
            foreach(i, Socket readClient ; connectedClientList) {
                if(clientReadSet.isSet(readClient)) {
                    auto clientMessage = buffer[0 .. readClient.receive(buffer)];

                    if(clientMessage.length == 0) {
                        writeln("> client ", readClient.toHash(), " disconnected...");
                        readClient.shutdown(SocketShutdown.BOTH);
                        readClient.close();
                        connectedClientList = connectedClientList[0 .. i] ~ connectedClientList[i + 1 .. $];
                        writeln("... client ", readClient.toHash(), " removed from the client list");

                    }
                    else if(clientMessage.length > 0) {
                        writeln("> client ", readClient.toHash(), " sent an update...");

                        foreach(j, Socket writeClient ; connectedClientList) {
                            if (i != j) {
                                writeln("Sending update to client ", writeClient.toHash());
                                writeClient.send(cast(char[])dup(cast(const(byte)[])clientMessage)); //TODO: understand/simplify this line
                            }
                        }

                        writeln("... all clients synced");
                    }
                }
            }
        }


        if(clientReadSet.isSet(listener)) {
            if (connectedClientList.length < maxNoOfClients) {
                auto newClient = listener.accept();
                newClient.send("... connected to the server");

                connectedClientList ~= newClient;
                writeln("> client ", newClient.toHash(), " added to the client list...");
            }
            else {
                auto newClient = listener.accept();
                newClient.send("... cannot connect to the server, maximum no. of clients reached");
                newClient.shutdown(SocketShutdown.BOTH);
                newClient.close();
            }
        }
    }

    foreach(Socket client ; connectedClientList) {
        client.close();
    }
}