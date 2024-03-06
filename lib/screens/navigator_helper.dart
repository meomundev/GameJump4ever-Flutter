import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jump_game/screens/list_map.dart';
import 'package:jump_game/screens/menu.dart';
import 'package:jump_game/screens/screens_ctrl.dart';

class NavigatorHelper {
  static late BuildContext _context;

  static void init(BuildContext context) {
    _context = context;
  }

  static void menuButton() {
    try {
      Navigator.push(
        _context,
        MaterialPageRoute(builder: (context) => const Menu()),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Navigation error: $e');
      }
    }
  }

  static void listMap() {
    try {
      Navigator.push(
        _context,
        MaterialPageRoute(builder: (context) => const ListMapScreen()),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Navigation error: $e');
      }
    }
  }

  static void mainMenu() {
    try {
      Navigator.push(
        _context,
        MaterialPageRoute(builder: (context) => const ScreensController()),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Navigation error: $e');
      }
    }
  }
}
