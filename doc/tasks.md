# Task Tracker

## Assets

* [X] Ground
* [X] Trainyard
* TrainStation
UI


### Train

* [X] Train caboose vertical
* [X] Train caboose horizontal

### Rails

* [X] Rail Straight
* [X] Rail turn 90
* [X] Rail straight + turn 90


### MINI RAILWAYS

* Producers produce a good that must be picked up
* A train will wait at a producer if there is no good
* If a producer idles too long, the game is over
* Main rail station clock is level-up clock of the game


## how to make rail car follow train

* Just bind it and rotate it when the train moves

* Keep track of current tile and my train's tile
* when my train switches direction and then I leave my current tile, go to my trains new direction


### CODE

* Make train station spawn resource and animate [4 hours]
	* [x] Make pixel art for train station [30 minutes]
	* [x] Train station timer to generate resources [30 minutes]
	* [x] Make train stations navigable with the rail system [30 minutes]
	* [x] Make train stop when it goes to a station
	* [x] Add sound for when a train picks up a load [30 minutes]
	* [x] Make train picking up load visually distinctive [2 hours hour]
	* [x] Make Wagon Pixel Art
	* [x] If producer sits idle with a resource, count DOWN [15 minutes]
		* [x] Add a ticking clock sound when a producer is about to run out [15 minutes]
* [x] Make going a train to a trainyard drops off train load [1 hour]
	* [x] Add sound for when a train drops off a load [15 minutes]
* [x] Make clicking on a junction rotate it [10 minutes]
	* [x] Play a sound [5 minutes]
* [x] Separate rotation junctions from X junctions [20 minutes]
* Make clicking on a tile pull up the build menu [1.5 hours]
	* [x] Highlight selectable tile with mouse [10 minutes]
	* [x] Highlight selected tile [10 minutes]
		* [x] Add sound for clicking on a tile [5 minutes]
	* [x] Build menu loads tiles you can place [30 minutes]
	* [x] Clicking on tile places at pre-clicked coordinates [5 minutes]
* [x] Add a UI to the bottom left showing current stored improvements [10 minutes]
	* [x] Add system for keeping track of current tiles [10 minutes]
	* [x] Make system work with build tile system
* [x] Add sound for building a track [5 minutes]
* [x] Add support for removing a track
* [x] Add defeat logic and screen [30 minutes]
	* [x] When a defeat happens, slowly prompt user with their high score [10 minutes]
	* [x] Add a button to replay [5 minutes]
	* [x] Add a sound when defeat happens appropriately to what caused the defeat [5 minutes]
* [x] Make production spawner
	* [x] Every 60 seconds
		* [x] Generate a new train station
			* [x] Find space to put it into world
			* [x] Place it
* [x] Make trains die if they go off rails
* [x] Animate production timer (both ways) [30 minutes]
* [x] Add camera movement, zoom, pan [30 minutes]
* [x] Add a tracker for how long the game has been running [10 minutes]
* [x] Add a tracker for the amount of loads the player has shipped [10 minutes]
* [x] Make trains colliding with trains destroy themselves

BUG TRACKER

* [x] Trains do not die anymore when they enter some rotations
* [x] If a train dies while holding a wagon, the wagon will not disappear
* [x] You can delete the tracks underneath the production stations
* [x] Trains do not collide with rotations anymore
* [x] You cannot rotate tiles
* [x] fix the clock ticking down
* [x] Trains "skip"
* Sometimes wagons really glitch the fuck out
	* confirmed this still happens

WATCHING EMILY PLAY NOTES

* [x] how to pick tiles is non obvious
* How to delete tiles in non obvious
* [x] timer starts too late for doom
* [x] game idles too long without spawning another thing
* [x] direction at the very beginning is zero and looks sad

## BONUS IMPROVEMENTS

* [x] When trains die they should play a sound

## MORNING THOUGHTS

* You have an upper amount of trains, losing one lets you spawn another
* Slowly zoom out the camera for increased visual appeal
* audio is still broken sometimes on score screen


UI BONUSES

* Improve Main Menu
* [x] Tutorial

ANIMATION BONUSES
* [x] Add smoke animation to train
* Improve train movement animation
* Add birds or critters
* Add animation for rotating the junctions
* Animate trian dropping off train load [1 hour]
* Animate trian picking up train load [1 hour]

SOUND BONUSES
* Add background music during play time [15 minutes]
	* Find background music [15 minutes]
* [x] Add train movement sounds
	* [x] Find train movement sounds [30 minutes]
	* Make it start loud and go to the background as more trains are added [30 minutes]

BONUSES
* Make trains idleable
	* Tapping on a train will stop it
		* Plays Sound
	* Tapping on a stopped train will start it
		* Plays sound
* [x] Add a "recycle" button
	* [x] Clicking it transforms build menu mode to be recycle
	* [x] Destroying tiles lets you place them again
	* [x] Add ability to recycle junction tiles


## Log Assets

* Kenney
* https://pixabay.com/sound-effects/search/train-chugging/
