/// Coords represents a row/column pair for a single location on the board
class Coords {
  int row, col;

  Coords(row, col) {
    if (row >= 0 && row < 10 && col >= 0 && col < 10) {
      this.row = row;
      this.col = col;
    } else {
      throw Exception('Invalid Coords: row: $row, column: $col');
    }
  }

  Coords.fromPair(List<String> pair) : this(pair[0], pair[1]);

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + row;
    result = 37 * result + col;
    return result;
  }

  @override
  bool operator ==(dynamic other) {
    if (other is! Coords) return false;
    Coords coords = other;
    return coords.row == row && coords.col == col;
  }

  @override
  String toString() {
    return '[${this.row}, ${this.col}]';
  }
}
