// @file client.d
import std.stdio;
import std.socket;

void main() {
    writeln("Starting client... ");

    writeln("\nCreating socket...");
    auto socket = new Socket(AddressFamily.INET, SocketType.STREAM, ProtocolType.TCP);
    socket.connect(new InternetAddress("localhost", 8000));
    scope(exit) socket.close();

    byte[1024] buffer;

    writeln(cast(char[])(buffer[0 .. socket.receive(buffer)]));
    write("> ");

    foreach(line; stdin.byLine) {
        socket.send(line);

        auto serverReply = buffer[0 .. socket.receive(buffer)];
        writeln("\n> Server : ", cast(char[])(serverReply.dup));

        write(">");
    }
}