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

void main(List<String> args) {
  exitCode = 0;
  print('--- FIGHTBOAT ---');

  stdout.writeln("Your move:");
  String space = stdin.readLineSync();
  stdout.writeln('You fired at ' + convertToCoords(space).toString());
  printBoard();
}

/**
 * Convert user coordinates input into 0-based numerical indices
 * e.g. 'A4' => '[0, 3]' and 'F10' => '[5, 9]'
 */
List<int> convertToCoords(String input) {
  var cleaned = input.replaceAll(' ', '').toUpperCase();

  assert(new RegExp('[A-J][1-9]|10').firstMatch(cleaned) != null);

  var rowLetter = cleaned[0];
  var colNumber = int.parse(cleaned.substring(1), radix:10);

  return [rows[rowLetter], colNumber - 1];
}

String printBoard() {
  stdout.writeln(' |1|2|3|4|5|6|7|8|9|10');

  for (String rowLetter in rows.keys) {
    stdout.write(rowLetter + '|');
    for (int col = 0; col < columnCount; col++) {
      stdout.write('_|');
    }
    stdout.writeln();
  }
}
