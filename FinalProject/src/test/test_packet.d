import std.stdio;
import network.packet;

@("Unit Test 1 for packet: test if the packet is serialized and then deserialized correctly")
unittest {
    Packet p = Packet(1, 40, 40, 255, 255, 0, 5, 0, 0, 0);
    Packet newP = deserializePacket(p.serializePacket());
    assert(p.commandId == newP.commandId && p.x == newP.x && p.y == newP.y && p.r == newP.r && p.g == newP.g &&p.b == newP.b && p.preR == newP.preR && p.preG == newP.preG && p.preB == newP.preB && p.brushSize == newP.brushSize);
}

@("Unit Test 2 for packet: test if the packet is serialized correctly")
unittest {
    Packet p = Packet(1, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    assert(p.serializePacket().length == 24);
}

@("Unit Test 3 for packet: test if the packet is deserialized correctly")
unittest {
    byte[] input = [1, 0, 0, 0, 40, 0, 0, 0, 40, 0, 0, 0, -1, -1, -1, 5, 0, 0, 0, 0, 0, 0, 0, 0];
    Packet p = deserializePacket(input);
    assert(p.commandId == 1 && p.x == 40 && p.y == 40 && p.r == 255 && p.g == 255 && p.b == 255 && p.preR == 0 && p.preG == 0 && p.preB == 0 && p.brushSize == 5);
}