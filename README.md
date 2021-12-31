# Escape Through Space
#### Video Demo: https://youtu.be/qbFYNdT5sNQ
#### Description:
My project is an arcade style retro game, inspired by titles such as Atari's [Asteroids](https://en.wikipedia.org/wiki/Asteroids_(video_game)).
I had this idea of a game in which you have to dodge obstacles in space. With the catch being that there is no drag in space, so that if you want to stop, you have to fly in the opposite direction.

The player can move in four directions using the W, A, S, D keys, and shoot in four directions using the arrow keys. The player can select a difficulty in the main menu and change the volume of the game sound. The difficulty scales the amount, speed and spawn rate of the enemies, with easy being a 0.75 modifier, medium being 1 and hard being 1.25

The goal is to survive for 30 seconds, but the player can still score points even when they die. You score points by destroying enemy ships, by surviving the 30 second timer, or by surviving without destroying a single enemy. Scores change based on the difficulty selected.

The game has three main states, the main menu, the play state and the results state. For the play state, I chose a song that builds up in intensity as the timer approaches the 30 second mark, so that the player feels greater excitement.

## What each file does
push.lua and class.lua are both free pieces of code made by other great developers.
- ### push.lua
push.lua is used for creating a virtual window of a specified resolution inside the game window. This is good because the player can resize the window as they want and the game adjusts naturally.
- ### class.lua
class.lua is used to make a feature common to most object-oriented-programming languages available in a lua in a way people familiar with other forms OOP such as C# can grasp more easily.
- ### StateMachine.lua
StateMachine.lua is used to control and change between states. I learned this from Lecture 1 of GD50. In main.lua, it is stored in a global variable, gStateMachine, and that is how it is used in the program.
- ### main.lua
In main.lua the program is initialized and all other objects are called back to. It is the first file loaded when the game starts. Here the resolution, window settings and all necessary files, with the exception of some imgs, are loaded. It also handles the background scrolling of the stars.
- ### Enemy.lua
Enemy.lua contains the enemy's logic and behavior. Once an Enemy.lua instance is created, an enemy is created in the game.
- ### Player.lua
Player.lua contains the player's logic. Here it checks, for instance, whether the W key was pressed this frame, and if so, updates the player's acceleration.
- ### Tiro.lua
Tiro.lua is the object that corresponds to the laser beam shot by the player. "Tiro" in portuguese means "Shot".

## states Folder
- ### BaseState.lua
BaseState.lua also comes from Lecture 1 of GD50. It is used to create the functions necessary for every state class. This way, if a state class does not use one of its functions, it is not necessary to declare it. An example of this is the ResultsState.lua class, it does have an init() function, but because it inherits BaseState, it does not need to declare one.
- ### PlayState.lua
PlayState.lua is where almost all the logic for the level happens, level timer, the enemies table and the player are all managed here.
- ### ResultsState.lua
ResultsState.lua is where the logic for the rendering of the results screen happens. It changes depending on the parameters sent by the PlayState, such as the score and whether the player died or won.
- ### StartState.lua
StartState.lua contains the logic and redering of the menu and options screen.

## Other Files
- ### imgs Folder
The imgs folder contains all the visual assets used in the game. All of them were created using the program [Aseprite](https://www.aseprite.org/).
- ### sfx Folder
Here the audio files are stored, PlayMusic.wav is an edited version of the song [Milky Jam 2.wav](https://freesound.org/people/BaDoink/sounds/573337/) by user [BaDoink](https://freesound.org/people/BaDoink/). menu.wav is an edited version of [8-bit Brisk Music Loop.wav](https://freesound.org/people/EVRetro/sounds/583613/) made by user [EVRetro](https://freesound.org/people/EVRetro/).

Both of these songs I found on the website https://freesound.org/

For the editing of these tracts I used [Audacity](https://www.audacityteam.org/)

The other sound effects were made using the software [Bfxr](https://www.bfxr.net/).

- ### .ttf Files
These are the fonts used in the game. All of them where found in the website https://www.dafont.com/

Links to the fonts used:

[Linebeam.ttf](https://www.dafont.com/linear-beam.font)

[ARCADECLASSIC.TTF](https://www.dafont.com/pt/arcade-classic-2.font)

[Open 24 Display St.ttf](https://www.dafont.com/pt/open-24-display-st.font)