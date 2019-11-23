import 'board.dart';
import 'boat.dart';
import 'coords.dart';

/// Players in the game
enum Player { one, two }

class Game {
  bool started;

  /// Player.one board
  Board board1;

  /// Player.two board
  Board board2;
  Player currentPlayerTurn;

  Game() {
    started = false;
    board1 = Board();
    board2 = Board();
  }

  /// Returns true only if the game is ready to begin, and has not yet begun.
  bool isSetUp() {
    return !started &&
        board1.getBoats().length == 5 &&
        board2.getBoats().length == 5;
  }

  void addBoat(Boat boat, Player player) {
    if (player == Player.one) {
      board1.addBoat(boat);
    } else if (player == Player.two) {
      board2.addBoat(boat);
    }
  }

  void startGame() {
    if (isSetUp()) {
      started = true;
      currentPlayerTurn = Player.one;
    }
  }

  Status doTurn(Coords target) {
    var result;
    if (currentPlayerTurn == Player.one) {
      result = board2.addShot(target);
      currentPlayerTurn = Player.two;
    } else {
      result = board1.addShot(target);
      currentPlayerTurn = Player.one;
    }
    return result;
  }

  bool isOver() {
    return started && (board1.areAllBoatsSunk() || board2.areAllBoatsSunk());
  }

  /// Based on the current game state, return the winner of the game, or null if
  /// there is no winner yet
  Player getWinner() {
    if (!started) return null;

    if (board1.areAllBoatsSunk()) {
      return Player.two;
    } else if (board2.areAllBoatsSunk()) {
      return Player.one;
    } else {
      return null;
    }
  }

  @override
  String toString() {
    return '''Game:
    Started: $started
    Current Player Turn: $currentPlayerTurn
    Game Over: ${isOver()}
    Winner: ${getWinner()}
    Board 1: $board1
    Board 2: $board2''';
  }
}

class BoardOverlay {
  List<List<Status>> spaces;

  BoardOverlay.fromShots(List<Shot> shots) {
    var row = List.filled(10, Status.empty);
    var grid = List<List<Status>>(10);
    for (var i = 0; i < rows.keys.length; i++) {
      grid[i] = List.from(row);
    }

    for (var shot in shots) {
      grid[shot.coords.row][shot.coords.col] = shot.status;
    }

    spaces = grid;
  }

  BoardOverlay.fromBoats(List<Boat> boats) {
    var row = List.filled(10, Status.empty);
    var grid = List<List<Status>>(10);
    for (var i = 0; i < rows.keys.length; i++) {
      grid[i] = List.from(row);
    }

    for (var boat in boats) {
      for (var space in boat.getLocations()) {
        grid[space.row][space.col] = Status.boat;
      }
    }

    spaces = grid;
  }
}
