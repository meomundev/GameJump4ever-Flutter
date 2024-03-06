import 'package:flutter/material.dart';
import 'package:jump_game/screens/game_Screen.dart';
import 'package:jump_game/screens/list_map.dart';
import 'package:jump_game/screens/main_menu.dart';
import 'package:jump_game/screens/setting.dart';

enum ListScreens { mainMenu, listMap, setting, gamePlay, menu, gameScreen }

// ignore: must_be_immutable
class ScreensController extends StatelessWidget {
  final ListScreens screen;

  const ScreensController({super.key, this.screen = ListScreens.mainMenu});

  @override
  Widget build(BuildContext context) {
    GameScreen gameScreen = const GameScreen();
    ListMapScreen listMapScreen = const ListMapScreen();
    MainMenuScreen mainMenuScreen = const MainMenuScreen();
    SettingScreen settingScreen = const SettingScreen();
    Widget currentScreen;

    switch (screen) {
      case ListScreens.mainMenu:
        currentScreen = mainMenuScreen;
        break;
      case ListScreens.listMap:
        currentScreen = listMapScreen;
        break;
      case ListScreens.setting:
        currentScreen = settingScreen;
        break;
      case ListScreens.gamePlay:
        currentScreen = gameScreen;
        break;
      default:
        currentScreen = Container();
    }

    return Scaffold(
      body: currentScreen,
    );
  }
}
