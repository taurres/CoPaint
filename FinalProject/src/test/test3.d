import std.stdio;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;
import surface;

@("Unit Test 3")
unittest{
	Surface s = Surface(1);
	int x = 25;
	int y = 30;
	ubyte r = 32;
	ubyte g = 128;
	ubyte b = 255;
	s.UpdateSurfacePixel(x, y);

	SDL_Color pixel = s.pixelAt(x, y);
	assert(pixel.r == r, "Pixel's red value is incorrect.");
	assert(pixel.g == g, "Pixel's green value is incorrect.");
	assert(pixel.b == b, "Pixel's blue value is incorrect.");
	writeln("Unit test 3 Passed: Testing if the UpdateSurfacePixel function updates the pixels in a surface to a 'blue-ish' color.");
}
