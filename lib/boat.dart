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
  var list = [start, end];
  if (start.col == end.col) {
    for (var i = 1; i < end.row - start.row; i++) {
      list.insert(i, Coords(start.row + i, start.col));
    }
  } else if (start.row == end.row) {
    for (var i = 1; i < end.col - start.col; i++) {
      list.insert(i, Coords(start.row, start.col + i));
    }
  }

  return list;
}
