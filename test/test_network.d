import std.stdio;
import network.client;
import surface:Surface;
import std.socket;
import std.conv;
import core.thread.osthread;

class MockServer {
    Socket listener;
    // initialize collection of sockets to keep track of clients
    Socket[] connectedClientList;
    int maxNoOfClients;

    /**
     * Constructor
     * @param host : host address to bind the server socket to
     * @param port : port to bind the server socket to
     * @param maxNoOfClients : maximum number of clients that can be connected to the server
     */
    this(string host="localhost", ushort port=8000, int maxNoOfClients=3) {
        writeln("Starting server...");

        writeln("\nCreating endpoint socket...");
        // creating socket for server to listen in and accept clients
        // ProtocolType.TCP : SocketType.STREAM :: ProtocolType.UDP : SocketType.DGRAM
        this.listener = new Socket(AddressFamily.INET, SocketType.STREAM, ProtocolType.TCP);

        // assign socket to a address with a port
        this.listener.bind(new InternetAddress(host, port));
        writeln("Server is listening on port ", port);

        // enable socket to accept connections from another socket
        this.maxNoOfClients = maxNoOfClients;
        this.listener.listen(this.maxNoOfClients);
    }

    /**
     * Destructor
     * It closes the server socket and all client sockets.
     */
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

    /**
     * This method is responsible for accepting client connections and running each client on a new thread.
     */
    void run() {
        bool serverOnline = false;
        writeln("\nAwaiting client connections...");

        int clientId = 0;

        // start accepting client connections on main thread
        while (this.connectedClientList.length < this.maxNoOfClients) {
            auto newClient = this.listener.accept();

            if (this.connectedClientList.length < this.maxNoOfClients) {
                clientId++;
                clientId = clientId % this.maxNoOfClients != 0 ? clientId % this.maxNoOfClients : this.maxNoOfClients;
                newClient.send("... connected to the server. clientId : " ~ to!string(clientId));

                // add new client on the connected client list
                this.connectedClientList ~= newClient;
            }
            else {
                newClient.send("... cannot connect to the server, maximum no. of clients reached");

                // close client socket
                newClient.shutdown(SocketShutdown.BOTH);
                newClient.close();
            }
        }
    }
}

@("Unit Test for client connecting to the server")
unittest {
    // init
    string host = "localhost";
    ushort port = 5050;
    int maxNoOfClients = 3;
    Surface instance = Surface(1);

    // start the server
    MockServer server = new MockServer(host, port, maxNoOfClients);
    new Thread({
            server.run();
        }).start();

    // start a client
    Client first_client = new Client(host, port, &instance);
    first_client.run();

    assert(first_client.getClientId() == 1);

    // start a second client
    Client second_client = new Client(host, port, &instance);
    second_client.run();

    assert(second_client.getClientId() == 2);

    // start a third client
    Client third_client = new Client(host, port, &instance);
    third_client.run();

    assert(third_client.getClientId() == 3);

    first_client.close();
    second_client.close();
    third_client.close();

    server.destroy();
}