import std.stdio;
import core.stdc.string;

struct Packet{
	char[16] command;
    int x;
    int y;
    int r;
    int g;
    int b;

    /**
     * Serializes the packet into a byte array
     * @return the serialized packet
     */
    char[Packet.sizeof] serializePacket(){
        writeln("Serializing packet");
        char[Packet.sizeof] payload;
		memmove(&payload, &command, command.sizeof);
		memmove(&payload[16], &x, x.sizeof);
		memmove(&payload[20], &y, y.sizeof);
        memmove(&payload[24], &r, r.sizeof);
        memmove(&payload[28], &g, g.sizeof);
        memmove(&payload[32], &b, b.sizeof);
        writeln("command is:", command);
		writeln("x is:", x);
		writeln("y is:", y);
        writeln("r is:", r);
        writeln("g is:", g);
        writeln("b is:", b);

        return payload;
    }

}

/**
 * Creates a packet
 * @param command the command to send
 * @param x the x coordinate
 * @param y the y coordinate
 * @param r the red value
 * @param g the green value
 * @param b the blue value
 * @return the packet
 */
Packet createPacket(char[16] command, int x, int y, int r, int g, int b){
    Packet p;
    p.command = command;
    p.x = x;
    p.y = y;
    p.r = r;
    p.g = g;
    p.b = b;
    return p;
}

/**
 * Deserializes a packet from a byte array
 * @param buffer the byte array to deserialize from
 * @return the deserialized packet
 */
Packet deserializePacket(byte[] buffer){
    writeln("deserializing packet");
    writeln("sizeof Packet    :", Packet.sizeof);
    writeln("buffer length    :", buffer.length);
    writeln("buffer (raw bytes): ",buffer);

    Packet p;
    p.command = cast(char[])buffer[0..16].dup;
    byte[4] fieldX = buffer[16..20].dup;
    byte[4] fieldY = buffer[20..24].dup;
    byte[4] fieldR = buffer[24..28].dup;
    byte[4] fieldG = buffer[28..32].dup;
    byte[4] fieldB = buffer[32..36].dup;
    p.x = *cast(int*)&fieldX;
    p.y = *cast(int*)&fieldY;
    p.r = *cast(int*)&fieldR;
    p.g = *cast(int*)&fieldG;
    p.b = *cast(int*)&fieldB;
    writeln("command is:", p.command);
    writeln("x is:", p.x);
    writeln("y is:", p.y);
    writeln("r is:", p.r);
    writeln("g is:", p.g);
    writeln("b is:", p.b);

    return p;
}