import 'dart:math';

import 'board.dart';
import 'coords.dart';

/// Agent is a (very) simple opponent to against in a game of BOATFIGHT
class Agent {
  Coords lastShot;
  Coords lastSunk;
  Coords lastHit;
  Coords lastMiss;
  List<Coords> hits = [];
  List<Coords> misses = [];
  List<int> sunkBoatLengths = [];

  /// Return the start and end point edges of a boat to add to the board.
  /// boatNumber is the 1-based number of the boat being added.
  /// This is a primitive solution returning the same coordinates in every game.
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
    Coords shot;
    while (shot == null) {
      if (_lastShotHit() && !_lastShotSunkBoat()) {
        shot = _followLastHitOnUnsunkBoat();
      } else {
        shot = _selectRandomShot();
      }

      if (_alreadyFiredAt(shot)) {
        shot = null;
      }
    }

    lastShot = shot;
    return shot;
  }

  /// Tell the agent the result of the last shot it made against the opponent.
  void reportResult(ShotResult result) {
    if (result.status == SpaceStatus.miss) {
      lastMiss = lastShot;
      misses.add(lastShot);
    } else if (result.status == SpaceStatus.hit) {
      lastHit = lastShot;
      if (result.boatSunk) {
        lastSunk = lastShot;
        sunkBoatLengths.add(result.sunkBoatLength);
      }
      hits.add(lastShot);
    }
  }

  /// Return a random set of coordinates on the board to shoot at.
  Coords _selectRandomShot() {
    return Coords(Random().nextInt(9), Random().nextInt(9));
  }

  /// Select the next shot when the last shot was a hit.
  Coords _followLastHitOnUnsunkBoat() {
    // 'up' meaning top of the board as we see it
    var canMoveUp = !_isFirstRow(lastHit);
    var canMoveDown = !_isLastRow(lastHit);
    var canMoveRight = !_isLastColumn(lastHit);
    var canMoveLeft = !_isFirstColumn(lastHit);

    var moveVertical = Random().nextBool();

    if (moveVertical) {
      var moveUp = canMoveUp && Random().nextBool();
      if (moveUp) {
        return Coords(lastHit.row - 1, lastHit.col);
      } else if (canMoveDown) {
        return Coords(lastHit.row + 1, lastHit.col);
      } else {
        // Eh, taking the easy way out.
        return _selectRandomShot();
      }
    } else {
      var moveRight = canMoveRight && Random().nextBool();
      if (moveRight) {
        return Coords(lastHit.row, lastHit.col + 1);
      } else if (canMoveLeft) {
        return Coords(lastHit.row, lastHit.col - 1);
      } else {
        return _selectRandomShot();
      }
    }
  }

  bool _isLastColumn(Coords coords) {
    return coords.col == 9;
  }

  bool _isFirstColumn(Coords coords) {
    return coords.col == 0;
  }

  bool _isLastRow(Coords coords) {
    return coords.row == 9;
  }

  bool _isFirstRow(Coords coords) {
    return coords.row == 0;
  }

  /// Determine if the agent has already fired at a given set of Coords.
  bool _alreadyFiredAt(Coords shot) {
    return misses.contains(shot) || hits.contains(shot);
  }

  /// Determine if the agent's last shot resulted in a hit.
  bool _lastShotHit() {
    return lastHit != null && lastShot == lastHit;
  }

  bool _lastShotSunkBoat() {
    return lastSunk != null && lastSunk == lastHit;
  }
}
