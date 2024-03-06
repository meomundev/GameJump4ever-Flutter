import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:jump_game/components/buttons/jump_button.dart';
import 'package:jump_game/components/buttons/menu_button.dart';
import 'package:jump_game/components/level.dart';
import 'package:jump_game/components/player.dart';
import 'package:jump_game/screens/list_map.dart';

class GameJump extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  late CameraComponent cam;
  Player player = Player(character: 'cat_white');
  late JoystickComponent joystick;
  bool showControls = true;
  List<String> mapNames = [
    'Level-01',
    'Level-02',
    'Level-03',
    'Level-04',
    'Level-05'
  ];
  int currentMapIndex = 1;
  bool playSounds = true;
  double soundVolume = 1.0;
  bool needResetMap = false;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  ListMapScreen listMapScreen = const ListMapScreen();

  @override
  Color backgroundColor() => const Color(0xFF221f30);
  // Color backgroundColor() => Color.fromARGB(255, 89, 97, 160);

  // Load Game //
  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    if (showControls) {
      addJoystick();
      add(JumpButton());
    }
    add(MenuButton());
    _loadMap();

    return super.onLoad();
  }

  // Update //
  @override
  void update(double dt) {
    if (showControls) {
      updateJoystick();
    }
    super.update(dt);
  }

  // METHOD add joystick on the game //
  void addJoystick() {
    joystick = JoystickComponent(
        priority: 3,
        knob: SpriteComponent(sprite: Sprite(images.fromCache('HUD/Knob.png'))),
        background: SpriteComponent(
            sprite: Sprite(images.fromCache('HUD/Joystick.png'))),
        margin: const EdgeInsets.only(left: 32, bottom: 32));
    add(joystick);
  }

  // METHOD add all components of joystick //
  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }

  void _loadMap() {
    Future.delayed(const Duration(microseconds: 1), () {
      Level world = Level(levelName: mapNames[currentMapIndex], player: player);

      cam = CameraComponent.withFixedResolution(
          world: world, width: 320, height: 184);
      cam.viewfinder.anchor = Anchor.topLeft;
      cam.priority = 0;
      addAll([cam, world]);
    });
  }

  void loadNextMap() {
    if (currentMapIndex < mapNames.length - 1) {
      resetMap();
      currentMapIndex++;
      player.fishNumber = 0;
    } else {
      currentMapIndex = 0;
      _loadMap();
    }
  }

  void resetMap() {
    removeAll(children);
    onLoad();
  }
}
