import 'dart:math';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';

class AnimatedBackgroundWrapper extends StatefulWidget {
  final Widget child;
  final TickerProvider vsync;

  const AnimatedBackgroundWrapper({
    super.key,
    required this.child,
    required this.vsync,
  });

  @override
  State<AnimatedBackgroundWrapper> createState() =>
      _AnimatedBackgroundWrapperState();
}

class _AnimatedBackgroundWrapperState extends State<AnimatedBackgroundWrapper> {
  Color getRandomColor() {
    final colors = [
      Colors.orangeAccent,
      Colors.greenAccent,
      Colors.blueAccent,
      Colors.pinkAccent,
      Colors.amber,
      Colors.cyan,
      Colors.deepPurpleAccent,
      Colors.redAccent,
    ];
    return colors[Random().nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      behaviour: RandomParticleBehaviour(
        options: const ParticleOptions(
          spawnOpacity: 0.0,
          opacityChangeRate: 0.25,
          minOpacity: 0.1,
          maxOpacity: 0.4,
          spawnMinSpeed: 10.0,
          spawnMaxSpeed: 100.0,
          spawnMinRadius: 2.0,
          spawnMaxRadius: 6.0,
          particleCount: 30,
        ),
        paint: Paint()..color = getRandomColor(),
      ),
      vsync: widget.vsync,
      child: widget.child,
    );
  }
}
