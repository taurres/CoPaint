/// Run with: 'dub'

// Import D standard libraries
import std.stdio;
import std.conv;
import std.string;
import sdlApp;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;


// Entry point to program
void main(string[] args) {
    if (args.length < 3) {
        writeln("Usage: dub -- <hostname> <port>");
        return;
    }
    string host = args[1];
    ushort port = to!ushort(args[2]);
    SDLApp myApp = new SDLApp();
  	myApp.MainApplicationLoop(host, port);
}

