import 'board.dart';
import 'coords.dart';

/// Convert alphanumeric board coordinates input into 0-based numerical indices
/// e.g. A4 => [0, 3] and F10 => [5, 9]
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

/// Convert 0-based numerical indices into alphanumeric board coordinates
/// e.g. [0, 3] => A4 and [5, 9] => F10
String convertCoordsToAlphaNumeric(Coords coords) {
  var row = rowLabelsByCoord[coords.row];
  var col = coords.col + 1;
  return '$row$col'.toUpperCase();
}
