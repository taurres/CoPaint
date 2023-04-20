# Building Software

- [ ] Instructions on how to build your software should be written in this file
	- This is especially important if you have added additional dependencies.
	- Assume someone who has not taken this class (i.e. you on the first day) would have read, build, and run your software from scratch.
- You should have at a minimum in your project
	- [ ] A dub.json in a root directory
    	- [ ] This should generate a 'release' version of your software
  - [ ] Run your code with the latest version of d-scanner before commiting your code (could be a github action)
  - [ ] (Optional) Run your code with the latest version of clang-tidy  (could be a github action)

*Modify this file to include instructions on how to build and run your software. Specify which platform you are running on. Running your software involves launching a server and connecting at least 2 clients to the server.*

## Platform used: MacOS Silicon

## Installing and setting up dub
- The **releases** for Dub are hosted here: https://github.com/dlang/dub/releases
	- You can scroll down and click 'Assets' and you should find an archive file for your operating system
- Dub installed through operating system package managers
	- Linux:
		- For folks who installed dmd, you should already have dub.
		- Otherwise, you can try `sudo apt-get install dub` 
	- Mac:
		- If Mac users were unable to install through the 'releases' on github, then you can try:
		- Installing https://brew.sh/ - a package manager for Mac that you use on the terminal.
		- Then try `brew install dub` on the command line (and wait a few seconds or minutes to install)
		- Note: Some Mac users may get errors and need to run: `export MACOSX_DEPLOYMENT_TARGET=11` before running dub.
	- Window: 
		- It is also likely that if you setup dmd, you should be able to use dub from the terminal as well.
		- Windows folks should be able to install from the zip file and the releases if they otherwise do not have dub available.
- To know more about creating a project using dub and bindbc-sdl [this](https://github.com/Spring23FSE/monorepo-gokriznastic/tree/main/Assignment5_Dub_Patterns/warmup) resource can be referred.

## Setting up the paint application
1. User must clone the application from the github repository given [here](https://github.com/Spring23FSE/finalproject-d-evelopers).
2. Next the user must open a terminal and navigate to `FinalProject/src/source` directory in the project and run the server and specify the hostname, port number and the maximum number of clients using the command: `rdmd network/server.d localhost 8000 3`.
3. Next, in a new terminal, you can run the client by running the command `dub run -- localhost 8000` in the `FinalProject/src` directory.
4. The user can create more clients by following the step 3.

## Features of the paint application
1. The users can draw on the paint application by drawing strokes using their mouse.
2. The users can undo their actions.
3. The users can redo their actions.
4. Extra Feature: Users could pick from 3 color options available: red, blue and green.
5. Extra Feature: The users can increase and decrease the thickness of their stroke by increasing or decreasing the brush size.
6. Extra Feature: The users can erase their strokes.

## Using the application
1. After setting up the application the clients can start to collaboratively draw on the canvas using the mouse.
2. Every time a new client joins, their default color is different. i.e. for eg. when client 1 joins their default color of the brush is blue, when client 2 joins their default color of the brush will be set to red and when the client 3 joins their default color is set to green. Even though all clients are assigned a different color, they can switch to a different color whenever they wish to as explained below.
3. The user can draw strokes using their mouse.
4. The user can change the colors of the strokes by pressing the r,g,b keys on the keyboard or by clicking on the red, blue or green buttons from the bottom panel on the canvas. 
    - Pressing the key `r` or clicking the red button changes the color of the new strokes to red.
    - Pressing the key `g` or clicking the green button changes the color of the new strokes to green.
    - Pressing the key `b` or clicking the blue button changes the color of the new strokes to blue.
5. The user can change the brush size by pressing the up and down arrow keys from the keyboard or clicking the dark or light grey buttons from the canvas.
    - Pressing the `up arrow` key or clicking the dark grey button increases the size of the brush.
    - Pressing the `down arrow` key or clicking the light grey button decreases the size of the brush.
6. The users can erase their strokes by switching to erase mode. The user can switch to erase mode by pressing the keys `cmd + e` or clicking the white button on the bottom of the canvas. Once the user is done, they can toggle back to draw mode by pressing the keys `cmd + e` again or clicking the white button again.
7. The user can undo their actions by pressing on the `cmd + z` keys simultaneously or clicking the purple button from the bottom panel in the canvas.
8. The user can redo their undone actions by pressing on the `cmd + y` keys simultaneously or clicking the brown button from the bottom panel in the canvas.

*_We initially wanted to use GTKD for a better user interface, but had difficulties implementing this as all of our group members were using mac silicon. We decided to use SDL itself to create the GUI, but ended up with a very simplistic GUI because to difficulties displaying images or text in SDL due to deprecated libraries_*