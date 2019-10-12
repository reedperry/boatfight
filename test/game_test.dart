import 'package:test/test.dart';
import 'package:fightboat/game.dart';

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
  });
}
