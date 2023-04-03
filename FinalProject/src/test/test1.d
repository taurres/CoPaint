import std.stdio;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;
import surface;


@("Unit Test 1")
unittest{
	Surface s = Surface(1);
	int x = 15;
	int y = 10;
	ubyte r = 200;
	ubyte g = 32;
	ubyte b = 64;
	s.changePixel(x, y, r, g, b);

	SDL_Color pixel = s.pixelAt(15, 10);
	assert(pixel.r == r, "Pixel's red value is incorrect.");
	assert(pixel.g == g, "Pixel's green value is incorrect.");
	assert(pixel.b == b, "Pixel's blue value is incorrect.");
	writeln("Unit test 1 Passed: Testing if the colour of a pixel gets updated.");
}