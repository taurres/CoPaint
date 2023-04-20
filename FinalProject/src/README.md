# Paint application

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