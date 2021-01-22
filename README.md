# Tenet

A [Tenet](https://www.imdb.com/title/tt6723592)-style prototype map for Warcraft III: Reforged.

## Download

Download: [Tenet.w3x](./Tenet.w3x)

This is a very basic 2 vs 2 map.
Tenet soldiers fight against Sator's men.
The Algorithm has to be switched with a fake Algorithm by the Protagonist in time.
The real one has to be brought to a certain point on the map.
The Algorithm is protected by Sator's mercenaries.

The turnstile machine allows you to copy the Algorithm and fake Algorithm.
All real Algorithms should be at the specific locations on the map and at leaast one fake Algorithm must be placed at the original location.

### The Turnstile Machine

There is one single turnstile machine on the map which can invert a group of units.
It must be conquered by units before it can be used.
Using it inverts the entered units and the global time.
When the time is inverted, all inverted units can be controlled again and all non-inverted units will be restored backwards in time automatically.
There is a time limit how long the global time can be inverted.
Besides the turnstile machine has a cooldown.
This improves the performance of the map and prevents some unfair strategies.

## Screenshots

TODO Add Screenshots.

## Videos

[Video of an early version of the scenario on YouTube](https://www.youtube.com/watch?v=qVlEL9Wzz_Y)

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

### TODO Interactions with inverted objects

Interacting with inverted items would be fun, too.
For example a unit can be restored and drop an inverted item at some point.
If you pick up the inverted item with a non-inverted hero, it should have the inverted effect!
If a restored inverted unit shoots at a non-inverted unit (if still possible), the non-inverted unit should be healed by this.

## Code

vJass implementation: [Tenet.j](./Tenet.j)