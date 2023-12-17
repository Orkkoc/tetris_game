import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tetris_game/models/tetrimino.dart';

class GameScreen extends StatefulWidget {
  final int initialScore;
  final int initialLinesCleared;
  final int initialLevel;

  const GameScreen({
    Key? key,
    required this.initialScore,
    required this.initialLinesCleared,
    required this.initialLevel,
  }) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late Ticker _gameTicker;
  late int score;
  late int linesCleared;
  late int level;
  bool isGamePaused = false;

  // Define the width and height of the game board
  final int boardWidth = 8;
  final int boardHeight = 10;

  // Represent the game board as a 2D list (this will be initialized in initState)
  late List<List<int>> board;

  late Tetrimino currentTetrimino;

  bool _isCellPartOfTetrimino(int x, int y) {
    // Check if the coordinates fall within the Tetrimino's shape.
    // Transform grid coordinates to Tetrimino's local coordinates.
    int localX = x - currentTetrimino.position.dx.toInt();
    int localY = y - currentTetrimino.position.dy.toInt();

    // Check if the coordinates are within the bounds of the Tetrimino's shape
    if (localX >= 0 &&
        localX < currentTetrimino.shape[0].length &&
        localY >= 0 &&
        localY < currentTetrimino.shape.length) {
      return currentTetrimino.shape[localY][localX] == 1;
    }
    return false; // The cell is not part of the Tetrimino
  }

  @override
  void initState() {
    super.initState();
    // Initialize the game state with the provided values
    score = widget.initialScore;
    linesCleared = widget.initialLinesCleared;
    level = widget.initialLevel;
    // Initialize the game board to be empty
    board = List.generate(boardHeight, (index) => List.filled(boardWidth, 0));

    // Initialize the ticker
    _gameTicker = createTicker(_onTick)..start();
    // Initialize Tetrimino
    currentTetrimino = Tetrimino.random();
  }

  @override
  void dispose() {
    _gameTicker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    if (!isGamePaused) {
      setState(() {
        // Simulate Tetrimino falling
        var newPosition = Offset(
            currentTetrimino.position.dx, currentTetrimino.position.dy + 1);
        if (_canMoveToPosition(newPosition)) {
          currentTetrimino.setPosition(newPosition);
        } else {
          // If Tetrimino can't move down, place it on the board
          _placeTetriminoOnBoard();
          _generateNewTetrimino(); // Generate a new Tetrimino
        }
      });
    }
  }

  void _generateNewTetrimino() {
    setState(() {
      // Generate a new Tetrimino and set its starting position.
      // The starting position is typically at the top of the board, in the middle.
      currentTetrimino = Tetrimino.random(
          position: Offset((boardWidth / 2).floor() as double, 0));
    });
  }

  void _togglePause() {
    setState(() {
      isGamePaused = !isGamePaused;
    });
    if (isGamePaused) {
      _gameTicker.stop();
    } else {
      _gameTicker.start();
    }
  }

  bool _canMoveToPosition(Offset newPosition) {
    for (int y = 0; y < currentTetrimino.shape.length; y++) {
      for (int x = 0; x < currentTetrimino.shape[y].length; x++) {
        if (currentTetrimino.shape[y][x] == 1) {
          int boardX = x + newPosition.dx.toInt();
          int boardY = y + newPosition.dy.toInt();

          if (boardX < 0 ||
              boardX >= boardWidth ||
              boardY < 0 ||
              boardY >= boardHeight ||
              board[boardY][boardX] == 1) {
            return false; // Collision detected
          }
        }
      }
    }
    return true; // No collision
  }

  void _placeTetriminoOnBoard() {
    for (int y = 0; y < currentTetrimino.shape.length; y++) {
      for (int x = 0; x < currentTetrimino.shape[y].length; x++) {
        if (currentTetrimino.shape[y][x] == 1) {
          int boardX = x + currentTetrimino.position.dx.toInt();
          int boardY = y + currentTetrimino.position.dy.toInt();

          if (boardY < boardHeight && boardX < boardWidth) {
            board[boardY][boardX] = 1; // Place Tetrimino block on the board
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Score Display
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Score: $score',
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),

            // Next Tetrimino preview window
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                ),
                // Placeholder for the next Tetrimino
                child: const Center(
                  child: Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),

            // Gameplay Area in the center
            Expanded(
              flex: 3,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: boardWidth,
                ),
                itemCount: boardWidth * boardHeight,
                itemBuilder: (BuildContext context, int index) {
                  int x = index % boardWidth;
                  int y = index ~/ boardWidth;

                  bool isPartOfTetrimino = _isCellPartOfTetrimino(x, y);
                  Color cellColor =
                      isPartOfTetrimino ? currentTetrimino.color : Colors.black;

                  return Container(
                    margin: const EdgeInsets.all(0.5),
                    decoration: BoxDecoration(
                      color: cellColor,
                      border: Border.all(color: Colors.grey),
                    ),
                  );
                },
              ),
            ),

            // Control buttons (pause/resume)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _togglePause,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: isGamePaused ? Colors.green : Colors.red,
                ),
                child: Text(isGamePaused ? 'Resume' : 'Pause'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
