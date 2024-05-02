import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jump_game/screens/screens_ctrl.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
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
              const SizedBox(
                height: 18,
              ),
              const Text('PAUSED',
                  style: TextStyle(
                      fontSize: 80,
                      color: Color(0xff93db5f),
                      fontFamily: 'PixelFontBold')),
              const SizedBox(height: 24),
              InkWell(
                onTap: () => _resume(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xff93db5f),
                  ),
                  child: const Text(
                    'Resume',
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
                onTap: () => _backToMainMenu(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xff93db5f),
                  ),
                  child: const Text(
                    'Back to main menu',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  _resume(BuildContext context) {
    Navigator.pop(context);
  }

  _settingGame(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ScreensController(
            screen: ListScreens.setting,
          ),
        ));
  }

  _backToMainMenu(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ScreensController(
            screen: ListScreens.mainMenu,
          ),
        ));
  }
}
