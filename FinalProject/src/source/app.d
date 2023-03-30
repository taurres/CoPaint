/// Run with: 'dub'

// Import D standard libraries
import std.stdio;
import std.string;
import sdlApp;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;


// Entry point to program
void main()
{
    SDLApp myApp = new SDLApp();
  	myApp.MainApplicationLoop();
}

