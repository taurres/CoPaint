import std.stdio;
import std.string;
import deque;
import surface;
import packet;

 interface Command { 
    void execute(Surface* surface);
    Packet toPacket();
  }

  // DRAW
  // UNDO
  // REDO
  // ERASE

  class EraseCommand : Command {
    char[16] name;
    int xPos;
    int yPos;
    int brushSize;
    ubyte r = 0; // assign background color to r,g,b
    ubyte g = 0;
    ubyte b = 0;

    this(int xPos, int yPos, int brushSize){
        this.name = "Erase";
        this.xPos = xPos;
        this.yPos = yPos;
        this.brushSize = brushSize;
    }

    ~this(){
        // Not sure what to do here
    }

    void execute(Surface* surface){
        surface.changePixel(xPos, yPos, r, g, b);
    }

    Packet toPacket() {
      Packet p;
      p.commandName = this.name;
      p.x = this.xPos;
      p.y = this.yPos;
      p.r = this.r;
      p.g = this.g;
      p.b = this.b;
      p.brushSize = this.brushSize;
      return p;
    }

  }


  //Update pixel class
  class DrawCommand : Command {
    char[16] name;
    int xPos;
    int yPos;
    int brushSize;

    this(int xPos, int yPos, int brushSize){
        this.name = "Draw";
        this.xPos = xPos;
        this.yPos = yPos;
        this.brushSize = brushSize;
    }

    ~this(){
        // Not sure what to do here
    }

    void execute(Surface* surface){
      // Loop through and update specific pixels
        for(int w=-brushSize; w < brushSize; w++){
          for(int h=-brushSize; h < brushSize; h++){
              surface.UpdateSurfacePixel(xPos+w, yPos+h);
          }
      }
    }

    Packet toPacket() {
      Packet p;
      p.commandName = this.name;
      p.x = this.xPos;
      p.y = this.yPos;
      // p.r = this.r;
      // p.g = this.g;
      // p.b = this.b;
      p.brushSize = this.brushSize;
      return p;
    }

  }

  class UndoCommand : Command {
    // Deque undo_deque = new Deque();
    void execute(Surface* surface) {
    //   // Pop back from global command deque
    //   // Push into redo stack
    }
    // TODO
    Packet toPacket() { return Packet();}
  }

  class RedoCommand : Command {
    // T[] redo_stack;
    void execute(Surface* surface) {
    //   // Pop from redo stack
    //   // Push into global command stack
    }
    // TODO
    Packet toPacket() { return Packet();}
  }