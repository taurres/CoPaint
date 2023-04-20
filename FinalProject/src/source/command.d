import std.stdio;
import std.string;
import network.deque;
import network.packet;
import surface;
import constants;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;

 /**
  * Commands that are executed in SDLApp.
  * Command contains methods for executing and unexecuting the command, and convertion between command and packet.
  */
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
        return new DrawCommand(packet.x, packet.y, packet.brushSize, packet.r, packet.g, packet.b, packet.preR, packet.preG, packet.preB);
      } else if (packet.commandId == ERASE_COMMAND_ID) {
        return new EraseCommand(packet.x, packet.y, packet.brushSize);
      } else if (packet.commandId == UNDO_COMMAND_ID) {
        //pass the previous commad to undo
        Command preCommand;
        if(packet.commandId == ERASE_COMMAND_ID){
          preCommand = new EraseCommand(packet.x, packet.y, packet.brushSize, packet.preR, packet.preG, packet.preB);
        } else {
          preCommand = new DrawCommand(packet.x, packet.y, packet.brushSize, packet.r, packet.g, packet.b, packet.preR, packet.preG, packet.preB);
        }
        return new UndoCommand(preCommand); 
      } else if (packet.commandId == REDO_COMMAND_ID) {
        return new RedoCommand();
      } else {
        writeln("Unknown command: ", packet.commandId);
        return null;
      }
    };
  }

  ///Draw command to update color on canvas
  class DrawCommand : Command {
    int commandId = DRAW_COMMAND_ID;
    int xPos;
    int yPos;
    ubyte r;
    ubyte g;
    ubyte b;
    int brushSize;
    ubyte preR;
    ubyte preG;
    ubyte preB;

    this(int xPos, int yPos, int brushSize, ubyte r = 0, ubyte g = 0, ubyte b = 255, ubyte preR = 0, ubyte preG = 0, ubyte preB = 0){
        this.xPos = xPos;
        this.yPos = yPos;
        this.r = r;
        this.g = g;
        this.b = b;
        this.brushSize = brushSize;
        this.preR = preR;
        this.preG = preG;
        this.preB = preB;
    }

    void execute(Surface* surface){
      // capture previous state
      SDL_Color pixel = surface.pixelAt(xPos+brushSize,yPos+brushSize);
      preR = pixel.r;
      preG = pixel.g;
      preB = pixel.b;

      // Loop through and update specific pixels
      for(int w=-brushSize; w < brushSize; w++){
          for(int h=-brushSize; h < brushSize; h++){
              surface.changePixel(xPos+w, yPos+h, r, g, b);
          }
      }
    }

    void unexecute(Surface* surface){
      for(int w=-brushSize; w < brushSize; w++){
          for(int h=-brushSize; h < brushSize; h++){
              // surface.UpdateSurfacePixel(xPos+w, yPos+h, preR, preG, preB);
              surface.changePixel(xPos+w, yPos+h, preR, preG, preB);
          }
      }
    }

    Packet toPacket() {
      Packet p;
      p.commandId = this.commandId;
      p.x = this.xPos;
      p.y = this.yPos;
      p.r = this.r;
      p.g = this.g;
      p.b = this.b;
      p.preR = this.preR;
      p.preG = this.preG;
      p.preB = this.preB;
      p.brushSize = this.brushSize;
      return p;
    }

  }

  ///Erase command to erase color on canvas
  class EraseCommand : Command {
    int commandId = ERASE_COMMAND_ID;
    int xPos;
    int yPos;
    int brushSize;
    ubyte r = 0; // assign background color to r,g,b
    ubyte g = 0;
    ubyte b = 0;
    ubyte preR;
    ubyte preG;
    ubyte preB;

    this(int xPos, int yPos, int brushSize, ubyte preR = 0, ubyte preG = 0, ubyte preB = 0){
        this.xPos = xPos;
        this.yPos = yPos;
        this.brushSize = brushSize;
        this.preR = preR;
        this.preG = preG;
        this.preB = preB;
    }

    ~this(){
        // Not sure what to do here
    }

    void execute(Surface* surface){
        SDL_Color pixel = surface.pixelAt(xPos,yPos);
        preR = pixel.r;
        preG = pixel.g;
        preB = pixel.b;
        // Loop through and update specific pixels
        for(int w=-brushSize; w < brushSize; w++){
            for(int h=-brushSize; h < brushSize; h++){
                surface.changePixel(xPos+w, yPos+h, r, g, b);
            }
        }
    }

    void unexecute(Surface* surface){
      writeln("here");
        for(int w=-brushSize; w < brushSize; w++){
          for(int h=-brushSize; h < brushSize; h++){
              surface.changePixel(xPos+w, yPos+h, preR, preG, preB);
          }
      }
    }

    Packet toPacket() {
      Packet p;
      p.commandId = this.commandId;
      p.x = this.xPos;
      p.y = this.yPos;
      p.r = this.r;
      p.g = this.g;
      p.b = this.b;
      p.preR = this.preR;
      p.preG = this.preG;
      p.preB = this.preB;
      p.brushSize = this.brushSize;
      return p;
    }
  }
  
  ///Undo command to undo previous command
  class UndoCommand : Command {
    int commandId = UNDO_COMMAND_ID;
    Command prevCommand = null;

    this() {}

    this(Command prevCommand){
      this.prevCommand = prevCommand;
    }

    void execute(Surface* surface) {
        debug writeln("Executing undo");
        prevCommand.unexecute(surface);
        debug writeln("Done");
    }

    void unexecute(Surface* surface){
    }

    Packet toPacket() {
      Packet p;
      p.commandId = this.commandId;
      return p;
    }
  }

  ///Redo command to redo a command that was undone
  class RedoCommand : Command {
    int commandId = REDO_COMMAND_ID;
    
    void execute(Surface* surface) {
    }

    void unexecute(Surface* surface){
    }

    Packet toPacket() {
      Packet p;
      p.commandId = this.commandId;
      return p;
    }
  }