import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:jump_game/game_jump.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  GameJump gameJump = GameJump();
  bool isJoyStickEnabled = true; // Biến trạng thái

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isJoyStickEnabled = !isJoyStickEnabled;
                  gameJump.useJoyStick = !gameJump.useJoyStick;
                  print(gameJump.useJoyStick);
                });
              },
              child: Text(
                  isJoyStickEnabled ? 'Disable Joystick' : 'Enable Joystick'),
            ),
            IconButton(
              onPressed: () => _backScreen(context),
              icon: const Icon(Icons.arrow_back),
            ),
          ],
        ),
      ),
    );
  }

  void _backScreen(BuildContext context) {
    Navigator.pop(context);
  }
}
