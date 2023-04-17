import std.stdio;
import std.string;
import Deque;
import surface;
import packet;
import constants;

 interface Command {
    /**
     * Executes the command on the given surface.
     */ 
    void execute(Surface* surface);

    /**
     * Covert this command to a packet.
     */
    Packet toPacket();

    /**
      * Create a command from a packet.
      */
    static Command fromPacket(Packet packet) {
      if (packet.commandId == DRAW_COMMAND_ID) {
        return new DrawCommand(packet.x, packet.y, packet.brushSize);
      } else if (packet.commandId == ERASE_COMMAND_ID) {
        return new EraseCommand(packet.x, packet.y, packet.brushSize);
      } else if (packet.commandId == UNDO_COMMAND_ID) {
        return new UndoCommand();
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

    this(int xPos, int yPos, int brushSize){
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

    this(int xPos, int yPos, int brushSize){
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
      p.commandId = this.commandId;
      p.x = this.xPos;
      p.y = this.yPos;
      p.r = this.r;
      p.g = this.g;
      p.b = this.b;
      p.brushSize = this.brushSize;
      return p;
    }
  }

  // TODO
  class UndoCommand : Command {
    int commandId = UNDO_COMMAND_ID;
    // Deque undo_deque = new Deque();
    void execute(Surface* surface) {
    //   // Pop back from global command deque
    //   // Push into redo stack
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
    Packet toPacket() { return Packet();}
  }