import 'package:flutter/material.dart';

import 'animated_background_wrapper.dart';
import 'home_screen.dart';

class SummaryScreen extends StatefulWidget {
  final int score;
  final int correctAnswers;
  final int totalQuestions;
  final int streak;
  final int totalTimeSeconds;
  final int remainingSeconds;

  final TextEditingController nameController;
  final void Function(String name) onSave;

  const SummaryScreen({
    super.key,
    required this.score,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.streak,
    required this.totalTimeSeconds,
    required this.remainingSeconds,
    required this.nameController,
    required this.onSave,
  });

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen>
    with TickerProviderStateMixin {
  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    final accuracy = (widget.correctAnswers / widget.totalQuestions) * 100;
    return Scaffold(
      body: AnimatedBackgroundWrapper(
        vsync: this,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("✨ AMAZING! MATH MASTER! ✨",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.orange)),
                const SizedBox(height: 16),
                const Text("🔹 Mode: Puzzle Mode"),
                Text("🔹 Final Score: ${widget.score}"),
                Text("🔹 Questions Answered: ${widget.totalQuestions}"),
                Text("🔹 Correct Answers: ${widget.correctAnswers}"),
                Text("🔹 Accuracy: ${accuracy.toStringAsFixed(1)}%"),
                Text("🔹 Best Streak: ${widget.streak}"),
                Text(
                    "🔹 Total Time: ${formatTime(widget.totalTimeSeconds - widget.remainingSeconds)}"),
                const SizedBox(height: 24),
                Text("✨ NEW HIGH SCORE! ✨",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.yellow[800])),
                const SizedBox(height: 12),
                TextField(
                  controller: widget.nameController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                      hintText: "Enter your name...",
                      border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    final name = widget.nameController.text.trim();
                    widget.onSave(name);
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Save Score"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                  },
                  child: const Text(
                    'Skip',
                    textAlign: TextAlign.center,
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
