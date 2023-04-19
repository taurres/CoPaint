module network.client;

import std.stdio;
import std.socket;
import core.thread.osthread;
import network.packet;
import command;
import surface;

/**
 * Client class
 * This class is responsible for creating a client socket, sending requests to server and listening for server responses.
 */
class Client {
    Socket socket;
    Surface* instance;

    /**
     * Constructor
     * @param instance : Surface instance
     * @param host : server host
     * @param port : server port
     */
    this(Surface* instance=null, string host="localhost", ushort port=8000) {
        this.instance = instance;
        writeln("Starting client... ");

        writeln("\nCreating socket...");
        // creating socket for client to send data and receive syncs from server
        // ProtocolType.TCP : SocketType.STREAM :: ProtocolType.UDP : SocketType.DGRAM
        this.socket = new Socket(AddressFamily.INET, SocketType.STREAM, ProtocolType.TCP);

        // connecting client socket to the server
        this.socket.connect(new InternetAddress(host, port));
    }

    /**
     * Destructor
     * close client socket
     */
    ~this() {
        this.socket.close();
    }

    /**
     * This method is responsible for sending connection ACK to the server and listening for server syncs
     */
    void run() {
        // initialize buffer to pass data between client and server
        byte[10240] buffer;

        // receive connection ACK from the server
        writeln(cast(char[])(buffer[0 .. socket.receive(buffer)]));
        write("> ");

        // new thread for listening to server for syncs
        new Thread({
                this.listenForSyncs(socket, buffer);
            }).start();
    }

    /**
     * This method is responsible for closing client socket
     */
    void close() {
        this.socket.shutdown(SocketShutdown.BOTH);
        this.socket.close();
    }

    /**
     * This method is responsible for sending commands to the server
     * @param command : command to be sent to the server
     */
    void sendToServer(Command command) {
        socket.send(command.toPacket().serializePacket());
    }

    /**
     * This method is responsible for listening to server for syncs
     * @param socket : client socket
     * @param buffer : buffer to pass data between client and server
     */
    void listenForSyncs(Socket socket, byte[] buffer) {
        while(true) {
            // listen to server's reply
            auto serverReply = buffer[0 .. socket.receive(buffer)];

            if(serverReply.length > 0) {
                Packet p = deserializePacket(serverReply.dup);

                Command command = Command.fromPacket(p);

                instance.setCommand(command);
                instance.executeCommand();
            }
        }
    }

}