  module surface;
  // Import D standard libraries
  import std.stdio;
  import std.string;
  import std.conv;
  // Load the SDL2 library
  import bindbc.sdl;
  import loader = bindbc.loader.sharedlib;
  import command;

  /**
   * Struct of the surface. It contains the SDL_Surface and the functions to update the pixels.
   */
  struct Surface{
    SDL_Surface* imgSurface;

    /**
     * Constructor
     * Load the SDL library.
     */
  	this(...) {
      loadSDL();
  		// Create a surface...
        imgSurface = SDL_CreateRGBSurface(0,640,520,32,0,0,0,0);
  	}

    /**
     * Destructor
     * Free the SDL library.
     */
  	~this(){
  		// Free a surface...
        SDL_FreeSurface(imgSurface);
  	}

    /**
     * Get SDL_Surface
     */
     SDL_Surface* getSurface() {
        return imgSurface;
    }

    //command object
    Command command;

    /**
     * set the command to be executed
     */
    void setCommand(Command command){
      this.command = command;
    }

    /**
     * execute the command
     */
    void executeCommand(){
      command.execute(&this);
    }

  	/**
     * Function for updating the pixels in a surface to a 'blue-ish' color.
     */
    void UpdateSurfacePixel(int xPos, int yPos, ubyte r = 0, ubyte g = 0, ubyte b = 255){
        // When we modify pixels, we need to lock the surface first
        SDL_LockSurface(imgSurface);
        // Make sure to unlock the surface when we are done.
        scope(exit) SDL_UnlockSurface(imgSurface);

        // Retrieve the pixel arraay that we want to modify
        ubyte* pixelArray = cast(ubyte*)imgSurface.pixels;
        // Change the 'blue' component of the pixels
        pixelArray[yPos*imgSurface.pitch + xPos*imgSurface.format.BytesPerPixel+0] = b;
        // Change the 'green' component of the pixels
        pixelArray[yPos*imgSurface.pitch + xPos*imgSurface.format.BytesPerPixel+1] = g;
        // Change the 'red' component of the pixels
        pixelArray[yPos*imgSurface.pitch + xPos*imgSurface.format.BytesPerPixel+2] = r;
    }

   /**
    * Changing pixel value for position (x,y) to the given r,g,b values.
    */
   void changePixel(int x, int y, ubyte r, ubyte g, ubyte b) {
        SDL_LockSurface(imgSurface);
        // Make sure to unlock the surface when we are done.
        scope(exit) SDL_UnlockSurface(imgSurface);

        // Retrieve the pixel array that we want to modify
        ubyte* pixelArray = cast(ubyte*) imgSurface.pixels;

        // Change the color of the pixel at (x, y)
        pixelArray[y * imgSurface.pitch + x * imgSurface.format.BytesPerPixel + 2] = r;
        pixelArray[y * imgSurface.pitch + x * imgSurface.format.BytesPerPixel + 1] = g;
        pixelArray[y * imgSurface.pitch + x * imgSurface.format.BytesPerPixel + 0] = b;
    }


    /** 
     * Fetching pixel's struct and r,g,b value at position (x,y).
     */
    SDL_Color pixelAt(int x, int y) {
        SDL_LockSurface(imgSurface); // Locking surface
        scope(exit){
        SDL_UnlockSurface(imgSurface); // Unlocking surface when done
      }
        // Retreiving the pixel array that needs to be read
        ubyte* pixelArray = cast(ubyte*)imgSurface.pixels;
        int index = y * imgSurface.pitch + x * imgSurface.format.BytesPerPixel;

        // Retreiving the rgb value of colours from pixel array
        int r = pixelArray[index + imgSurface.format.Rshift / 8];
        int g = pixelArray[index + imgSurface.format.Gshift / 8];
        int b = pixelArray[index + imgSurface.format.Bshift / 8];
        int a = pixelArray[index + imgSurface.format.Ashift / 8];

        // Returning pixel as SDL_Color struct with color values
        return SDL_Color(r.to!ubyte, g.to!ubyte, b.to!ubyte, a.to!ubyte);
      }
  }