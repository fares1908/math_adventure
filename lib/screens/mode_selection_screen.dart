import 'package:flutter/material.dart';

import 'game_screen.dart';

class ModeSelectionScreen extends StatelessWidget {
  final String playerName;
  const ModeSelectionScreen({super.key, required this.playerName});

  void startGame(BuildContext context, String mode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          playerName: playerName,
          gameMode: mode,
        ),
      ),
    );
  }

  Widget buildModeButton(
      {required BuildContext context,
      required String label,
      required String subtitle,
      required Color color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.all(5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
        ),
        onPressed: () => startGame(context, label),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        title: Text("Choose Game Mode $playerName"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 180),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildModeButton(
                context: context,
                label: "Classic Mode",
                subtitle: "Timed challenges with scoring",
                color: Colors.blue,
              ),
              buildModeButton(
                context: context,
                label: "Practice Mode",
                subtitle: "Unlimited time, hints available",
                color: Colors.green,
              ),
              buildModeButton(
                context: context,
                label: "Time Attack",
                subtitle: "Answer as many as possible in 2 minutes!",
                color: Colors.orange,
              ),
              buildModeButton(
                context: context,
                label: "Challenge Mode",
                subtitle: "Daily preset challenges",
                color: Colors.pink[200]!,
              ),
              buildModeButton(
                context: context,
                label: "Puzzle Mode",
                subtitle: "Word problems and patterns",
                color: Colors.red,
              ),
              buildModeButton(
                context: context,
                label: "Custom Mode",
                subtitle: "Your own rules and settings",
                color: Colors.yellow[700]!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
