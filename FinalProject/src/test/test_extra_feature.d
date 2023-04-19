import std.stdio;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;
import surface;
import sdlApp;

@("Unit Test 1 for Extra Feature")
unittest{
    SDLApp myApp = new SDLApp();
    assert( myApp.getBrushSize() == 1, "Initial brushsize is incorrect");
    myApp.increase_brush();
    assert( myApp.getBrushSize() == 2, "Brushsize is incorrect");
    myApp.increase_brush();
    assert( myApp.getBrushSize() == 3, "Brushsize is incorrect");
    myApp.increase_brush();
    assert( myApp.getBrushSize() == 4, "Brushsize is incorrect");
    myApp.increase_brush();
    assert( myApp.getBrushSize() == 5, "Brushsize is incorrect");
    myApp.decrease_brush();
    assert( myApp.getBrushSize() == 4, "Brushsize is incorrect");
    myApp.decrease_brush();
    assert( myApp.getBrushSize() == 3, "Brushsize is incorrect");
    myApp.decrease_brush();
    assert( myApp.getBrushSize() == 2, "Brushsize is incorrect");
    myApp.decrease_brush();
    assert( myApp.getBrushSize() == 1, "Brushsize is incorrect");

    writeln("Unit test for extra feature passed: Testing if the increase_brush and decrease_brush functions work");
}


