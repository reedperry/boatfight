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

/// Players in the game
enum Player { one, two }

/// Possible status for a space on the board
enum Status { boat, empty, hit, miss }

class Game {
  Board board1;
  Board board2;
  Player currentPlayerTurn;

  bool isOver() {
    return board1.areAllBoatsSunk() || board2.areAllBoatsSunk();
  }
}

class Board {
  List<BoardOverlay> overlays;
  List<Boat> boats;

  bool areAllBoatsSunk() {
    return this.boats.every((boat) => boat.isSunk());
  }
}

class Boat {
  Set<Coords> locations;
  Set<Coords> hits;

  Boat(List<Coords> coords) {
    this.locations = Set.from(coords);
  }

  bool isSunk() {
    return this.locations.difference(this.hits).isEmpty;
  }
}

class Coords {
  int row, col;

  Coords(row, col) {
    this.row = row;
    this.col = col;
  }

  @override
  String toString() {
    return '[${this.row}, ${this.col}]';
  }
}

class BoardOverlay {
  List<List<Status>> spaces;

  BoardOverlay.fromHits(List<Coords> spaces) {
    var row = List.filled(10, Status.empty);
    var grid = List<List<Status>>(10);
    for (var i = 0; i < rows.keys.length; i++) {
      grid[i] = List.from(row);
    }

    for (var space in spaces) {
      grid[space.row][space.col] = Status.hit;
    }

    this.spaces = grid;
  }

  BoardOverlay.fromMisses(List<Coords> spaces) {
    var row = List.filled(10, Status.empty);
    var grid = List<List<Status>>(10);
    for (var i = 0; i < rows.keys.length; i++) {
      grid[i] = List.from(row);
    }

    for (var space in spaces) {
      grid[space.row][space.col] = Status.miss;
    }

    this.spaces = grid;
  }

  BoardOverlay.fromBoats(List<Boat> boats) {
    var row = List.filled(10, Status.empty);
    var grid = List<List<Status>>(10);
    for (var i = 0; i < rows.keys.length; i++) {
      grid[i] = List.from(row);
    }

    for (var boat in boats) {
      for (var space in boat.locations) {
        grid[space.row][space.col] = Status.boat;
      }
    }

    this.spaces = grid;
  }
}
