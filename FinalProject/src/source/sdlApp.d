module sdlApp;

// Import D standard libraries
import std.stdio;
import std.string;
import surface;
import command;

import network.deque;
import network.client;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;

/**
 * SDLApp is a class that will handle the initialization of SDL and the main
 * application loop. This class will also handle the creation of the SDL window
 * and the SDL surface that will be used for drawing. It also brings up the client
 * to connect to the server.
 */
class SDLApp{
    Client client;

        /**
         * Constructor
         * This constructor will handle the initialization of SDL and the creation of the SDL window.
         */
 		this(){
 			// Handle initialization...
 			// SDL_Init
			// Load the SDL libraries from bindbc-sdl
            // on the appropriate operating system
            version(Windows){
                writeln("Searching for SDL on Windows");
                ret = loadSDL("SDL2.dll");
            }
            version(OSX){
                writeln("Searching for SDL on Mac OSX");
                ret = loadSDL();
            }
            version(linux){ 
                writeln("Searching for SDL on Linux");
                ret = loadSDL();
            }

            // Error if SDL cannot be loaded
            if(ret != sdlSupport){
                writeln("error loading SDL library");

                foreach( info; loader.errors){
                    writeln(info.error,':', info.message);
                }
            }
            if(ret == SDLSupport.noLibrary){
                writeln("error no library found");
            }
            if(ret == SDLSupport.badLibrary){
                writeln("Eror badLibrary, missing symbols, perhaps an older or very new version of SDL is causing the problem?");
            }

            // Initialize SDL
            if(SDL_Init(SDL_INIT_EVERYTHING) !=0){
                writeln("SDL_Init: ", fromStringz(SDL_GetError()));
            }
 		}

        /**
         * Destructor
         * This destructor will handle the cleanup of SDL and the destruction of the SDL window.
         */
 		~this(){
            // Quit the SDL Application
            SDL_Quit();
	        writeln("Ending application--good bye!");
 		}

        /// Flag for determing if we are running the main application loop
        bool runApplication = true;
        /// Flag for determining if we are 'drawing' (i.e. mouse has been pressed but not yet released)
        bool drawing = false;
        /// Flag for determining if we are erasing
        bool erase = false;
        /// brush size on canvas
        int brushSize = 1;

        // change these to get inputs from GUI button clicks later
        void increase_brush(){
            if (brushSize <= 50){
                brushSize = brushSize + 1;
            }
        }

        void decrease_brush(){
            if (brushSize > 1){
                brushSize = brushSize - 1;
            }
        }

        int getBrushSize(){
            return this.brushSize;
        }


 		/// global variable for sdl;
		const SDLSupport ret;

        /**
         * This method will handle the main application loop.
         */
 		void MainApplicationLoop(){
			// Create an SDL window
            SDL_Window* window= SDL_CreateWindow("D SDL Painting",
                                        SDL_WINDOWPOS_UNDEFINED,
                                        SDL_WINDOWPOS_UNDEFINED,
                                        640,
                                        480,
                                        SDL_WINDOW_SHOWN);

            // Load the bitmap surface
            Surface instance = Surface(1);

            // Accessing imgSurface from surface struct
            SDL_Surface* imgSurface = instance.getSurface();

            // start client
            client = new Client(&instance);
            client.run();

			// Flag for determing if we are running the main application loop
            bool runApplication = true;
            // Flag for determining if we are 'drawing' (i.e. mouse has been pressed
            //                                                but not yet released)
            bool drawing = false;

            // Main application loop that will run until a quit event has occurred.
            // This is the 'main graphics loop'
            while(runApplication){
                SDL_Event e;
                // Handle events
                // Events are pushed into an 'event queue' internally in SDL, and then
                // handled one at a time within this loop for as many events have
                // been pushed into the internal SDL queue. Thus, we poll until there
                // are '0' events or a NULL event is returned.
                while(SDL_PollEvent(&e) !=0){
                    if(e.type == SDL_QUIT){
                        runApplication= false;
                        client.close();
                    }
                    else if(e.type == SDL_MOUSEBUTTONDOWN && e.button.button == SDL_BUTTON_LEFT){
                        drawing=true;
                    }else if(e.type == SDL_MOUSEBUTTONUP && e.button.button == SDL_BUTTON_LEFT){
                        drawing=false;
                    }
                    // BRUSHSIZE
                    else if(e.type == SDL_KEYDOWN){
                        // writeln("Debug: e", e.key.keysym.sym);
                        if (e.key.keysym.sym == SDLK_UP){
                            increase_brush();
                        }
                        else if (e.key.keysym.sym == SDLK_DOWN){
                            decrease_brush();
                        }
                        //UNDO
                        else if (e.key.keysym.sym == SDLK_z && (SDL_GetModState() & KMOD_LGUI) 
                            && (e.key.keysym.mod & KMOD_LGUI || e.key.keysym.mod & KMOD_RGUI)){
                            debug writeln("Call UNDO");
                            Command undoCommand = new UndoCommand();
                            client.sendToServer(undoCommand);
                        }
                        // REDO
                        else if (e.key.keysym.sym == SDLK_y && (SDL_GetModState() & KMOD_LGUI) 
                            && (e.key.keysym.mod & KMOD_LGUI || e.key.keysym.mod & KMOD_RGUI)){
                            Command redoCommand = new RedoCommand();
                            client.sendToServer(redoCommand);
                        }
                        //ERASE
                        else if (e.key.keysym.sym == SDLK_e && (SDL_GetModState() & KMOD_LGUI) 
                            && (e.key.keysym.mod & KMOD_LGUI || e.key.keysym.mod & KMOD_RGUI)){
                            erase = erase? false:true;
                            writeln(erase);
                        }
                        // RED
                        else if (e.key.keysym.sym == SDLK_r){
                            debug writeln("red");
                        }
                        // GREEN
                        else if (e.key.keysym.sym == SDLK_g){
                            debug writeln("green");
                        }
                        // BLUE
                        else if (e.key.keysym.sym == SDLK_b){
                             debug writeln("blue");
                        }
                    }
                    // DRAW or ERASE
                    else if(e.type == SDL_MOUSEMOTION && drawing){
                        // retrieve the position
                        int xPos = e.button.x;
                        int yPos = e.button.y;

                        if(!erase) {
                            // create command
                            Command updatePixel = new DrawCommand(xPos,yPos,this.brushSize);
                            // execute command and send command to client
                            instance.setCommand(updatePixel);
                            instance.executeCommand();
                            client.sendToServer(updatePixel);
                        } else {
                            writeln("ERASESEEEEEE");
                            Command eraseCommand = new EraseCommand(xPos, yPos, this.brushSize);
                            instance.setCommand(eraseCommand);
                            instance.executeCommand();
                            client.sendToServer(eraseCommand);
                        }
                        
                    }
                }

                // Blit the surace (i.e. update the window with another surfaces pixels
                //                       by copying those pixels onto the window).
                SDL_BlitSurface(imgSurface,null,SDL_GetWindowSurface(window),null);
                // Update the window surface
                SDL_UpdateWindowSurface(window);
                // Delay for 10 milliseconds
                // Otherwise the program refreshes too quickly
                SDL_Delay(10);
            }

            // Destroy our window
            SDL_DestroyWindow(window);
		 }
 	}
