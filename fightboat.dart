import 'dart:io';

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

class Boat {
  Set<Coords> locations;
  Set<Coords> hits;

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
  List<List<bool>> spaces;

  BoardOverlay.fromSpaces(List<Coords> spaces) {
    var row = List.filled(10, false);
    var grid = List<List<bool>>(10);
    for (var i = 0; i < rows.keys.length; i++) {
      grid[i] = List.from(row);
    }

    for (var space in spaces) {
      grid[space.row][space.col] = true;
    }

    this.spaces = grid;
  }
}

void main(List<String> args) {
  exitCode = 0;
  print('--- FIGHTBOAT ---');

  // Parsing multiple inputs during dev
  stdout.writeln("Your move(s):");
  String space = stdin.readLineSync();
  List<String> spaces = space.split(RegExp(r'\s+'));
  List<Coords> firedAt = spaces.map((s) => convertToCoords(s)).toList();
  var attacks = BoardOverlay.fromSpaces(firedAt);
  printBoard(attacks);
}

/**
 * Convert user coordinates input into 0-based numerical indices
 * e.g. 'A4' => '[0, 3]' and 'F10' => '[5, 9]'
 */
Coords convertToCoords(String input) {
  var cleaned = input.replaceAll(' ', '').toUpperCase();

  assert(RegExp('[A-J][1-9]|10').firstMatch(cleaned) != null);

  var rowLetter = cleaned[0];
  var colNumber = int.parse(cleaned.substring(1), radix: 10);

  return Coords(rows[rowLetter], colNumber - 1);
}

void printBoard(BoardOverlay hits) {
  stdout.writeln(' |1|2|3|4|5|6|7|8|9|10');

  for (int row = 0; row < rows.keys.length; row++) {
    var rowLetter = rows.keys.elementAt(row);
    stdout.write(rowLetter + '|');
    for (int col = 0; col < columnCount; col++) {
      if (hits.spaces[row][col]) {
        stdout.write('X|');
      } else {
        stdout.write('_|');
      }
    }
    stdout.writeln();
  }
}
