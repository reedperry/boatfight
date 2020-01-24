import 'dart:io';
import 'lib/agent.dart';
import 'lib/board.dart';
import 'lib/boat.dart';
import 'lib/conversions.dart';
import 'lib/coords.dart';
import 'lib/game.dart';

import 'test/mockdata.dart';

void main(List<String> args) {
  exitCode = 0;
  print('--- FIGHTBOAT ---');

  var game = Game();
  var agent = Agent();

  var autoBoatSetup = askForAutoBoatSetup();

  while (!game.isSetUp()) {
    addPlayerBoat(game, autoBoatSetup);
    addAgentBoat(game, agent);
  }

  game.start();

  while (!game.isOver()) {
    runNextTurn(game, agent);
  }

  finishGame(game);

  exit(exitCode);
}

void runNextTurn(Game game, Agent agent) {
  var player = game.currentPlayerTurn;

  if (player == Player.one) {
    print('Opponent Board:');
    printBoard(board: game.board2, showBoats: false);

    sleep(Duration(seconds: 1));

    print('Your Board:');
    printBoard(board: game.board1);
  }

  print(player == Player.one ? 'Player One' : 'Player Two');

  var target;
  var targetAlphaNumeric;
  if (player == Player.one) {
    target = getTargetCoords();
  } else {
    target = agent.getNextShot();
  }

  targetAlphaNumeric = convertCoordsToAlphaNumeric(target);

  var result = game.doTurn(target);
  if (!result.legalShot) {
    if (result.violation == Violation.duplicate) {
      stdout.write('Illegal shot. Already fired at $targetAlphaNumeric...');
    } else {
      stdout.write('Illegal shot.');
    }
    return;
  }

  stdout.write('Fires at $targetAlphaNumeric... ');

  if (player == Player.two) {
    agent.reportResult(result);
  }

  sleep(Duration(milliseconds: 500));

  if (result.status == SpaceStatus.hit) {
    var msg = 'HIT';
    if (result.boatSunk) {
      msg += ' - SUNK! Boat length: ${result.sunkBoatLength}';
    }
    stdout.writeln(msg);
  } else if (result.status == SpaceStatus.miss) {
    stdout.writeln('MISS');
  }
  stdout.writeln();

  sleep(Duration(milliseconds: 500));
}

void finishGame(Game game) {
  var winner = game.getWinner();
  print(game);
  if (winner == Player.one) {
    print('YOU WIN!');
  } else {
    print('You lose.');
  }
}

addPlayerBoat(Game game, bool autoBoatSetup) {
  var nextBoatNumber = game.board1.getBoats().length + 1;
  var playerOneBoat;

  if (!autoBoatSetup) {
    playerOneBoat = enterNewBoatForPlayer(Player.one, nextBoatNumber);
  } else {
    var mockEntry = mockBoatEntries[nextBoatNumber - 1];
    List<Coords> edges = parseRangeInput(mockEntry);
    playerOneBoat = Boat.fromRange(edges[0], edges[1]);
  }

  game.addBoat(playerOneBoat, Player.one);
}

addAgentBoat(Game game, Agent agent) {
  var nextBoatNumber = game.board2.getBoats().length + 1;
  var agentBoat = getNextAgentBoat(agent, nextBoatNumber);
  game.addBoat(agentBoat, Player.two);
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

bool askForAutoBoatSetup() {
  stdout.writeln('Enter boats manually? (y/n):');
  var answer = stdin.readLineSync();
  if (answer.trim().toLowerCase() == 'y') {
    return false;
  } else if (answer.trim().toLowerCase() == 'n') {
    return true;
  } else {
    return askForAutoBoatSetup();
  }
}

Boat getNextAgentBoat(Agent agent, int boatNumber) {
  var edges = agent.addBoat(boatNumber);
  if (edges.length == 2) {
    var playerTwoBoat = Boat.fromRange(edges[0], edges[1]);
    return playerTwoBoat;
  } else {
    throw Exception(
        'Expected 2 edges for new agent boat, received ${edges.length}.');
  }
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
      if (shots.spaces[row][col] == SpaceStatus.hit) {
        stdout.write('X|');
      } else if (shots.spaces[row][col] == SpaceStatus.miss) {
        stdout.write('+|');
      } else if (boats != null && boats.spaces[row][col] == SpaceStatus.boat) {
        stdout.write('O|');
      } else {
        stdout.write('_|');
      }
    }
    stdout.writeln();
  }
}
