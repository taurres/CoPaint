// @file client.d
import std.stdio;
import std.socket;
import core.thread.osthread;

void main() {
    writeln("Starting client... ");

    writeln("\nCreating socket...");
    auto socket = new Socket(AddressFamily.INET, SocketType.STREAM, ProtocolType.TCP);
    socket.connect(new InternetAddress("localhost", 8000));
    scope(exit) socket.close();

    byte[1024] buffer;

    writeln(cast(char[])(buffer[0 .. socket.receive(buffer)]));
    write("> ");

    new Thread({
                while(true) {
                    auto serverReply = buffer[0 .. socket.receive(buffer)];

                    if(serverReply.length > 0) {
                        writeln("\nServer > ", cast(char[])(serverReply.dup));
                    }
                }
            }).start();

    while(true) {
        foreach(line; stdin.byLine) {
            write("> ");
            socket.send(line);
        }
    }
}