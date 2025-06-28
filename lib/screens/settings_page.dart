import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'animated_background_wrapper.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with TickerProviderStateMixin {
  int _timeLimit = 5;
  int _questionCount = 20;
  Set<String> _operations = {'+', '-', '×'};
  final List<int> timeOptions = [3, 5, 10, 15];
  final List<int> questionOptions = [10, 20, 30, 50];
  final List<String> opOptions = ['+', '-', '×', '÷'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final loadedTime = await SettingsStorage.loadTimeLimit();
    final loadedCount = await SettingsStorage.loadQuestionCount();
    final loadedOps = await SettingsStorage.loadOperations();

    setState(() {
      _timeLimit = loadedTime;
      _questionCount = loadedCount;
      _operations = loadedOps;
    });
  }

  Widget _buildOption<T>({
    required T value,
    required bool selected,
    required void Function() onTap,
    EdgeInsets margin = const EdgeInsets.symmetric(horizontal: 6),
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xff3DDB6F) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Text(
          value.toString(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: selected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(children: children),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffdbe1ff),
      appBar: AppBar(
        title: const Text('⚙︎  SETTINGS  ⚙︎',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: AnimatedBackgroundWrapper(
        vsync: this,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                '⏱  Time Limit:',
                timeOptions
                    .map((t) => _buildOption<int>(
                          value: t,
                          selected: t == _timeLimit,
                          onTap: () async {
                            setState(() => _timeLimit = t);
                            await SettingsStorage.save(
                              timeLimit: _timeLimit,
                              questionCount: _questionCount,
                              operations: _operations,
                            );
                          },
                        ))
                    .toList(),
              ),
              _buildSection(
                '❓ Question Count:',
                questionOptions
                    .map((q) => _buildOption<int>(
                          value: q,
                          selected: q == _questionCount,
                          onTap: () async {
                            setState(() => _questionCount = q);
                            await SettingsStorage.save(
                              timeLimit: _timeLimit,
                              questionCount: _questionCount,
                              operations: _operations,
                            );
                          },
                        ))
                    .toList(),
              ),
              _buildSection(
                '🔢 Operations:',
                opOptions
                    .map((op) => _buildOption<String>(
                          value: op,
                          selected: _operations.contains(op),
                          onTap: () async {
                            setState(() {
                              if (_operations.contains(op)) {
                                _operations.remove(op);
                              } else {
                                _operations.add(op);
                              }
                            });
                            await SettingsStorage.save(
                              timeLimit: _timeLimit,
                              questionCount: _questionCount,
                              operations: _operations,
                            );
                          },
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsStorage {
  static const String _kTimeLimit = 'timeLimit';
  static const String _kQuestionCount = 'questionCount';
  static const String _kOperations = 'operations';

  static Future<void> save({
    required int timeLimit,
    required int questionCount,
    required Set<String> operations,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kTimeLimit, timeLimit);
    await prefs.setInt(_kQuestionCount, questionCount);
    await prefs.setStringList(_kOperations, operations.toList());
  }

  static Future<int> loadTimeLimit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kTimeLimit) ?? 5;
  }

  static Future<int> loadQuestionCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kQuestionCount) ?? 20;
  }

  static Future<Set<String>> loadOperations() async {
    final prefs = await SharedPreferences.getInstance();
    final ops = prefs.getStringList(_kOperations);
    return ops?.toSet() ?? {'+', '-', '×'};
  }
}
