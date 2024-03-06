import 'package:flutter/material.dart';
import 'package:jump_game/game_jump.dart';
import 'package:jump_game/screens/screens_ctrl.dart';

class ListMapScreen extends StatelessWidget {
  const ListMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double widthButtonListMap = 112;
    List<int> mapIndices = [1, 2, 3, 4, 5];
    GameJump game = GameJump();
    int currentMapIndex = game.currentMapIndex + 1;

    return Scaffold(
        backgroundColor: const Color(0xFF21263F),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('List Map',
                  style: TextStyle(
                      fontSize: 80,
                      color: Color(0xff93db5f),
                      fontFamily: 'PixelFontBold')),
              const SizedBox(height: 72),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: mapIndices.map((index) {
                  Color buttonColor = const Color(0xff6d6d6d);
                  if (currentMapIndex == index) {
                    buttonColor = const Color(0xffd90c0c);
                  } else if (currentMapIndex > index) {
                    buttonColor = const Color(0xff93db5f);
                  }
                  return Row(
                    children: [
                      InkWell(
                        onTap: () {
                          if (currentMapIndex == index) {
                            loadMap(context);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          width: widthButtonListMap,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: buttonColor,
                          ),
                          child: Text(
                            index.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48)
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 72),
              InkWell(
                onTap: () => _backToMainMenuScreen(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xff93db5f),
                  ),
                  child: const Text(
                    'Back',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 32),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  void loadMap(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const ScreensController(screen: ListScreens.gamePlay),
      ),
    );
  }

  void _backToMainMenuScreen(BuildContext context) {
    Navigator.pop(context);
  }
}
