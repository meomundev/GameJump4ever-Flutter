import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:jump_game/game_jump.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GameWidget(
          game: GameJump(),
        ),
      ),
    );
  }
}
