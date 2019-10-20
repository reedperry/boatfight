import 'coords.dart';

class Boat {
  Set<Coords> _locations;
  Set<Coords> _hits;

  Boat(List<Coords> coords) {
    validateCoords(coords);
    _locations = Set.from(coords);
    _hits = {};
  }

  Boat.fromRange(Coords start, Coords end) {
    final coords = convertCoordsRangeToList(start, end);
    // Can we call the default constructor here instead?
    validateCoords(coords);
    _locations = Set.from(coords);
    _hits = {};
  }

  List<Coords> getLocations() {
    return _locations.toList();
  }

  void hitAt(Coords coords) {
    _hits.add(coords);
  }

  void validateCoords(List<Coords> coords) {
    _validateLength(coords);
    _validateNoDuplicateCoordinates(coords);
    _validateLinearConsecutiveSpaces(coords);
  }

  bool isSunk() {
    return _locations.difference(this._hits).isEmpty;
  }

  _validateLength(List<Coords> coords) {
    if (coords.length < 2 || coords.length > 5) {
      throw Exception('Illegal boat length: {$coords.length}');
    }
  }

  _validateNoDuplicateCoordinates(List<Coords> coords) {
    if (coords.length != Set.from(coords).length) {
      throw Exception(
          'Illegal boat positioning. Duplicate coordinates occupied.');
    }
  }

  _validateLinearConsecutiveSpaces(List<Coords> coords) {
    List<int> columns = List.from(coords.map((coord) => coord.col));
    List<int> rows = List.from(coords.map((coord) => coord.row));
    var isVertical = Set.from(columns).length == 1;
    var isHorizontal = Set.from(rows).length == 1;

    if (!isVertical && !isHorizontal) {
      throw Exception(
          'Non-linear boat positioning. Must occupy either one column or one row.');
    }

    if (isHorizontal) {
      columns.sort();
      for (var i = 1; i < columns.length; i++) {
        if (columns[i - 1] + 1 != columns[i]) {
          throw Exception(
              'Boat does not occupy consecutive spaces - gap from column ${columns[i - 1]} to ${columns[i]}');
        }
      }
    } else if (isVertical) {
      rows.sort();
      for (var i = 1; i < rows.length; i++) {
        if (rows[i - 1] + 1 != rows[i]) {
          throw Exception(
              'Boat does not occupy consecutive spaces - gap from row ${rows[i - 1]} to ${rows[i]}');
        }
      }
    }
  }

  @override
  String toString() {
    return 'Boat ${isSunk() ? "[SUNK]" : ""} at $_locations - hit at $_hits';
  }
}

List<Coords> convertCoordsRangeToList(Coords start, Coords end) {
  if (start == end) {
    throw Exception('Start and end coordinates of a range must be different');
  }
  List<Coords> list = [];

  if (start.col == end.col) {
    var coordinatesNeeded = (start.row - end.row).abs() - 1;
    var direction = start.row < end.row ? 1 : -1;
    var connectingCoords = List<Coords>.generate(coordinatesNeeded, (i) {
      var row = start.row + ((i + 1) * direction);
      return Coords(row, start.col);
    });

    list = [start, ...connectingCoords, end];
  } else if (start.row == end.row) {
    var coordinatesNeeded = (start.col - end.col).abs() - 1;
    var direction = start.col < end.col ? 1 : -1;
    var connectingCoords = List<Coords>.generate(coordinatesNeeded, (i) {
      var column = start.col + ((i + 1) * direction);
      return Coords(start.row, column);
    });

    list = [start, ...connectingCoords, end];
  }

  return list;
}
