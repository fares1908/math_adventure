import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_adventure/screens/settings_page.dart';

import 'animated_background_wrapper.dart';
import 'enter_name_screen.dart';
import 'game_screen.dart';
import 'leader_board_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Widget buildButton(String text, Color color, VoidCallback onPressed) {
    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildTitle() {
    return RichText(
      text: const TextSpan(
        children: [
          TextSpan(
              text: 'M', style: TextStyle(color: Colors.red, fontSize: 32)),
          TextSpan(
              text: 'a', style: TextStyle(color: Colors.green, fontSize: 32)),
          TextSpan(
              text: 't', style: TextStyle(color: Colors.blue, fontSize: 32)),
          TextSpan(
              text: 'h ', style: TextStyle(color: Colors.orange, fontSize: 32)),
          TextSpan(
              text: 'A', style: TextStyle(color: Colors.blue, fontSize: 32)),
          TextSpan(
              text: 'd', style: TextStyle(color: Colors.pink, fontSize: 32)),
          TextSpan(
              text: 'v', style: TextStyle(color: Colors.brown, fontSize: 32)),
          TextSpan(
              text: 'e', style: TextStyle(color: Colors.cyan, fontSize: 32)),
          TextSpan(
              text: 'n', style: TextStyle(color: Colors.red, fontSize: 32)),
          TextSpan(
              text: 't', style: TextStyle(color: Colors.green, fontSize: 32)),
          TextSpan(
              text: 'u', style: TextStyle(color: Colors.blue, fontSize: 32)),
          TextSpan(
              text: 'r', style: TextStyle(color: Colors.orange, fontSize: 32)),
          TextSpan(
              text: 'e!', style: TextStyle(color: Colors.red, fontSize: 32)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE0F7FA),
      body: AnimatedBackgroundWrapper(
        vsync: this,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              buildTitle(),
              const SizedBox(height: 12),

              // Buttons
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Learn math while having fun!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.blue[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      buildButton("Enter Your Name", Colors.purple, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EnterNameScreen()),
                        );
                      }),
                      buildButton("Quick Play (Classic)", Colors.green, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const GameScreen(
                              playerName: '', gameMode: '',
                              // allowedTypes: [
                              //   'addition',
                              //   'subtraction',
                              //   'multiplication'
                              // ],
                            ),
                          ),
                        );
                      }),
                      buildButton("Leaderboard", Colors.orange, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LeaderboardScreen()),
                        );
                      }),
                      buildButton(
                        "Settings",
                        Colors.deepOrange,
                        () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SettingsPage(),
                            ),
                          );
                        },
                      ),
                      buildButton("Exit", Colors.red, () async {
                        final shouldExit = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Exit Confirmation"),
                            content: const Text(
                                "Are you sure you want to close the app?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("Exit",
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );

                        if (shouldExit == true) {
                          SystemNavigator.pop(); // Close the app
                        }
                      }),
                      const SizedBox(height: 12),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     const Text(
                      //       "Voice Mode:",
                      //       style: TextStyle(
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: 16,
                      //         color: Colors.black87,
                      //       ),
                      //     ),
                      //     const SizedBox(
                      //         width: 6), // مسافة بسيطة بين النص والسويتش
                      //     Switch(
                      //       value: isVoiceModeOn,
                      //       onChanged: (val) {
                      //         setState(() {
                      //           isVoiceModeOn = val;
                      //         });
                      //       },
                      //     ),
                      //     const SizedBox(width: 6),
                      //     Text(
                      //       isVoiceModeOn ? "ON" : "OFF",
                      //       style: TextStyle(
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: 16,
                      //         color: isVoiceModeOn
                      //             ? Colors.green[700]
                      //             : Colors.red[600],
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),

              // const Spacer(),
              // Voice Mode Switch

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
