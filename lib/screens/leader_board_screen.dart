import 'package:flutter/material.dart';

import '../model/game_result.dart';
import 'animated_background_wrapper.dart'; // استيراد الملف اللي فيه الخلفية

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏆 Leaderboard'),
        backgroundColor: Colors.blue,
      ),
      body: AnimatedBackgroundWrapper(
        vsync: this,
        child: FutureBuilder<List<GameResult>>(
          future: DatabaseHelper.getAllResults(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final results = snapshot.data!;
            if (results.isEmpty) {
              return const Center(
                  child: Text('No results yet.',
                      style: TextStyle(color: Colors.white)));
            }

            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                return Card(
                  color: Colors.white,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    leading: Text("${index + 1}.",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    title: Text(result.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Score: ${result.score} | Accuracy: ${result.accuracy.toStringAsFixed(1)}%",
                        ),
                        Text(
                          "Mode: ${result.mode}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
