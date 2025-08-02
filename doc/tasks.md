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
	* Animate said timer (both ways) [30 minutes]
* [x] Make going a train to a trainyard drops off train load [1 hour]
	* Animate trian dropping off train load [1 hour]
	* [x] Add sound for when a train drops off a load [15 minutes]
* [x] Make clicking on a junction rotate it [10 minutes]
	* [x] Play a sound [5 minutes]
* [x] Separate rotation junctions from X junctions [20 minutes]
* Make clicking on a tile pull up the build menu [1.5 hours]
	* Highlight selectable tile with mouse [10 minutes]
	* Highlight selected tile [10 minutes]
		* Add sound for clicking on a tile [5 minutes]
	* Add system for keeping track of current tiles [10 minutes]
	* Build menu loads tiles you can place [30 minutes]
	* Clicking on tile places at pre-clicked coordinates [5 minutes]
		* Add sound for building a track [5 minutes]
* Add camera movement, zoom, pan [30 minutes]
* Add a UI to the bottom left showing current stored improvements [10 minutes]
* Add tile improvement selector [3 hours]
	* Every 60 seconds
		* Generate a new train station
			* Find space to put it into world
			* Place it
		* Pull up a pick-three menu to load resources
			* Train
				* Spawns at the root railyard, Idled
			* Rail - horizontal
			* Rail - vertical
			* Junction - X
			* Junction - Rotate
	* Add a ticking clock sound when a levelup is about to happen [15 minutes]
	* Build menu for selecting improvements [30 minutes]
* Add a tracker for how long the game has been running [10 minutes]
* Add a tracker for the amount of loads the player has shipped [10 minutes]
* Add defeat logic and screen [30 minutes]
	* When a defeat happens, slowly prompt user with their high score [10 minutes]
	* Add a button to replay [5 minutes]
	* [x] Add a sound when defeat happens appropriately to what caused the defeat [5 minutes]


BONUSES
* Pause Game
	* Plays sound on pause
	* Plays sound un unpause
* Make trains idleable
	* Tapping on a train will stop it
		* Plays Sound
	* Tapping on a stopped train will start it
		* Plays sound
* Add a "recycle" button
	* Clicking it transforms build menu mode to be recycle
	* Destroying tiles lets you place them again

ANIMATION BONUSES
* Add train derailment animation and effect
* Add smoke animation to train
* Improve train movement animation
* Add birds or critters
* Add animation for rotating the junctions

SOUND BONUSES
* Add background music during play time [15 minutes]
	* Find background music [15 minutes]
* Add train movement sounds
	* Find train movement sounds [30 minutes]
	* Make it start loud and go to the background as more trains are added [30 minutes]

UI BONUSES

* Main Menu
* Tutorial

BONUSES
* Make work on mobile
* Tune starting resources, timers, level ups


