import std.stdio;
import std.string;
import network.deque;
import network.packet;
import surface;
import constants;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;

 interface Command {
    /**
     * Executes the command on the given surface.
     */ 
    void execute(Surface* surface);

    /** 
    * Unexecutes the command on the given surface.
    */
    void unexecute(Surface* surface);

    /**
     * Convert this command to a packet.
     */
    Packet toPacket();

    /**
      * Create a command from a packet.
      */
    static Command fromPacket(Packet packet) {
      if (packet.commandId == DRAW_COMMAND_ID) {
        return new DrawCommand(packet.x, packet.y, packet.brushSize, packet.pre_r, packet.pre_g, packet.pre_b);
      } else if (packet.commandId == ERASE_COMMAND_ID) {
        return new EraseCommand(packet.x, packet.y, packet.brushSize);
      } else if (packet.commandId == UNDO_COMMAND_ID) {
        //create a draw commad and send it to undo
        return new UndoCommand(packet.prevCommand); 
      } else if (packet.commandId == REDO_COMMAND_ID) {
        return new RedoCommand();
      } else {
        writeln("Unknown command: ", packet.commandId);
        return null;
      }
    };
  }

  // DRAW
  // UNDO
  // REDO
  // ERASE

  //Update pixel class
  class DrawCommand : Command {
    int commandId = DRAW_COMMAND_ID;
    int xPos;
    int yPos;
    int brushSize;
    ubyte pre_r;
    ubyte pre_g;
    ubyte pre_b;

    this(int xPos, int yPos, int brushSize, ubyte pre_r = 0, ubyte pre_g = 0, ubyte pre_b = 0){
        this.xPos = xPos;
        this.yPos = yPos;
        this.brushSize = brushSize;
        this.pre_r = pre_r;
        this.pre_g = pre_g;
        this.pre_b = pre_b;
    }

    ~this(){
        // Not sure what to do here
    }

    void execute(Surface* surface){
      // TODO capture previous state
      SDL_Color pixel = surface.pixelAt(xPos,yPos);
      pre_r = pixel.r;
      pre_g = pixel.g;
      pre_b = pixel.b;

      // Loop through and update specific pixels
        for(int w=-brushSize; w < brushSize; w++){
          for(int h=-brushSize; h < brushSize; h++){
              surface.UpdateSurfacePixel(xPos+w, yPos+h);
          }
      }
    }

    // TODO
    void unexecute(Surface* surface){
        surface.changePixel(xPos, yPos, pre_r, pre_g, pre_b);
    }
    

    Packet toPacket() {
      Packet p;
      p.commandId = this.commandId;
      p.x = this.xPos;
      p.y = this.yPos;
      // p.r = this.r;
      // p.g = this.g;
      // p.b = this.b;
      p.brushSize = this.brushSize;
      return p;
    }

  }

  class EraseCommand : Command {
    int commandId = ERASE_COMMAND_ID;
    int xPos;
    int yPos;
    int brushSize;
    ubyte r = 0; // assign background color to r,g,b
    ubyte g = 0;
    ubyte b = 0;
    ubyte pre_r;
    ubyte pre_g;
    ubyte pre_b;

    this(int xPos, int yPos, int brushSize, ubyte pre_r = 0, ubyte pre_g = 0, ubyte pre_b = 0){
        this.xPos = xPos;
        this.yPos = yPos;
        this.brushSize = brushSize;
        this.pre_r = pre_r;
        this.pre_g = pre_g;
        this.pre_b = pre_b;
    }

    ~this(){
        // Not sure what to do here
    }

    void execute(Surface* surface){
        SDL_Color pixel = surface.pixelAt(xPos,yPos);
        pre_r = pixel.r;
        pre_g = pixel.g;
        pre_b = pixel.b;
        surface.changePixel(xPos, yPos, r, g, b);
    }

    Packet toPacket() {
      Packet p;
      p.commandId = this.commandId;
      p.x = this.xPos;
      p.y = this.yPos;
      p.r = this.r;
      p.g = this.g;
      p.b = this.b;
      p.brushSize = this.brushSize;
      return p;
    }

    // TODO
    void unexecute(Surface* surface){
        surface.changePixel(xPos, yPos, pre_r, pre_g, pre_b);
    }
  }

  // TODO
  class UndoCommand : Command {
    int commandId = UNDO_COMMAND_ID;
    Command prevCommand;
    ubyte pre_r;
    ubyte pre_g;
    ubyte pre_b;

    this(Command prevCommand){
      this.prevCommand = prevCommand;
    }

    void execute(Surface* surface) {
        SDL_Color pixel = surface.pixelAt(prevCommand.xPos,prevCommand.yPos);
        pre_r = pixel.r;
        pre_g = pixel.g;
        pre_b = pixel.b;
        //  TODO call unexecute of draw commanD
        prevCommand.unexecute(surface);
    }

    // TODO - might need for redo
    void unexecute(Surface* surface){
        surface.changePixel(prevCommand.xPos, prevCommand.yPos, pre_r, pre_g, pre_b);
    }

    Packet toPacket() { return Packet();}
  }

  // TODO
  class RedoCommand : Command {
    int commandId = REDO_COMMAND_ID;
    // T[] redo_stack;
    void execute(Surface* surface) {
    //   // Pop from redo stack
    //   // Push into global command stack
    }

    void unexecute(Surface* surface){

    }
    Packet toPacket() { return Packet();}
  }