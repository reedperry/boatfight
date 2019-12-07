# FIGHTBOAT
10 boats enter. Fewer leave.

This is a simple clone of a popular ship battle game.

Currently, this is a command line application. It is playable, but still a little rough around the edges. A (very) basic computer opponent will play against you.

To play it in its current state, you need to install the Dart VM, which comes with the [Dart SDK](https://dart.dev/get-dart).

Clone this repository, and from the root directory, run:
```
dart fightboat.dart
```



### Roadmap:  
- [ ] Gracefully handle player firing at a location already fired at
- [X] Make computer agent track its shots to avoid duplicates
- [ ] Make computer agent use a bit of logic for shot locations instead of random
- [ ] ???
