import 'dart:io';
import 'lib/board.dart';
import 'lib/boat.dart';
import 'lib/coords.dart';
import 'lib/game.dart';

void main(List<String> args) {
  exitCode = 0;
  print('--- FIGHTBOAT ---');

  var boat1 = Boat([Coords(0, 1), Coords(0, 2), Coords(0, 3)]);
  var boat2 = Boat([Coords(4, 3), Coords(5, 3), Coords(6, 3), Coords(7, 3)]);
  var boat3 = Boat([Coords(1, 0), Coords(2, 0), Coords(3, 0)]);
  var boat4 = Boat([Coords(6, 6), Coords(6, 7), Coords(6, 8), Coords(6, 9)]);
  var boat5 = Boat([Coords(9, 6), Coords(8, 6), Coords(7, 6)]);

  var boat6 = Boat([Coords(0, 1), Coords(0, 2), Coords(0, 3)]);
  var boat7 = Boat([Coords(4, 3), Coords(5, 3), Coords(6, 3), Coords(7, 3)]);
  var boat8 = Boat([Coords(1, 0), Coords(2, 0), Coords(3, 0)]);
  var boat9 = Boat([Coords(6, 6), Coords(6, 7), Coords(6, 8), Coords(6, 9)]);
  var boat10 = Boat([Coords(9, 6), Coords(8, 6), Coords(7, 6)]);

  var game = new Game();
  game.addBoat(boat1, Player.one);
  game.addBoat(boat2, Player.one);
  game.addBoat(boat3, Player.one);
  game.addBoat(boat4, Player.one);
  game.addBoat(boat5, Player.one);

  game.addBoat(boat6, Player.two);
  game.addBoat(boat7, Player.two);
  game.addBoat(boat8, Player.two);
  game.addBoat(boat9, Player.two);
  game.addBoat(boat10, Player.two);

  game.startGame();

  print(game);

  game.doTurn(Coords(1, 0));
  game.doTurn(Coords(4, 3));

  game.doTurn(Coords(2, 0));
  game.doTurn(Coords(2, 5));

  game.doTurn(Coords(3, 0));
  game.doTurn(Coords(1, 1));

  print(game);

  print('\n');
  print('Player One');
  printBoard(BoardOverlay.fromBoats(game.board1.getBoats()),
      BoardOverlay.fromShots(game.board1.getShots()));

  print('\n');
  print('Player Two');
  printBoard(BoardOverlay.fromBoats(game.board2.getBoats()),
      BoardOverlay.fromShots(game.board2.getShots()));
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
