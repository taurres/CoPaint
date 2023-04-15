import std.stdio;
import core.stdc.string;

struct Packet{
	char[16] commandName;
    int x;
    int y;
    int r;
    int g;
    int b;
    int brushSize;

    /**
     * Serializes the packet into a byte array
     * @return the serialized packet
     */
    char[Packet.sizeof] serializePacket(){
        debug writeln("Serializing packet");

        char[Packet.sizeof] payload;
		memmove(&payload, &commandName, commandName.sizeof);
		memmove(&payload[16], &x, x.sizeof);
		memmove(&payload[20], &y, y.sizeof);
        memmove(&payload[24], &r, r.sizeof);
        memmove(&payload[28], &g, g.sizeof);
        memmove(&payload[32], &b, b.sizeof);
        memmove(&payload[36], &brushSize, brushSize.sizeof);

        debug writeln("commandName is:", commandName);
		debug writeln("x is:", x);
		debug writeln("y is:", y);
        debug writeln("r is:", r);
        debug writeln("g is:", g);
        debug writeln("b is:", b);
        debug writeln("brushSize is:", brushSize);

        return payload;
    }

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
    p.commandName = cast(char[])buffer[0..16].dup;
    byte[4] fieldX = buffer[16..20].dup;
    byte[4] fieldY = buffer[20..24].dup;
    byte[4] fieldR = buffer[24..28].dup;
    byte[4] fieldG = buffer[28..32].dup;
    byte[4] fieldB = buffer[32..36].dup;
    byte[4] fieldBrushSize = buffer[36..40].dup;

    p.x = *cast(int*)&fieldX;
    p.y = *cast(int*)&fieldY;
    p.r = *cast(int*)&fieldR;
    p.g = *cast(int*)&fieldG;
    p.b = *cast(int*)&fieldB;
    p.brushSize = *cast(int*)&fieldBrushSize;

    debug writeln("commandName is:", p.commandName);
    debug writeln("x is:", p.x);
    debug writeln("y is:", p.y);
    debug writeln("r is:", p.r);
    debug writeln("g is:", p.g);
    debug writeln("b is:", p.b);
    debug writeln("brushSize is:", p.brushSize);

    return p;
}