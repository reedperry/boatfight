import 'dart:math';

import 'board.dart';
import 'coords.dart';

/// Agent is a simple opponent to against in a game of FIGHTBOAT
/// TODO It is currently in an early state and quite dumb. It will likely make illegal moves during a game.
class Agent {
  Coords lastShot;
  Coords lastHit;
  Coords lastMiss;

  /// Return the start and end point edges of a boat to add to the board.
  /// boatNumber is the 1-based number of the boat being added.
  List<Coords> addBoat(int boatNumber) {
    return [
      [Coords(0, 0), Coords(2, 0)],
      [Coords(3, 0), Coords(4, 0)],
      [Coords(4, 8), Coords(8, 8)],
      [Coords(9, 5), Coords(9, 7)],
      [Coords(7, 3), Coords(7, 6)]
    ][boatNumber - 1];
  }

  /// Select the next shot to make against the opponent board.
  Coords getNextShot() {
    final shot = Coords(Random().nextInt(9), Random().nextInt(9));
    lastShot = shot;
    return shot;
  }

  /// Tell the agent the result of the last shot it made against the opponent.
  void reportResult(Status result) {
    if (result == Status.miss) {
      lastMiss = lastShot;
    } else if (result == Status.hit) {
      lastHit = lastShot;
    }
  }
}
