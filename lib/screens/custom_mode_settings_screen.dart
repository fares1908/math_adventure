import 'package:flutter/material.dart';

import 'game_screen.dart';

class CustomModeSettingsScreen extends StatefulWidget {
  final String playerName;
  const CustomModeSettingsScreen({super.key, required this.playerName});

  @override
  State<CustomModeSettingsScreen> createState() =>
      _CustomModeSettingsScreenState();
}

class _CustomModeSettingsScreenState extends State<CustomModeSettingsScreen> {
  final Map<String, bool> operations = {
    'addition': true,
    'subtraction': false,
    'multiplication': false,
    'division': false,
    'general': false,
  };

  double questionCount = 10;
  double timeLimitMinutes = 2;

  void startCustomGame() {
    final selectedTypes = operations.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (selectedTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('اختر نوع واحد على الأقل من الأسئلة'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          playerName: widget.playerName,
          gameMode: "Custom Mode",
          allowedTypes: selectedTypes,
          totalQuestions: questionCount.toInt(),
          timeLimitSeconds: timeLimitMinutes.toInt(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Custom Mode Settings"),
        backgroundColor: Colors.yellow[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Pick the types of questions you want to play:",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ...operations.keys.map((type) => CheckboxListTile(
                  title: Text(type),
                  value: operations[type],
                  onChanged: (val) => setState(() {
                    operations[type] = val!;
                  }),
                )),
            const SizedBox(height: 20),
            Text("How many questions: ${questionCount.toInt()}",
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Slider(
              value: questionCount,
              min: 5,
              max: 50,
              divisions: 9,
              label: questionCount.toInt().toString(),
              onChanged: (val) => setState(() {
                questionCount = val;
              }),
            ),
            const SizedBox(height: 20),
            Text("Set your time: ${timeLimitMinutes.toInt()} minutes",
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Slider(
              value: timeLimitMinutes,
              min: 1,
              max: 10,
              divisions: 9,
              label: timeLimitMinutes.toInt().toString(),
              onChanged: (val) => setState(() {
                timeLimitMinutes = val;
              }),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: startCustomGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: const Text("Start", style: TextStyle(fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
