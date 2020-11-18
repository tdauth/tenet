# Tenet

A [Tenet](https://www.imdb.com/title/tt6723592)-style prototype map.

## Concept of Time Inversion

* There is a global time which consist of a global clock (integer) and added objects and is either inverted or not.
* Every added object/unit is either inverted or not.
* Every object/unit has its own time line.
* A time line starts at a certain time (global clock) and consist of certain time points (time frame).
* Every time frame consists of change events for the object/unit.
* The change events can be anything and must be able to be inverted.
* If the global time is not inverted then all inverted objects/units will get restored all change events of their time line at the corresponding time frames.
* If the global time is inverted then all not inverted objects/units will get restored all change events of their time line at the corresponding time frames.
* If a unit is not restored it can be controlled again and its stored time line will be flushed, so we do not have to keep all changes which will be overriden.
* If a copy is created of a unit by going forward or backwards it will disappear if time goes back/forward to its creation.
* We can actually go backwards in time to a negative global clock value (so before the map has even started). Everything will stand around then?
* This kind of system allows us to minimize the stored changes and time lines.

## Code

vJass implementation: [Tenet.j](./Tenet.j)

## Scenario

Download: [Tenet.w3x](./Tenet.w3x)

The Algorithm has to be switched by the Protagonist and the real one has to be brought to a certain point on the map.
The Algorithm is protected by Hydralisks (bad guys).

Both forces (good and bad guys) are separated into two teams:

* Red team: Moves forward through time.
* Blue team: Moves backwards through time.

There is one blue and red room on the map.
Hence, the time can be inverted at any point in time.
When the time is inverted, the blue team can gains control again to do something.
The players have to lure the Hydralisks away from the Algorithm to switch it.
Hence, the players can go back in time to certain point in time when the Algorithm is not protected and pick it up and drop it somewhere.
Then the players can go forward and pick it up before it is picked up by the inverted Protagonist.

## TODOs

* Maybe limit the number off possible copies or maybe simplify the concept of inversion by not copying someone who goes through the gate?
* Fix all bugs (see trigger TODO)
* Support picking up and dropping an item.
* The Algorithm should exist once or multiple times?
* Try to player with 4 players and improve the scenario to improve its structure.
* Test the tanks and the tank factory on constructing support.
* Add a hydralisk factory.
* Add intro video with helicopters bringing and taking the red and the blue team.