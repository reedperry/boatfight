import 'package:test/test.dart';
import 'package:fightboat/boat.dart';
import 'package:fightboat/coords.dart';

void main() {
  group('A Boat', () {
    test(
        'can be created from a coordinate range with increasing column coordinate',
        () {
      var expectedCoords = [
        Coords(1, 4),
        Coords(1, 5),
        Coords(1, 6),
        Coords(1, 7)
      ];
      var boat = Boat.fromRange(Coords(1, 4), Coords(1, 7));
      expect(boat.getLocations(), equals(expectedCoords));
    });

    test(
        'can be created from a coordinate range with decreasing column coordinate',
        () {
      var expectedCoords = [
        Coords(1, 7),
        Coords(1, 6),
        Coords(1, 5),
        Coords(1, 4)
      ];
      var boat = Boat.fromRange(Coords(1, 7), Coords(1, 4));
      expect(boat.getLocations(), equals(expectedCoords));
    });

    test(
        'can be created from a coordinate range with increasing row coordinate',
        () {
      var expectedCoords = [
        Coords(2, 4),
        Coords(3, 4),
        Coords(4, 4),
        Coords(5, 4)
      ];
      var boat = Boat.fromRange(Coords(2, 4), Coords(5, 4));
      expect(boat.getLocations(), equals(expectedCoords));
    });

    test(
        'cannot be created from a set of coordinates containing a non-consecutive set of rows',
        () {
      expect(() => Boat([Coords(3, 4), Coords(4, 4), Coords(6, 4)]),
          throwsException);
    });

    test(
        'cannot be created from a set of coordinates containing a non-consecutive set of columns',
        () {
      expect(() => Boat([Coords(3, 1), Coords(3, 5), Coords(3, 6)]),
          throwsException);
    });
  });

  group('Coords', () {
    test('can be created with valid row and column values', () {
      var coords = Coords(5, 9);
      expect(coords.row, equals(5));
      expect(coords.col, equals(9));
    });

    test('cannot be created with a negative row value', () {
      expect(() => Coords(-2, 3), throwsException);
    });

    test('cannot be created with a negative column value', () {
      expect(() => Coords(2, -3), throwsException);
    });

    test('cannot be created with negative row and column values', () {
      expect(() => Coords(-1, -2), throwsException);
    });
  });
}
