import 'dart:math';
import 'package:flutter/material.dart';

// Define the types of Tetriminos.
enum TetriminoType { I, O, T, S, Z, J, L }

class Tetrimino {
  final TetriminoType type;
  List<List<int>> shape;
  final Color color;
  Offset position; // To track the position on the grid.

  Tetrimino({
    required this.type,
    required this.shape,
    required this.color,
    Offset? position,
  }) : position = position ??
            Offset.zero; // Default to (0, 0) if no position is provided.

  // Factory methods for each Tetrimino type
  factory Tetrimino.I({Offset? position}) => Tetrimino(
        type: TetriminoType.I,
        shape: [
          [1, 1, 1, 1],
          [0, 0, 0, 0],
          [0, 0, 0, 0],
          [0, 0, 0, 0],
        ],
        color: Colors.cyan,
        position: position,
      );

  factory Tetrimino.O({Offset? position}) => Tetrimino(
        type: TetriminoType.O,
        shape: [
          [1, 1],
          [1, 1],
        ],
        color: Colors.yellow,
        position: position,
      );

  factory Tetrimino.T({Offset? position}) => Tetrimino(
        type: TetriminoType.T,
        shape: [
          [0, 1, 0],
          [1, 1, 1],
          [0, 0, 0],
        ],
        color: Colors.purple,
        position: position,
      );

  factory Tetrimino.S({Offset? position}) => Tetrimino(
        type: TetriminoType.S,
        shape: [
          [0, 1, 1],
          [1, 1, 0],
          [0, 0, 0],
        ],
        color: Colors.green,
        position: position,
      );

  factory Tetrimino.Z({Offset? position}) => Tetrimino(
        type: TetriminoType.Z,
        shape: [
          [1, 1, 0],
          [0, 1, 1],
          [0, 0, 0],
        ],
        color: Colors.red,
        position: position,
      );

  factory Tetrimino.J({Offset? position}) => Tetrimino(
        type: TetriminoType.J,
        shape: [
          [1, 0, 0],
          [1, 1, 1],
          [0, 0, 0],
        ],
        color: Colors.blue,
        position: position,
      );

  factory Tetrimino.L({Offset? position}) => Tetrimino(
        type: TetriminoType.L,
        shape: [
          [0, 0, 1],
          [1, 1, 1],
          [0, 0, 0],
        ],
        color: Colors.orange,
        position: position,
      );

  // Rotate the Tetrimino.
  Tetrimino rotate() {
    var newShape = List.generate(
      shape[0].length,
      (i) => List.generate(shape.length, (j) => shape[j][i]),
      growable: false,
    );

    // Convert the reversed iterable to a list
    for (int i = 0; i < newShape.length; i++) {
      newShape[i] = newShape[i].reversed.toList();
    }

    return Tetrimino(
        type: type,
        shape: newShape,
        color: color,
        position: position);
  }

  // Move the Tetrimino on the grid.
  void moveLeft() {
    position = Offset(position.dx - 1, position.dy);
  }

  void moveRight() {
    position = Offset(position.dx + 1, position.dy);
  }

  void moveDown() {
    position = Offset(position.dx, position.dy + 1);
  }

  void moveUp() {
    position = Offset(position.dx, position.dy - 1);
  }

  // Helper method to print the shape in the console for debugging
  void printShape() {
    for (var row in shape) {
      print(row);
    }
  }

  // Method to set the position of the Tetrimino
  void setPosition(Offset newPosition) {
    position = newPosition;
  }

  // Method to rotate the Tetrimino back to its previous state
  Tetrimino rotateBack() {
    return rotate().rotate().rotate();
  }

  // Static method to get a random Tetrimino
  static Tetrimino random({Offset? position}) {
    Random rng = Random();
    TetriminoType type =
        TetriminoType.values[rng.nextInt(TetriminoType.values.length)];

    switch (type) {
      case TetriminoType.I:
        return Tetrimino.I(position: position);
      case TetriminoType.O:
        return Tetrimino.O(position: position);
      case TetriminoType.T:
        return Tetrimino.T(position: position);
      case TetriminoType.S:
        return Tetrimino.S(position: position);
      case TetriminoType.Z:
        return Tetrimino.Z(position: position);
      case TetriminoType.J:
        return Tetrimino.J(position: position);
      case TetriminoType.L:
        return Tetrimino.L(position: position);
      default:
        return Tetrimino.I(
            position: position); // Default case, can be changed if needed
    }
  }
}
