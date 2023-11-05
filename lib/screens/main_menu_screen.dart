import 'package:flutter/material.dart';
import 'package:tetris_game/screens/game_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainMenuScreen extends StatelessWidget {
  final int score = 0; // This should come from your game state
  final int linesCleared = 0; // This should come from your game state
  final int level = 1;

  const MainMenuScreen({super.key}); // This should come from your game state

  @override
  Widget build(BuildContext context) {
    // Ensuring the background color is set to black for the entire screen.
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Play Button with fixed size
            SizedBox(
              width: 200.0, // Ensures all buttons are the same width
              child: MenuButton(
                icon: Icons.play_arrow,
                title: "Play",
                onPressed: () {
                  _saveCurrentState(); // Save the current state if necessary
                  _navigateToGameScreen(context); // Navigate to the GameScreen
                },
              ),
            ),
            const SizedBox(height: 20), // Space between buttons

            // Options Button with fixed size
            SizedBox(
              width: 200.0, // Ensures all buttons are the same width
              child: MenuButton(
                icon: Icons.settings,
                title: "Options",
                onPressed: () {
                  // TODO: Navigate to the options screen
                },
              ),
            ),
            const SizedBox(height: 20), // Space between buttons

            // High Scores Button with fixed size
            SizedBox(
              width: 200.0, // Ensures all buttons are the same width
              child: MenuButton(
                icon: Icons.score,
                title: "High Scores",
                onPressed: () {
                  // TODO: Navigate to the high scores screen
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveCurrentState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Assuming 'score', 'linesCleared', and 'level' are defined in this class
    await prefs.setInt('score', score);
    await prefs.setInt('linesCleared', linesCleared);
    await prefs.setInt('level', level);
  }

  void _navigateToGameScreen(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Fetch the saved state or use default values
    int score = prefs.getInt('score') ?? 0;
    int linesCleared = prefs.getInt('linesCleared') ?? 0;
    int level = prefs.getInt('level') ?? 1;

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => GameScreen(
        initialScore: score,
        initialLinesCleared: linesCleared,
        initialLevel: level,
      ),
    ));
  }

  Future<Map<String, int>> _fetchInitialState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Fetch the saved data, if it exists, or use default values
    int score = prefs.getInt('score') ?? 0;
    int linesCleared = prefs.getInt('linesCleared') ?? 0;
    int level = prefs.getInt('level') ?? 1;

    return {
      'score': score,
      'linesCleared': linesCleared,
      'level': level,
    };
  }
}

class MenuButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;

  const MenuButton({
    Key? key,
    required this.icon,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(
        icon,
        size: 40, // Adjust the size of the icon if needed
        color: Colors.white, // Icon color
      ),
      label: Text(
        title,
        style: const TextStyle(
          fontSize: 18, // Prominent text size
          fontFamily: 'PressStart2P', // Use your custom pixel font
          color: Colors.white, // Text color
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green, // Background color of the button
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 18, // Text size inside the button
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Button corner radius
        ),
      ),
      onPressed: onPressed,
    );
  }
}
