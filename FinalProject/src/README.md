# Paint application

## Setting up the paint application
1. User must clone the application from the github repository given [here](https://github.com/Spring23FSE/finalproject-d-evelopers).
2. Next the user must open a terminal and navigate to `FinalProject/src/source` directory in the project and run the server and specify the hostname, port number and the maximum number of clients using the command: `rdmd network/server.d localhost 8000 3`.
3. Next, in a new terminal, you can run the client by running the command `dub` in the `FinalProject/src` directory.
4. The user can create more clients by following the step 3.


## Using the application
1. After setting up the application the clients can start to collaboratively draw on the canvas using the mouse.
2. The user can draw strokes using their mouse.
3. The user can change the colors of the strokes by pressing the r,g,b keys on the keyboard. 
    - The key `r` changes the color of the new strokes to red.
    - The key `g` changes the color of the new strokes to green.
    - The key `b` changes the color of the new strokes to blue.
4. The users can erase their strokes by switching to erase mode. The user can switch to erase mode by pressing the keys `cmd + e`. Once the user is done, they can toggle back to draw mode by pressing the keys `cmd + e` again.
5. The user can undo their actions by pressing on the `cmd + z` keys simultaneously.
6. The user can redo their undone actions by pressing on the `cmd + y` keys simultaneously.