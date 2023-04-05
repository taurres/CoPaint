 // Import D standard libraries
import std.stdio;
import std.string;
import surface;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;

 interface Command { 
    void execute();
  }

  class ChangeSurfacePixelCommand : Command {
    SDL_Surface* surface;
    int xPos;
    int yPos;
    ubyte r;
    ubyte g;
    ubyte b;

    this(SDL_Surface* surface, int xPos, int yPos, ubyte r, ubyte g, ubyte b){
        this.surface = surface;
        this.xPos = xPos;
        this.yPos = yPos;
        this.r = r;
        this.g = g;
        this.b = b;
    }

    ~this(){
        // Not sure what to do here
    }

    void execute(){
        surface.changePixel(xPos, yPos, r, g, b);
    }

  }