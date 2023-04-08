// Import D standard libraries
import std.stdio;
import std.string;
import surface;
import deque;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;

 interface Command { 
    void execute();
  }

  // DRAW
  // UNDO
  // REDO
  // ERASE

  class EraseCommand : Command {
    Surface surface;
    int xPos;
    int yPos;
    int brushSize;
    ubyte r = 0; // assign background color to r,g,b
    ubyte g = 0;
    ubyte b = 0;

    this(Surface surface, int xPos, int yPos, int brushSize){
        this.surface = surface;
        this.xPos = xPos;
        this.yPos = yPos;
        this.brushSize = brushSize;
    }

    ~this(){
        // Not sure what to do here
    }

    void execute(){
        surface.changePixel(xPos, yPos, r, g, b);
    }

  }


  //Update pixel class
  class DrawCommand : Command {
    Surface* surface;
    SDL_Surface* imgSurface;
    int xPos;
    int yPos;
    int brushSize;

    this(Surface* surface, SDL_Surface* imgSurface, int xPos, int yPos, int brushSize){
        this.surface = surface;
        this.imgSurface = imgSurface;
        this.xPos = xPos;
        this.yPos = yPos;
        this.brushSize = brushSize;
    }

    ~this(){
        // Not sure what to do here
    }

    void execute(){
      // Loop through and update specific pixels
        for(int w=-brushSize; w < brushSize; w++){
          for(int h=-brushSize; h < brushSize; h++){
              surface.UpdateSurfacePixel(imgSurface, xPos+w, yPos+h);
          }
      }
    }

  }

  class UndoCommand : Command {
    // Deque undo_deque = new Deque();
    void execute() {
      // Pop back from global command deque
      // Push into redo stack
    }
  }

  class RedoCommand : Command {
    // T[] redo_stack;
    void execute() {
      // Pop from redo stack
      // Push into global command stack
    }
  }