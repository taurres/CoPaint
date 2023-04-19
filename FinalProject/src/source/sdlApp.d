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

        //Boundary method: 
        bool boundary_function(int xPos, int yPos, int xMin, int yMin, int xMax, int yMax){
            if ((xMin < xPos) & (xPos < xMax)){
                if ((yMin < yPos) & (yPos < yMax)){
                    return true;
                }
            }
            return false;

        }

        int getBrushSize(){
            return this.brushSize;
        }

        /**
        void drawButtons(Surface instance){
            for(int i = 10; i < 100; i+=5){
                for(int j = 490; j < 515; j+=5){
                    // Loop through and update specific pixels
                    this.brushSize = 10;
                    for(int w=-brushSize; w < brushSize; w++){
                        for(int h=-brushSize; h < brushSize; h++){
                            instance.changePixel(i+w, j+h, 255, 0, 0);
                        }
                    }
                    
                }
            }

            //draw U
            for(int j = 495; j < 510; j+=5){
                // Loop through and update specific pixels
                this.brushSize = 10;
                for(int w=-brushSize; w < brushSize; w++){
                    for(int h=-brushSize; h < brushSize; h++){
                        instance.changePixel(35, j+h, 255, 255, 255);
                        instance.changePixel(65, j+h, 255, 255, 255);
                    }
                }
                
            }

            for(int i = 45; i < 60; i+=5){
                // Loop through and update specific pixels
                this.brushSize = 10;
                for(int w=-brushSize; w < brushSize; w++){
                    for(int h=-brushSize; h < brushSize; h++){
                        instance.changePixel(i+w, 515, 255, 255, 255);
                        instance.changePixel(i+w, 515, 255, 255, 255);
                    }
                }
                
            }

        }
        */


 		/// global variable for sdl;
		const SDLSupport ret;

        /**
         * This method will handle the main application loop.
         */
 		void MainApplicationLoop(string host, ushort port){
			// Create an SDL window
            SDL_Window* window= SDL_CreateWindow("D SDL Painting",
                                        SDL_WINDOWPOS_UNDEFINED,
                                        SDL_WINDOWPOS_UNDEFINED,
                                        640,
                                        520,
                                        SDL_WINDOW_SHOWN);

            // Load the bitmap surface
            Surface instance = Surface(1);

            // Accessing imgSurface from surface struct
            SDL_Surface* imgSurface = instance.getSurface();

            // start client
            client = new Client(host, port, &instance);
            client.run();

            

            
            //DRAW BUTTONS: 
            //drawButtons(instance);
            //INCREASE BRUSH SIZE
            for(int i = 10; i < 100; i+=5){
                for(int j = 490; j < 515; j+=5){
                    // Loop through and update specific pixels
                    this.brushSize = 10;
                    for(int w=-brushSize; w < brushSize; w++){
                        for(int h=-brushSize; h < brushSize; h++){
                            instance.changePixel(i+w, j+h, 255, 0, 0);
                        }
                    }
                    
                }
            }
            /**
            //draw U
            for(int j = 495; j < 510; j+=5){
                // Loop through and update specific pixels
                this.brushSize = 10;
                for(int w=-brushSize; w < brushSize; w++){
                    for(int h=-brushSize; h < brushSize; h++){
                        instance.changePixel(35, j+h, 255, 255, 255);
                        instance.changePixel(65, j+h, 255, 255, 255);
                    }
                }
                
            }

            for(int i = 45; i < 60; i+=5){
                // Loop through and update specific pixels
                this.brushSize = 10;
                for(int w=-brushSize; w < brushSize; w++){
                    for(int h=-brushSize; h < brushSize; h++){
                        instance.changePixel(i+w, 515, 255, 255, 255);
                        instance.changePixel(i+w, 515, 255, 255, 255);
                    }
                }
                
            }
            */

            //DECREASE
            for(int i = 110; i < 200; i+=5){
                for(int j = 490; j < 515; j+=5){
                    // Loop through and update specific pixels
                    this.brushSize = 10;
                    for(int w=-brushSize; w < brushSize; w++){
                        for(int h=-brushSize; h < brushSize; h++){
                            instance.changePixel(i+w, j+h, 37, 218, 49);
                        }
                    }
                    
                }
            }
            //UNDO
            for(int i = 210; i < 300; i+=5){
                for(int j = 490; j < 515; j+=5){
                    // Loop through and update specific pixels
                    this.brushSize = 10;
                    for(int w=-brushSize; w < brushSize; w++){
                        for(int h=-brushSize; h < brushSize; h++){
                            instance.changePixel(i+w, j+h, 162, 108, 255);
                        }
                    }
                    
                }
            }

            //REDO
            for(int i = 310; i < 400; i+=5){
                for(int j = 490; j < 515; j+=5){
                    // Loop through and update specific pixels
                    this.brushSize = 10;
                    for(int w=-brushSize; w < brushSize; w++){
                        for(int h=-brushSize; h < brushSize; h++){
                            instance.changePixel(i+w, j+h, 229, 169, 48);
                        }
                    }
                    
                }
            }
            //ERASE
            for(int i = 410; i < 500; i+=5){
                for(int j = 490; j < 515; j+=5){
                    // Loop through and update specific pixels
                    this.brushSize = 10;
                    for(int w=-brushSize; w < brushSize; w++){
                        for(int h=-brushSize; h < brushSize; h++){
                            instance.changePixel(i+w, j+h, 255, 255, 255);
                        }
                    }
                    
                }
            }

            this.brushSize = 1;


			// Flag for determing if we are running the main application loop
            bool runApplication = true;
            // Flag for determining if we are 'drawing' (i.e. mouse has been pressed
            //                                                but not yet released)
            bool drawing = false;

            // Main application loop that will run until a quit event has occurred.
            // This is the 'main graphics loop'
            while(runApplication){
                int xPos;
                int yPos;
                
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
                        xPos = e.button.x;
                        yPos = e.button.y;

                        if(boundary_function(xPos, yPos, 0, 480, 100, 520)){
                            increase_brush();
                        }
                        else if(boundary_function(xPos, yPos, 100, 480, 200, 520)){
                            decrease_brush();
                        }
                        else if(boundary_function(xPos, yPos, 200, 480, 300, 520)){
                            writeln("Call UNDO");
                            Command undoCommand = new UndoCommand();
                            client.sendToServer(undoCommand);
                        }
                        else if(boundary_function(xPos, yPos, 300, 480, 400, 520)){
                            Command redoCommand = new RedoCommand();
                            client.sendToServer(redoCommand);
                        }
                        else if(boundary_function(xPos, yPos, 400, 480, 500, 520)){
                            erase = erase? false:true;
                            writeln(erase);
                        }
                    }else if(e.type == SDL_MOUSEBUTTONUP && e.button.button == SDL_BUTTON_LEFT){
                        drawing=false;
                    }
                    // BRUSHSIZE
                    else if(e.type == SDL_KEYDOWN){
                        // writeln("Debug: e", e.key.keysym.sym);
                        /**
                        if (e.key.keysym.sym == SDLK_UP){
                            increase_brush();
                        }
                        else if (e.key.keysym.sym == SDLK_DOWN){
                            decrease_brush();
                        }
                        */
                        //UNDO
                        //else 
                        if (e.key.keysym.sym == SDLK_z && (SDL_GetModState() & KMOD_LGUI) 
                            && (e.key.keysym.mod & KMOD_LGUI || e.key.keysym.mod & KMOD_RGUI)){
                            /**
                            writeln("Call UNDO");
                            Command undoCommand = new UndoCommand();
                            client.sendToServer(undoCommand);
                            */
                        }
                        // REDO
                        else if (e.key.keysym.sym == SDLK_r && (SDL_GetModState() & KMOD_LGUI) 
                            && (e.key.keysym.mod & KMOD_LGUI || e.key.keysym.mod & KMOD_RGUI)){
                            /**
                            Command redoCommand = new RedoCommand();
                            client.sendToServer(redoCommand);
                            */
                        }
                        //ERASE
                        else if (e.key.keysym.sym == SDLK_e && (SDL_GetModState() & KMOD_LGUI) 
                            && (e.key.keysym.mod & KMOD_LGUI || e.key.keysym.mod & KMOD_RGUI)){
                            /**
                            erase = erase? false:true;
                            writeln(erase);
                            */
                        }
                    }
                    // DRAW or ERASE
                    else if(e.type == SDL_MOUSEMOTION && drawing){
                        // retrieve the position
                        xPos = e.button.x;
                        yPos = e.button.y;
                        if (boundary_function(xPos, yPos, 1, 1, 639, 479) == true){

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
