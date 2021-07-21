# Tenet

A [Tenet](https://www.imdb.com/title/tt6723592)-style prototype map for Warcraft III: Reforged.
It features time inversion a concept introduced by the movie which allows you to invert objects and change the direction of the time backwards for a limited amount of time.
During this time period only inverted objects can be used to interact with stuff.
When the time inversion has ended, the time goes forward again and all non-inverted objects can be used again.
The inverted objects are restored.
Time inversion allows you to influence events of the past and to reverse certain effects.

## Play the Map

* [Discord Server](https://discord.gg/sAePsKe56p)
* [Official download on Hiveworkshop](https://www.hiveworkshop.com/threads/tenet-0-9.334146/)
* [Current development version](./tenet0.9.w3x)

## Scenario: Stalsk-12

This is a very basic 2 vs 2 players map which recreates the final battle of Stalsk-12 from the movie Tenet with one additional player who can interfere in the events.
Tenet soldiers fight against Sator's men.
The Algorithm must be stolen by Tenet soldiers and brought to a certain location on the map in time.
Sator's men have to keep the Algorithm at its original location until the time is over.

The turnstile machine allows you to copy the Algorithm.
All Algorithms should be at the specific locations on the map.

### The Future/Inverted Gold Transports Player

One additional player can play the future.
The player has one non-inverted hero who has different abilities to send stuff from the future.
He/she does also control inverted gold transports which must be protected.
The player's goal is to secure as many gold transports as possible.

#### The Clock
 
The clock is a special item which allows you to reverse time for a little while.
This will undo events and allow you to change the past.
Other than the turnstile machine it does not just invert time but reverses events and then continues with the time flow in the same direction as before.
During the reversal of time, nothing can changed.
Currently, it is only available to the future player.

### The Turnstile Machine

There is one single turnstile machine on the map which can invert a group of units.
It must be conquered by units before it can be used.
Using it inverts the entered units and the global time.
When the time is inverted, all inverted units can be controlled again and all non-inverted units will be restored backwards in time automatically.
There is a time limit how long the global time can be inverted.
Besides the turnstile machine has a cooldown.
This improves the performance of the map and prevents some unfair strategies.

### Unoccupied Units

Some units belong to the player "Unoccupied" and can be used by any player when entering them.

### Vehicles

All vehicles must be occupied before using them.

### Ruined Buildings

Ruined buildings can be occupied by soldiers and be used as defensive positions.

#### The Train

The train is a vehicle which can be used by all players to transport units on the rails.
It is an experimental feature which does not have any special meaning for the scenario.
However, it is easier to be protected when using the train.

## Screenshots

|               |
| ------------- |
| ![Stalsk-12](./screenshots/Tenet1.png "Stalsk-12") |

## Videos

[![Videos of an early version of the scenario on YouTube](https://img.youtube.com/vi/rjkfyb1ot4k/0.jpg)](https://www.youtube.com/watch?v=rjkfyb1ot4k&list=PLmfeGbBvSVGCxbiaR7wz9FFEZrUI3nVAw&ab_channel=WarcraftIII%3AReforgedModifications)

## Concept of Time Inversion

* There is a global time which consist of a global clock (integer) which is increased constantly and added objects.
* The global time is either inverted or not.
* Every added object/unit is either inverted or not.
* Every object/unit has its own time line.
* A time line starts at a certain time (global clock) and consist of certain time points (time frame).
* Every time frame consists of change events for the object/unit.
* The change events can be anything and must be able to be inverted.
* If the global time is not inverted then all inverted objects/units will get restored all change events of their time line at the corresponding time frames.
* If the global time is inverted then all not inverted objects/units will get restored all change events of their time line at the corresponding time frames.
* If a unit is not restored it can be controlled again and its stored time line will be flushed, so we do not have to keep all changes which will be overriden.
* If a copy is created of a unit by going forward or backwards it will disappear if time goes back/forward to its creation.
* We can actually go backwards in time to a negative global clock value (so before the map has even started). Everything will disappear which has been created at the time 0.
* This kind of system allows us to minimize the stored changes and time lines.

### Limitations

Not all events in Warcraft III: Reforged can be reversed that easily.
There are tons of missing natives which require workarounds.
For example, the training progress for units cannot be changed.
Spells must be written customly to be reversed etc.
The system tries to use workarounds to invert as much stuff as possible.
Other things which can not be reversed, should at least be paused/stopped.

### TODO Interactions with inverted objects

Currently, restored objects will be invulnerable to prevent them from being changed.
Interacting with inverted items would be fun, too.
For example a unit can be restored and drop an inverted item at some point.
If you pick up the inverted item with a non-inverted hero, it should have the inverted effect!
If a restored inverted unit shoots at a non-inverted unit (if still possible), the non-inverted unit should be healed by this.

## Code

vJass implementation: [Tenet.j](./Tenet.j)

## AI

The map has basic AI support for computer players.
These are the AI scripts:

* [Tenet.ai](./ai/Tenet.ai): Focus on attacking the enemy.
* [Sator.ai](./ai/Sator.ai): Focus on defending their base.

The AI should build a base, collect ressources and attack with basic units.
It does not know how to handle vehicles, ruined buildings or the Turnstile machine.
It does not know how to complete the mission as Tenet.

## vJass Syntax Highlightings

On Windows I use my custom syntax highlightings from [syntaxhighlightings](https://github.com/tdauth/syntaxhighlightings) and place them in the directory `C:\Users\****\AppData\Local\org.kde.syntax-highlighting\syntax`.

## Blizzard's JASS Code

* [common.j](https://www.hiveworkshop.com/data/games/wc3/war3.w3mod/scripts/common.j)
* [Blizzard.j](https://www.hiveworkshop.com/data/games/wc3/war3.w3mod/scripts/blizzard.j)
* [common.ai](https://www.hiveworkshop.com/data/games/wc3/war3.w3mod/scripts/common.ai)

## Credits

* Map: Baradé
* [Tenet](https://www.imdb.com/title/tt6723592) (movie/idea): Christopher Nolan
* LinkedList modules: AGD (HiveWorkshop.com)
* TimerUtils: Vexorian
* ReverseAnimation: Pyrogasm
* Tank model and icon: Illidan(Evil)X (HiveWorkshop.com)
* Tank factory model: Mr. Bob (HiveWorkshop.com)
* Container model: Illidan(Evil)X (HiveWorkshop.com)
* Helicopter model: Kofi_Banan (HiveWorkshop.com)
* Railway models: SeW (HiveWorkshop.com)
* Train models: Kofi_Banan (HiveWorkshop.com)
* Humvee model: Kofi_Banan (HiveWorkshop.com)
* Turret models: MiniMage (HiveWorkshop.com)
* Jeep icon: Illidan(Evil)X (HiveWorkshop.com)
* RPG icon: Zombie (HiveWorkshop.com)
* Stinger icon: Zombie (HiveWorkshop.com)
* Ambulance model: skrab (HiveWorkshop.com)
* Police car model: skrab (HiveWorkshop.com)
* Firetruck model: skrab (HiveWorkshop.com)
* Barracks model: Mechanical Man (HiveWorkshop.com)
* Su-35 Super Flanker model: Fingolfin (HiveWorkshop.com)
* Gold bars models: communist_orc (HiveWorkshop.com)
* Safe model: Mike (HiveWorkshop.com)
* Gold bar item model and icons: KAIL333XZ (HiveWorkshop.com)
* Algorithm item model and icons: KAIL333XZ (HiveWorkshop.com)
* Cargo helicopter icon: Deon (HiveWorkshop.com)
* Fighter jet icon: purparisien (HiveWorkshop.com)
* Sports car icon: TheRandomDude (HiveWorkshop.com)
* Truck icon: Hayate (HiveWorkshop.com)
* Turnstile machine model: Baradé
* Gate model: Baradé
* Turnstile machine texture: www.textures4photoshop.com
* Gate texture: texturelib.com
* Loading screen model: HiveWorkshop.com
* Loading screen texture: movie Tenet
* Shaft model: Baradé
* Shaft texture: freepik.com
* Hero Glow model: assasin_lord (HiveWorkshop.com)
* Ruin buildings models: Fingolfin (HiveWorkshop.com)
* [C4 model](https://www.hiveworkshop.com/threads/c4-item.271012/): Grey Knight
* [BTNsatchel](https://www.hiveworkshop.com/threads/btnsatchel.121971/): Zombie
* [Logo](https://d13ezvd6yrslxm.cloudfront.net/wp/wp-content/images/tent-banner-logo-700x324.jpg): Movie Tenet