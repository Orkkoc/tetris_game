import 'package:flutter/material.dart';
import 'package:tetris_game/themes/game_theme.dart';
import 'screens/main_menu_screen.dart'; // Import the main menu screen here

void main() {
  runApp(const TetrisApp());
}

class TetrisApp extends StatelessWidget {
  const TetrisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tetris Game',
      theme: GameTheme.themeData,
      home: Scaffold(
        backgroundColor:
            Colors.black, // Mimicking the Game Boy's surrounding case color
        body: Container(
          decoration: BoxDecoration(
            // Using a gradient instead of an image
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey[800]!,
                Colors.grey[900]!
              ], // Adjust these colors to match your game's theme
              stops: const [0.0, 1.0],
            ),
          ),
          child: const MainMenuScreen(), // Your main menu screen
        ),
      ),
    );
  }
}
