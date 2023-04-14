// @file client.d
import std.stdio;
import std.socket;
import core.thread.osthread;
import packet;

import command : Command;

class Client {
    Socket socket;

    this(string host="localhost", ushort port=8000) {
        writeln("Starting client... ");

        writeln("\nCreating socket...");
        // creating socket for client to send data and receive syncs from server
        // ProtocolType.TCP : SocketType.STREAM :: ProtocolType.UDP : SocketType.DGRAM
        this.socket = new Socket(AddressFamily.INET, SocketType.STREAM, ProtocolType.TCP);

        // connecting client socket to the server
        this.socket.connect(new InternetAddress(host, port));
    }

    ~this() {
        // close client socket
        this.socket.close();
    }

    void run() {
        // initialize buffer to pass data between client and server
        byte[1024] buffer;

        // receive connection ACK from the server
        writeln(cast(char[])(buffer[0 .. socket.receive(buffer)]));
        write("> ");

        // new thread for listening to server for syncs
        new Thread({
                this.listenForSyncs(socket, buffer);
            }).start();

        // // main thread is delegated to send data to the server
        // while(true) {
        //     foreach(line; stdin.byLine) {
        //         write("> ");
        //         // send data to the connected server socket
        //         socket.send(createPacket("update\0", 255, 0, 255, 255, 255).serializePacket());
        //     }
        // }
    }

    void sendToServer(Command c) {
        // parse the command into the paramaters
        // params
        // params
        socket.send(createPacket("update\0", 255, 0, 255, 255, 255).serializePacket());
    }

    void listenForSyncs(Socket socket, byte[] buffer) {
        while(true) {
            // listen to server's reply
            auto serverReply = buffer[0 .. socket.receive(buffer)];

            if(serverReply.length > 0) {
                Packet p = deserializePacket(serverReply.dup);
                // add this packet to the shared deque
                // writeln("\nServer > ", cast(char[])(serverReply.dup));
                writeln("\nServer > ", p);
            }
        }
    }
}

void main() {
    Client client = new Client();
    client.run();
}