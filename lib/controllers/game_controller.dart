import 'dart:async';
import 'dart:ui';
import 'package:tetris_game/models/tetrimino.dart';

class GameController {
  final int width;
  final int height;
  late List<List<int>> grid;
  late Tetrimino currentTetrimino;
  late int score;
  late bool isGameOver;
  Timer? _gameTickTimer;

  GameController({required this.width, required this.height}) {
    _initialize();
  }

  void _initialize() {
    // Initialize the game grid with zeros
    grid = List.generate(height, (_) => List.generate(width, (_) => 0));
    // Reset score
    score = 0;
    // Game is not over initially
    isGameOver = false;
    // Create the first Tetrimino
    _spawnTetrimino();
    // Start the game tick
    _startGameTick();
  }

  void _spawnTetrimino() {
    // Randomly pick a new Tetrimino
    currentTetrimino = Tetrimino.random();
    // Set the initial position (usually the top middle of the grid)
    currentTetrimino.setPosition(Offset((width ~/ 2).toDouble(), 0.toDouble()));
    // If the new Tetrimino collides immediately, the game is over
    if (_checkCollision(currentTetrimino)) {
      isGameOver = true;
      _gameTickTimer?.cancel();
      // Handle game over logic here
    }
  }

  void moveLeft() {
    // Move the Tetrimino left if there's no collision
    currentTetrimino.moveLeft();
    if (_checkCollision(currentTetrimino)) {
      currentTetrimino.moveRight();
    }
  }

  void moveRight() {
    // Move the Tetrimino right if there's no collision
    currentTetrimino.moveRight();
    if (_checkCollision(currentTetrimino)) {
      currentTetrimino.moveLeft();
    }
  }

  void rotate() {
    // Rotate the Tetrimino if there's no collision
    currentTetrimino = currentTetrimino.rotate();
    if (_checkCollision(currentTetrimino)) {
      currentTetrimino = currentTetrimino.rotateBack();
    }
  }

  void drop() {
    // Drop the Tetrimino down if there's no collision
    currentTetrimino.moveDown();
    if (_checkCollision(currentTetrimino)) {
      currentTetrimino.moveUp();
      _mergeTetriminoWithGrid();
      _spawnTetrimino();
    }
  }

  void _mergeTetriminoWithGrid() {
    // Merge the Tetrimino with the grid and check for line clears
    for (int y = 0; y < currentTetrimino.shape.length; y++) {
      for (int x = 0; x < currentTetrimino.shape[y].length; x++) {
        if (currentTetrimino.shape[y][x] == 1) {
          int gridX = x + currentTetrimino.position.dx.toInt();
          int gridY = y + currentTetrimino.position.dy.toInt();
          if (gridY >= 0 && gridY < height && gridX >= 0 && gridX < width) {
            grid[gridY][gridX] = 1; // Mark the grid cell as filled
          }
        }
      }
    }
    _clearFullLines();
  }

  void _clearFullLines() {
    // Check for and clear full lines
    grid.removeWhere((row) => row.every((cell) => cell == 1));
    while (grid.length < height) {
      grid.insert(0, List.generate(width, (_) => 0));
    }
  }

  bool _checkCollision(Tetrimino tetrimino) {
    for (int y = 0; y < tetrimino.shape.length; y++) {
      for (int x = 0; x < tetrimino.shape[y].length; x++) {
        if (tetrimino.shape[y][x] == 1) {
          int gridX = x + tetrimino.position.dx.toInt();
          int gridY = y + tetrimino.position.dy.toInt();
          if (gridX < 0 ||
              gridX >= width ||
              gridY >= height ||
              (gridY >= 0 && grid[gridY][gridX] == 1)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void _startGameTick() {
    // Start or restart the game tick timer
    _gameTickTimer?.cancel();
    _gameTickTimer =
        Timer.periodic(const Duration(milliseconds: 1000), (Timer timer) {
      if (!isGameOver) {
        drop();
      }
    });
  }
}
