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
        debug writeln("Serializing packet");

        char[Packet.sizeof] payload;
		memmove(&payload, &command, command.sizeof);
		memmove(&payload[16], &x, x.sizeof);
		memmove(&payload[20], &y, y.sizeof);
        memmove(&payload[24], &r, r.sizeof);
        memmove(&payload[28], &g, g.sizeof);
        memmove(&payload[32], &b, b.sizeof);

        debug writeln("command is:", command);
		debug writeln("x is:", x);
		debug writeln("y is:", y);
        debug writeln("r is:", r);
        debug writeln("g is:", g);
        debug writeln("b is:", b);

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
    debug writeln("deserializing packet");
    debug writeln("sizeof Packet    :", Packet.sizeof);
    debug writeln("buffer length    :", buffer.length);
    debug writeln("buffer (raw bytes): ",buffer);

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

    debug writeln("command is:", p.command);
    debug writeln("x is:", p.x);
    debug writeln("y is:", p.y);
    debug writeln("r is:", p.r);
    debug writeln("g is:", p.g);
    debug writeln("b is:", p.b);

    return p;
}