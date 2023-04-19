import std.stdio;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;
import surface;
import command;


@("Unit Test: Test Draw command")
unittest{
	Surface s = Surface(1);
	int x = 15;
	int y = 10;
	int brushSize = 4;
	Command drawCmd = new DrawCommand(x,y,brushSize);
	s.setCommand(drawCmd);
	s.executeCommand();

	SDL_Color pixel = s.pixelAt(15, 10);
	assert(pixel.r == 0, "Pixel's red value is incorrect.");
	assert(pixel.g == 0, "Pixel's green value is incorrect.");
	assert(pixel.b == 255, "Pixel's blue value is incorrect.");
}

@("Unit Test: Test Erase command")
unittest{
	Surface s = Surface(1);
	int x = 15;
	int y = 10;
	int brushSize = 4;
	Command drawCmd = new DrawCommand(x,y,brushSize);
	s.setCommand(drawCmd);
	s.executeCommand();

	SDL_Color pixel = s.pixelAt(15, 10);
	assert(pixel.r == 0, "Pixel's red value is incorrect.");
	assert(pixel.g == 0, "Pixel's green value is incorrect.");
	assert(pixel.b == 255, "Pixel's blue value is incorrect.");

	Command erase = new EraseCommand(15,10,4);
	s.setCommand(erase);
	s.executeCommand();

	SDL_Color erased_pixel = s.pixelAt(15, 10);
	assert(erased_pixel.r == 0, "Pixel's red value is incorrect.");
	assert(erased_pixel.g == 0, "Pixel's green value is incorrect.");
	assert(erased_pixel.b == 0, "Pixel's blue value is incorrect.");
}

@("Unit Test: Test Undo command")
unittest{
	Surface s = Surface(1);
	int x = 15;
	int y = 10;
	int brushSize = 4;
	Command drawCmd = new DrawCommand(x,y,brushSize);
	s.setCommand(drawCmd);
	s.executeCommand();

	SDL_Color pixel = s.pixelAt(15, 10);
	assert(pixel.r == 0, "Pixel's red value is incorrect.");
	assert(pixel.g == 0, "Pixel's green value is incorrect.");
	assert(pixel.b == 255, "Pixel's blue value is incorrect.");

	Command undoCmd = new UndoCommand(drawCmd);
	s.setCommand(undoCmd);
	s.executeCommand();

	SDL_Color new_pixel = s.pixelAt(15, 10);
	assert(new_pixel.r == 0, "Pixel's red value is incorrect.");
	assert(new_pixel.g == 0, "Pixel's green value is incorrect.");
	assert(new_pixel.b == 0, "Pixel's blue value is incorrect.");
}

// @("Unit Test: Test Redo command")
// unittest{
// 	Surface s = Surface(1);
// 	int x = 15;
// 	int y = 10;
// 	int brushSize = 4;
// 	Command drawCmd = new DrawCommand(x,y,brushSize);
// 	s.setCommand(drawCmd);
// 	s.executeCommand();

// 	SDL_Color pixel = s.pixelAt(15, 10);
// 	assert(pixel.r == 32, "Pixel's red value is incorrect.");
// 	assert(pixel.g == 128, "Pixel's green value is incorrect.");
// 	assert(pixel.b == 255, "Pixel's blue value is incorrect.");

// 	Command undoCmd = new UndoCommand(drawCmd);
// 	s.setCommand(undoCmd);
// 	s.executeCommand();

// 	SDL_Color pixel2 = s.pixelAt(15, 10);
// 	assert(pixel2.r == 0, "Pixel's red value is incorrect.");
// 	assert(pixel2.g == 0, "Pixel's green value is incorrect.");
// 	assert(pixel2.b == 0, "Pixel's blue value is incorrect.");

// 	Command redoCmd = new RedoCommand();
// 	s.setCommand();
// 	s.executeCommand();

// 	SDL_Color pixel3 = s.pixelAt(15, 10);
// 	assert(pixel3.r == 32, "Pixel's red value is incorrect.");
// 	assert(pixel3.g == 128, "Pixel's green value is incorrect.");
// 	assert(pixel3.b == 255, "Pixel's blue value is incorrect.");
// }