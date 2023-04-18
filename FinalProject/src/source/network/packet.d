module network.packet;

import std.stdio;
import core.stdc.string;

struct Packet{
	int commandId;
    int x;
    int y;
    ubyte r;
    ubyte g;
    ubyte b;
    int brushSize;
    ubyte preR;
    ubyte preG;
    ubyte preB;

    /**
     * Serializes the packet into a byte array
     * @return the serialized packet
     */
    char[Packet.sizeof] serializePacket(){
        debug writeln("Serializing packet");

        char[Packet.sizeof] payload;
		memmove(&payload, &commandId, commandId.sizeof);
		memmove(&payload[4], &x, x.sizeof);
		memmove(&payload[8], &y, y.sizeof);
        memmove(&payload[12], &r, r.sizeof);
        memmove(&payload[13], &g, g.sizeof);
        memmove(&payload[14], &b, b.sizeof);
        memmove(&payload[15], &brushSize, brushSize.sizeof);
        memmove(&payload[19], &preR, preR.sizeof);
        memmove(&payload[20], &preG, preG.sizeof);
        memmove(&payload[21], &preB, preB.sizeof);

        debug writeln("commandId is:", commandId);
		debug writeln("x is:", x);
		debug writeln("y is:", y);
        debug writeln("r is:", r);
        debug writeln("g is:", g);
        debug writeln("b is:", b);
        debug writeln("brushSize is:", brushSize);
        debug writeln("preR is:", preR);
        debug writeln("preG is:", preG);
        debug writeln("preB is:", preB);

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
    byte[4] fieldCommandId = buffer[0..4].dup;
    byte[4] fieldX = buffer[4..8].dup;
    byte[4] fieldY = buffer[8..12].dup;
    byte[1] fieldR = buffer[12..13].dup;
    byte[1] fieldG = buffer[13..14].dup;
    byte[1] fieldB = buffer[14..15].dup;
    byte[4] fieldBrushSize = buffer[15..19].dup;
    byte[1] fieldPreR = buffer[19..20].dup;
    byte[1] fieldPreG = buffer[20..21].dup;
    byte[1] fieldPreB = buffer[21..22].dup;

    p.commandId = *cast(int*)&fieldCommandId;
    p.x = *cast(int*)&fieldX;
    p.y = *cast(int*)&fieldY;
    p.r = *cast(ubyte*)&fieldR;
    p.g = *cast(ubyte*)&fieldG;
    p.b = *cast(ubyte*)&fieldB;
    p.brushSize = *cast(int*)&fieldBrushSize;
    p.preR = *cast(ubyte*)&fieldPreR;
    p.preG = *cast(ubyte*)&fieldPreG;
    p.preB = *cast(ubyte*)&fieldPreB;

    debug writeln("commandId is:", p.commandId);
    debug writeln("x is:", p.x);
    debug writeln("y is:", p.y);
    debug writeln("r is:", p.r);
    debug writeln("g is:", p.g);
    debug writeln("b is:", p.b);
    debug writeln("brushSize is:", p.brushSize);
    debug writeln("preR is:", p.preR);
    debug writeln("preG is:", p.preG);
    debug writeln("preB is:", p.preB);

    return p;
}