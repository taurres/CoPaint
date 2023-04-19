import std.stdio;
import network.client;
import network.server;
import surface:Surface;

@("Unit Test for client connecting to the server")
unittest {
    // init
    string host = "localhost";
    ushort port = 8000;
    int maxNoOfClients = 3;
    Surface instance = Surface(1);

    // start the server
    Server server = new Server(host, port, maxNoOfClients);
    server.run();

    // start a client
    Client first_client = new Client(host, port, &instance);
    first_client.run();

    assert(first_client.getClientId() == 1);

    // start a second client
    Client second_client = new Client(host, port, &instance);
    second_client.run();

    assert(first_client.getClientId() == 2);

    destroy(server);
}