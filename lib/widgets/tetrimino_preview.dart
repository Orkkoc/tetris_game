import 'package:flutter/material.dart';
import 'package:tetris_game/models/tetrimino.dart';

class TetriminoPreview extends StatelessWidget {
  final Tetrimino tetrimino;

  const TetriminoPreview({Key? key, required this.tetrimino}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Assuming each Tetrimino's shape is a square matrix
    int size = tetrimino.shape.length;

    return Container(
      width: 100,
      height: 100,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        color: Colors.black, // Background color of the preview area
      ),
      child: GridView.builder(
        itemCount: size * size,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: size,
        ),
        itemBuilder: (context, index) {
          int x = index % size;
          int y = index ~/ size;

          bool isFilled = tetrimino.shape[y][x] == 1;
          return Container(
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isFilled ? tetrimino.color : Colors.transparent,
              border: isFilled ? Border.all(color: tetrimino.color) : null,
            ),
          );
        },
      ),
    );
  }
}
