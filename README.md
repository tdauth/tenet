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

Download: [Tenet3.w3x](./Tenet3.w3x)

Two player map with a red and a blue team. The blue team is inverted and goes back a predefined path which it completed before.
The protagonist has to switch the Algorithm and bring the real Algorithm to a certain point on the map in a certain time.
There is one red and one blue room on the map to invert units.
The players have to lure the Zergs away from the Algorithm to switch it.
Hence, the players can go back in time to certain point in time when the Algorithm is not protected and pick it up and drop it somewhere.
Then the players can go forward and pick it up before it is picked up by the inverted protagonist.