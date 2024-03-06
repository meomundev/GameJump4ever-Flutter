import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jump_game/screens/screens_ctrl.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('PAUSED',
                      style: TextStyle(
                          fontSize: 80,
                          color: Color(0xff93db5f),
                          fontFamily: 'PixelFontBold')),
                  const SizedBox(height: 72),
                  InkWell(
                    onTap: () => _resume(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xff93db5f),
                      ),
                      child: const Text(
                        'Resume',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  InkWell(
                    onTap: () => _settingGame(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xff93db5f),
                      ),
                      child: const Text(
                        'Setting',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  InkWell(
                    onTap: () => _backToMainMenu(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xff93db5f),
                      ),
                      child: const Text(
                        'Back to main menu',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _resume(BuildContext context) {
    Navigator.pop(context);
    SystemNavigator.pop();
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
