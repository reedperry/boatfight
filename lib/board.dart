import 'boat.dart';
import 'coords.dart';

const rows = {
  'A': 0,
  'B': 1,
  'C': 2,
  'D': 3,
  'E': 4,
  'F': 5,
  'G': 6,
  'H': 7,
  'I': 8,
  'J': 9
};

const rowLabelsByCoord = {
  0: 'A',
  1: 'B',
  2: 'C',
  3: 'D',
  4: 'E',
  5: 'F',
  6: 'G',
  7: 'H',
  8: 'I',
  9: 'J'
};

const columnCount = 10;

/// A current status of single a space on the board
/// TODO This doesn't quite make sense, e.g. boat and hit depend on which
/// player is reading the status. Maybe split this up or make it clearer.
enum SpaceStatus { boat, empty, hit, miss }

/// Possible types of invalid shots
enum Violation { duplicate, outOfBounds, unknown }

class ShotResult {
  Coords coords;
  SpaceStatus status;
  Violation violation;
  bool boatSunk;
  bool legalShot;

  ShotResult(this.coords) {
    status = null;
    boatSunk = null;
    legalShot = null;
    violation = null;
  }
}

class Board {
  List<Shot> _shots;
  List<Boat> _boats;

  Board() {
    _boats = [];
    _shots = [];
  }

  List<Boat> getBoats() {
    return this._boats;
  }

  List<Shot> getShots() {
    return this._shots;
  }

  void addBoat(Boat boat) {
    if (!doesBoatFitInFleet(boat.getLength())) {
      throw Exception(
          'A boat ${boat.getLength()} spaces long (${boat.getLocations().first}-${boat.getLocations().last}) is not allowed on this board. Length of all boats on the board should be 2, 3, 3, 4, and 5.');
    }
    if (doesBoatCollideWithAnother(boat)) {
      throw Exception('This boat collides with another boat on the board!');
    }

    _boats.add(boat);
  }

  /// Add a new shot to a board at the given coordinates.
  /// Returns the result of the shot.
  ShotResult addShot(Coords coords) {
    var result = ShotResult(coords);

    if (hasShotAtCoords(coords)) {
      result.legalShot = false;
      result.violation = Violation.duplicate;
    } else {
      result.legalShot = true;
    }

    var boat = getBoatAtCoords(coords);
    if (boat != null) {
      boat.hitAt(coords);
      _shots.add(Shot(coords, SpaceStatus.hit));

      result
        ..boatSunk = boat.isSunk()
        ..status = SpaceStatus.hit;
    } else {
      _shots.add(Shot(coords, SpaceStatus.miss));

      result
        ..boatSunk = false
        ..status = SpaceStatus.miss;
    }

    return result;
  }

  bool hasShotAtCoords(Coords coords) {
    return _shots.any((shot) => shot.coords == coords);
  }

  bool areAllBoatsSunk() {
    return _boats.every((boat) => boat.isSunk());
  }

  bool doesBoatFitInFleet(int length) {
    var maxLengthCounts = <int, int>{2: 1, 3: 2, 4: 1, 5: 1};

    var countOfLength =
        _boats.where((boat) => boat.getLength() == length).length;
    if (countOfLength >= maxLengthCounts[length]) {
      return false;
    }
    return true;
  }

  bool doesBoatCollideWithAnother(Boat boat) {
    return boat.getLocations().any((coords) => getBoatAtCoords(coords) != null);
  }

  Boat getBoatAtCoords(Coords coords) {
    for (var boat in _boats) {
      if (boat.getLocations().any((location) => location == coords)) {
        return boat;
      }
    }
    return null;
  }

  @override
  String toString() {
    return '''Board:
    Boats: $_boats
    Shots: $_shots''';
  }
}

/// Shot represents a single shot displayed on the board
class Shot {
  Coords coords;
  SpaceStatus status;

  Shot(this.coords, this.status);

  @override
  String toString() {
    return 'Shot [$status] at $coords';
  }
}
