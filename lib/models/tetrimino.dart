import 'dart:math';

import 'package:flutter/material.dart';

// Define the types of Tetriminos.
enum TetriminoType { I, O, T, S, Z, J, L }

// This will store the shape, color, and position for each Tetrimino type.
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

  // Factory methods to create different types of Tetriminos.
  factory Tetrimino.I({Offset? position}) {
    return Tetrimino(
      type: TetriminoType.I,
      shape: [
        [0, 0, 0, 0],
        [1, 1, 1, 1],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ],
      color: Colors.cyan,
      position: position,
    );
  }

  // Add factory constructors for other Tetriminos here...

  // Rotate the Tetrimino.
  Tetrimino rotate() {
    // Use the map function to create a new rotated matrix.
    var newShape = List.generate(
      shape.length,
      (i) => List.generate(shape.length, (j) => shape[j][i]),
      growable: false,
    );

    // Reverse each row to get the correct rotation.
    // The reversed collection is not a list, so we need to create a new list from it.
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
    // Calling rotate 3 times returns to the previous state
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
      // Add cases for other Tetrimino types...
      default:
        return Tetrimino.I(
            position: position); // Default to I if not implemented yet
    }
  }
}
