import std.stdio;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;
import surface;

@("Unit Test 2")
unittest{
	Surface s = Surface(1);
	int x = 30;
	int y = 20;
	ubyte r = 250;
	ubyte g = 210;
	ubyte b = 175;
	s.changePixel(x, y, r, g, b);

	SDL_Color pixel = s.pixelAt(30, 20);
	assert(pixel.r == r, "Pixel's red value is incorrect.");
	assert(pixel.g == g, "Pixel's green value is incorrect.");
	assert(pixel.b == b, "Pixel's blue value is incorrect.");
	writeln("Unit test 2 Passed: Testing if the colour of a pixel gets updated.");
}