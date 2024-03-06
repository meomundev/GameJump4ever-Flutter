import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jump_game/game_jump.dart';
import 'package:jump_game/screens/navigator_helper.dart';
import 'package:jump_game/screens/screens_ctrl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(const MyGameApp());
  // GameJump game = GameJump();
  // runApp(GameWidget(game: game));
}

class MyGameApp extends StatelessWidget {
  const MyGameApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'PixelFont',
      ),
      home: Builder(
        builder: (BuildContext context) {
          NavigatorHelper.init(context);

          return const ScreensController();
        },
      ),
    );
  }
}
