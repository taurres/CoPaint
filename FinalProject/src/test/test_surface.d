import std.stdio;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;
import surface;


@("Unit Test 1: Testing changePixel method ")
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

@("Unit Test 2: Testing pixel at method")
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

@("Unit Test 3: Testing UpdateSurfacePixel")
unittest{
	Surface s = Surface(1);
	int x = 25;
	int y = 30;
	ubyte r = 0;
	ubyte g = 0;
	ubyte b = 255;
	s.UpdateSurfacePixel(x, y);

	SDL_Color pixel = s.pixelAt(x, y);
	assert(pixel.r == r, "Pixel's red value is incorrect.");
	assert(pixel.g == g, "Pixel's green value is incorrect.");
	assert(pixel.b == b, "Pixel's blue value is incorrect.");
	writeln("Unit test 3 Passed: Testing if the UpdateSurfacePixel function updates the pixels in a surface to a 'blue-ish' color.");
}