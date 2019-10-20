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

const columnCount = 10;

/// Possible status for a space on the board
enum Status { boat, empty, hit, miss }

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
    _boats.add(boat);
  }

  void addShot(Coords coords) {
    if (isShotAtCoords(coords)) {
      throw Exception('A shot is already present at $coords');
    }

    var boat = getBoatAtCoords(coords);
    if (boat != null) {
      boat.hitAt(coords);
      _shots.add(Shot(coords, Status.hit));
    } else {
      _shots.add(Shot(coords, Status.miss));
    }
  }

  Boat getBoatAtCoords(Coords coords) {
    for (var boat in _boats) {
      if (boat.getLocations().any((location) => location == coords)) {
        return boat;
      }
    }
    return null;
  }

  bool isShotAtCoords(Coords coords) {
    return _shots.any((shot) => shot.coords == coords);
  }

  bool areAllBoatsSunk() {
    return _boats.every((boat) => boat.isSunk());
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
  Status status;

  Shot(this.coords, this.status);

  @override
  String toString() {
    return 'Shot [$status] at $coords';
  }
}