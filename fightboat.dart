import 'dart:io';
import 'lib/game.dart';

void main(List<String> args) {
  exitCode = 0;
  print('--- FIGHTBOAT ---');

  var boats = List<Boat>();
  boats.add(Boat([Coords(0, 1), Coords(0, 2), Coords(0, 3)]));
  boats.add(Boat([Coords(4, 3), Coords(5, 3), Coords(6, 3), Coords(7, 3)]));
  var boatMap = BoardOverlay.fromBoats(boats);

  var target = getTargetCoords();
  var shot = Shot(target, Status.miss);
  var board = BoardOverlay.fromShots([shot]);
  printBoard(boatMap, board);

  var game = new Game();
  print(game);
}

Coords getTargetCoords() {
  stdout.writeln("Enter target coordinates:");
  var space = stdin.readLineSync();
  return convertToCoords(space);
}

/// Convert user coordinates input into 0-based numerical indices
/// e.g. 'A4' => '[0, 3]' and 'F10' => '[5, 9]'
Coords convertToCoords(String input) {
  var cleaned = input.replaceAll(' ', '').toUpperCase();

  assert(RegExp('[A-J][1-9]|10').firstMatch(cleaned) != null);

  var rowLetter = cleaned[0];
  var colNumber = int.parse(cleaned.substring(1), radix: 10);

  return Coords(rows[rowLetter], colNumber - 1);
}

void printBoard(BoardOverlay boats, BoardOverlay shots) {
  stdout.writeln(' |1|2|3|4|5|6|7|8|9|10');

  for (int row = 0; row < rows.keys.length; row++) {
    var rowLetter = rows.keys.elementAt(row);
    stdout.write(rowLetter + '|');
    for (int col = 0; col < columnCount; col++) {
      if (shots.spaces[row][col] == Status.hit) {
        stdout.write('X|');
      } else if (shots.spaces[row][col] == Status.miss) {
        stdout.write('+|');
      } else if (boats != null && boats.spaces[row][col] == Status.boat) {
        stdout.write('O|');
      } else {
        stdout.write('_|');
      }
    }
    stdout.writeln();
  }
}
