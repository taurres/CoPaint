// @file client.d
import std.stdio;
import std.socket;
import core.thread.osthread;

class Client {
    Socket socket;

    this(string host="localhost", ushort port=8000) {
        writeln("Starting client... ");

        writeln("\nCreating socket...");
        this.socket = new Socket(AddressFamily.INET, SocketType.STREAM, ProtocolType.TCP);

        this.socket.connect(new InternetAddress(host, port));
    }

    ~this() {
        this.socket.close();
    }

    void run() {
        byte[1024] buffer;

        writeln(cast(char[])(buffer[0 .. socket.receive(buffer)]));
        write("> ");

        new Thread({
                this.listenForSyncs(socket, buffer);
            }).start();

        while(true) {
            foreach(line; stdin.byLine) {
                write("> ");
                socket.send(line);
            }
        }
    }

    void listenForSyncs(Socket socket, byte[] buffer) {
        while(true) {
            auto serverReply = buffer[0 .. socket.receive(buffer)];

            if(serverReply.length > 0) {
                writeln("\nServer > ", cast(char[])(serverReply.dup));
            }
        }
    }
}

void main() {
    Client client = new Client();
    client.run();
}