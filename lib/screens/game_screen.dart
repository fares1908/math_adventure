import 'dart:async';

import 'package:flutter/material.dart';

import '../model/game_result.dart';
import '../model/question.dart';
import '../utils/load_questions.dart';
import '../utils/map_operator_to_types.dart';
import 'animated_background_wrapper.dart';
import 'chiness.dart';
import 'finger_counter.dart';
import 'home_screen.dart';
import 'settings_page.dart';

class GameScreen extends StatefulWidget {
  final String playerName;

  /// أنواع الأسئلة التى يسمح بها هذا الجيم
  final List<String> allowedTypes;

  /// عدد الأسئلة فى الجيم
  final int totalQuestions;
  const GameScreen(
      {required this.playerName,
      this.allowedTypes = const [
        'addition',
        'subtraction',
        'multiplication',
        'division',
        'fingers',
        'general',
      ],
      this.totalQuestions = 10,
      super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late List<Question> questions;
  int currentIndex = 0;
  int score = 0;
  int streak = 0;
  int correctAnswers = 0;
  bool isLoading = true;
  bool showSummary = false;
  late int totalTimeSeconds;

  String? feedbackMessage;
  Color? feedbackColor;

  int? lastAnswer;

  TextEditingController answerController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  Timer? gameTimer;
  int remainingSeconds = 0;
  final int totalQuestions = 10;
  @override
  void initState() {
    super.initState();
    loadSettingsAndQuestions();
  }

  Future<void> loadSettingsAndQuestions() async {
    final timeLimit = await SettingsStorage.loadTimeLimit();
    final questionCount = await SettingsStorage.loadQuestionCount();
    final operations = await SettingsStorage.loadOperations();

    final allowedTypes = mapOperatorsToTypes(operations);

    totalTimeSeconds = timeLimit * 60;
    remainingSeconds = totalTimeSeconds;

    final loadedQuestions = await loadQuestionsFromAsset(
      allowedTypes: allowedTypes,
      total: questionCount,
    );

    debugPrint('Loaded types: ${loadedQuestions.map((q) => q.type).toSet()}');

    setState(() {
      questions = loadedQuestions;
      isLoading = false;
    });

    gameTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingSeconds > 0) {
        setState(() => remainingSeconds--);
      } else {
        gameTimer?.cancel();
        _showSummaryDialog();
      }
    });
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    answerController.dispose();
    nameController.dispose();
    super.dispose();
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  void submitAnswer() {
    final answerText = answerController.text.trim();
    if (answerText.isEmpty) return;

    final currentQuestion = questions[currentIndex];
    bool isCorrect = answerText == currentQuestion.answer.toString();

    setState(() {
      lastAnswer =
          int.tryParse(currentQuestion.answer.toString()); // ✅ حفظ الإجابة

      if (isCorrect) {
        score += 10;
        streak += 1;
        correctAnswers += 1;
        feedbackMessage = "✅ Correct Answer!";
        feedbackColor = Colors.green;
      } else {
        streak = 0;
        feedbackMessage =
            "❌ Wrong! The correct answer was: ${currentQuestion.answer}";
        feedbackColor = Colors.red;
      }

      answerController.clear();
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        feedbackMessage = null;
        lastAnswer = null; // ✅ مسح بعد عرض الإجابة
        if (currentIndex < questions.length - 1) {
          currentIndex += 1;
        } else {
          gameTimer?.cancel();
          _showSummaryDialog();
        }
      });
    });
  }

  void _showSummaryDialog() {
    setState(() => showSummary = true);
  }

  int getLeftFinger(dynamic answer) {
    int val = int.tryParse(answer.toString()) ?? 0;
    return val > 9 ? 5 : val.clamp(0, 5);
  }

  int getRightFinger(dynamic answer) {
    int val = int.tryParse(answer.toString()) ?? 0;
    return val > 9 ? val - getLeftFinger(val) : (val > 5 ? val - 5 : 0);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: AnimatedBackgroundWrapper(
            vsync: this,
            child: const Center(child: CircularProgressIndicator())),
      );
    }

    if (showSummary) {
      double accuracy = (correctAnswers / questions.length) * 100;

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
                          Text("🔹 Final Score: $score"),
                          Text("🔹 Questions Answered: ${currentIndex + 1}"),
                          Text("🔹 Correct Answers: $correctAnswers"),
                          Text("🔹 Accuracy: ${accuracy.toStringAsFixed(1)}%"),
                          Text("🔹 Best Streak: $streak"),
                          Text(
                              "🔹 Total Time: ${formatTime(totalTimeSeconds - remainingSeconds)}"),
                          const SizedBox(height: 24),
                          Text("✨ NEW HIGH SCORE! ✨",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.yellow[800])),
                          const SizedBox(height: 12),
                          TextField(
                            controller: nameController,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                                hintText: "Enter your name...",
                                border: OutlineInputBorder()),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () async {
                              final name = nameController.text.trim();
                              if (name.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Please enter your name before saving."),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              await DatabaseHelper.insertResult(GameResult(
                                name: name,
                                score: score,
                                accuracy: accuracy,
                              ));
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            child: const Text("Save Score"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HomeScreen()));
                            },
                            child: const Text(
                              'Skip',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ])))),
      );
    }

    final currentQuestion = questions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Math Adventure for ${widget.playerName}'),
        backgroundColor: Colors.purple,
      ),
      body: AnimatedBackgroundWrapper(
        vsync: this,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Score: $score"),
                    Text(
                        " Accuracy: ${((correctAnswers / (currentIndex + 1)) * 100).toStringAsFixed(1)}%"),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 18),
                        const SizedBox(width: 4),
                        Text(formatTime(remainingSeconds),
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Text(" Streak: $streak"),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (currentIndex + 1) / questions.length,
                  backgroundColor: Colors.grey[300],
                  color: Colors.deepPurple,
                  minHeight: 10,
                ),
                const SizedBox(height: 10),
                Text(
                  currentQuestion.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: answerController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                  onSubmitted: (_) => submitAnswer(),
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    hintText: "Type your answer here...",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: submitAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Submit Answer"),
                ),
                if (feedbackMessage != null)
                  Text(
                    feedbackMessage!,
                    style: TextStyle(
                        color: feedbackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // بطاقة الأباكس
                    Expanded(
                      child: ChineseAbacus(
                        number: lastAnswer ?? 0,
                        width: 260,
                        height: 200,
                      ),
                    ),

                    const SizedBox(width: 20),
                    Expanded(
                      child: FingerCounterBox(
                        number: lastAnswer ?? 0,
                        w: 260,
                        h: 200,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
