  // Import D standard libraries
  import std.stdio;
  import std.string;
  import std.conv;
  // Load the SDL2 library
  import bindbc.sdl;
  import loader = bindbc.loader.sharedlib;
  import command:Command;

  struct Surface{
    SDL_Surface* imgSurface;

  	this(...) {
      loadSDL();
  		// Create a surface...
        imgSurface = SDL_CreateRGBSurface(0,640,480,32,0,0,0,0);
  	}
  	~this(){
  		// Free a surface...
        SDL_FreeSurface(imgSurface);
  	}

     SDL_Surface* getSurface() {
        return imgSurface;
    }

    //command object
    Command command;

    //set command: 
    void setCommand(Command command){
      this.command = command;
    }

    void executeCommand(){
      command.execute();
    }

  	// Update a pixel ...
  	// Function for updating the pixels in a surface to a 'blue-ish' color.
    void UpdateSurfacePixel(SDL_Surface* surface, int xPos, int yPos){
        // When we modify pixels, we need to lock the surface first
        SDL_LockSurface(surface);
        // Make sure to unlock the surface when we are done.
        scope(exit) SDL_UnlockSurface(surface);

        // Retrieve the pixel arraay that we want to modify
        ubyte* pixelArray = cast(ubyte*)surface.pixels;
        // Change the 'blue' component of the pixels
        pixelArray[yPos*surface.pitch + xPos*surface.format.BytesPerPixel+0] = 255;
        // Change the 'green' component of the pixels
        pixelArray[yPos*surface.pitch + xPos*surface.format.BytesPerPixel+1] = 128;
        // Change the 'red' component of the pixels
        pixelArray[yPos*surface.pitch + xPos*surface.format.BytesPerPixel+2] = 32;
    }

  /* Changing pixel value for position (x,y) to the given r,g,b values. */
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


    /* Fetching pixel's struct and r,g,b value at position (x,y). */
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