import 'dart:io';
import 'lib/board.dart';
import 'lib/boat.dart';
import 'lib/coords.dart';
import 'lib/game.dart';

void main(List<String> args) {
  exitCode = 0;
  print('--- FIGHTBOAT ---');

  var game = new Game();

  while (!game.isSetUp()) {
    var nextBoatNumber = game.board1.getBoats().length + 1;
    var playerOneBoat = enterNewBoatForPlayer(Player.one, nextBoatNumber);
    game.addBoat(playerOneBoat, Player.one);

    nextBoatNumber = game.board2.getBoats().length + 1;
    var playerTwoBoat = enterNewBoatForPlayer(Player.two, nextBoatNumber);
    game.addBoat(playerTwoBoat, Player.two);
  }

  game.startGame();

  print('\n');
  print('Player One');
  printBoard(board: game.board1);

  print('\n');
  print('Player Two');
  printBoard(board: game.board2);

  while (!game.isOver()) {
    var player = game.currentPlayerTurn;

    print(player == Player.one ? 'Player One' : 'Player Two');
    var target = getTargetCoords();
    var result = game.doTurn(target);

    if (result == Status.hit) {
      print('HIT!');
    } else if (result == Status.miss) {
      print('Miss.');
    }

    if (player == Player.one) {
      print('Opponent Board:');
      printBoard(board: game.board2, showBoats: false);
      print('Your Board:');
      printBoard(board: game.board1);
    } else {
      print('Opponent Board:');
      printBoard(board: game.board1, showBoats: false);
      print('Your Board:');
      printBoard(board: game.board2);
    }
  }

  var winner = game.getWinner();
  print(game);
  print('WINNER - $winner');

  exit(exitCode);
}

/// Create a Boat for a given player, with the location determined by a user
/// input string providing the start and end coordinates of the boat.
Boat enterNewBoatForPlayer(Player player, int boatNumber) {
  stdout.writeln('Add a boat #$boatNumber for player $player:');
  var range = stdin.readLineSync();
  List<Coords> edges = parseRangeInput(range);
  if (edges.length == 2) {
    return Boat.fromRange(edges[0], edges[1]);
  }

  throw Exception('Failed to create boat from input: $range.');
}

/// Parse an input string containing the start and end coordinates of a range
/// into a list of Coords.
List<Coords> parseRangeInput(String rangeInput) {
  var textCoords = rangeInput.split(RegExp('[-\\s+]'));
  if (textCoords.length != 2) {
    throw Exception(
        'Illegal entry for boat range: $textCoords.\nPlease enter in format: "a1-d1" or "a1 d1".');
  }

  return [convertToCoords(textCoords[0]), convertToCoords(textCoords[1])];
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

  if (!rows.containsKey(rowLetter)) {
    throw Exception('Invalid row letter: $rowLetter');
  }
  if (colNumber < 1 || colNumber > columnCount) {
    throw Exception('Invalid column number: $colNumber');
  }

  return Coords(rows[rowLetter], colNumber - 1);
}

void printBoard({Board board, bool showBoats = true}) {
  if (board == null) {
    return;
  }

  var boats = showBoats ? BoardOverlay.fromBoats(board.getBoats()) : null;
  var shots = BoardOverlay.fromShots(board.getShots());

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
