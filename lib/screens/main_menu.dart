import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jump_game/screens/customPageRoute.dart';
import 'package:jump_game/screens/screens_ctrl.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/backgrounds/mainMenu.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 18),
                const Text('RAVENOUS MEOMEO',
                    style: TextStyle(
                        fontSize: 80,
                        color: Color(0xff93db5f),
                        fontFamily: 'PixelFontBold')),
                const SizedBox(height: 24),
                InkWell(
                  onTap: () => _startGame(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xff93db5f),
                    ),
                    child: const Text(
                      'Start Game',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () => _settingGame(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xff93db5f),
                    ),
                    child: const Text(
                      'Setting',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () => _exitGame(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xff93db5f),
                    ),
                    child: const Text(
                      'Exit',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _startGame(BuildContext context) {
    Navigator.push(
      context,
      CustomPageRoute(
        builder: (context, animation, secondaryAnimation) =>
            const ScreensController(screen: ListScreens.gamePlay),
      ),
    );
  }

  // void _startGame(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => const VideoPlayerScreen(),
  //     ),
  //   );
  // }

  void _settingGame(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ScreensController(
            screen: ListScreens.setting,
          ),
        ));
  }

  void _exitGame(BuildContext context) {
    Navigator.pop(context);
    SystemNavigator.pop();
  }
}
