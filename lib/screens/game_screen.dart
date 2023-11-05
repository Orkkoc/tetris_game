import 'package:flutter/material.dart';

import 'package:flutter/scheduler.dart';

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
  final int boardWidth = 10;
  final int boardHeight = 20;

  // Represent the game board as a 2D list (this will be initialized in initState)
  late List<List<int>> board;

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
  }

  @override
  void dispose() {
    _gameTicker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    // This function will be called 60 times per second.
    if (!isGamePaused) {
      setState(() {
        // Here, you would add your game update logic
        // For now, let's just increase the score as an example
        score += 10;
      });
    }
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
                  Color cellColor =
                      board[y][x] == 0 ? Colors.black : Colors.green;
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
                  foregroundColor: Colors.white, backgroundColor: isGamePaused ? Colors.green : Colors.red,
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
