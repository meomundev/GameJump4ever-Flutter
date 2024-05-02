import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jump_game/components/buttons/jump_button.dart';
import 'package:jump_game/components/buttons/menu_button.dart';
import 'package:jump_game/components/level.dart';
import 'package:jump_game/components/player.dart';
import 'package:jump_game/screens/list_map.dart';
import 'package:jump_game/screens/setting.dart';

class GameJump extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  late CameraComponent cam;
  Player player = Player(character: 'cat_white');
  late JoystickComponent joystick;
  late ButtonComponent buttonMoveLeft;
  late ButtonComponent buttonMoveRight;
  bool showControls = true;
  List<String> mapNames = [
    'Level-01',
    'Level-02',
    'Level-03',
    'Level-04',
  ];
  int currentMapIndex = 0;
  bool playSounds = true;
  double soundVolume = 1.0;
  bool needResetMap = false;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  ListMapScreen listMapScreen = const ListMapScreen();
  bool isPressedLeft = false;
  bool isPressedRight = false;
  bool useJoyStick = false;
  bool hasWon = false; // Biến để theo dõi trạng thái chiến thắng

  @override
  Color backgroundColor() => const Color(0xFF221f30);
  // Color backgroundColor() => Color.fromARGB(255, 89, 97, 160);

  // Load Game //
  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    if (showControls && useJoyStick == false) {
      addButtonLeftMove();
      addButtonRightMove();
      add(JumpButton());
    } else if (showControls && useJoyStick == true) {
      addJoystick();
      add(JumpButton());
    }
    add(MenuButton());
    _loadMap();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showControls && useJoyStick == false) {
      updateMove();
    } else if (showControls && useJoyStick == true) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
        priority: 3,
        knob: SpriteComponent(sprite: Sprite(images.fromCache('HUD/Knob.png'))),
        background: SpriteComponent(
            sprite: Sprite(images.fromCache('HUD/Joystick.png'))),
        margin: const EdgeInsets.only(left: 40, bottom: 40));
    add(joystick);
  }

  void addButtonLeftMove() {
    final spriteComponent = SpriteComponent(
      sprite: Sprite(images.fromCache('HUD/ButtonMoveLeft.png')),
    );

    buttonMoveLeft = ButtonComponent(
      priority: 3,
      position: Vector2(40, size.y - 120),
      button: spriteComponent,
      onPressed: () => isPressedLeft = true,
      onReleased: () => {isPressedLeft = false, player.horizontalMovement = 0},
      // onCancelled: () => {isPressedLeft = false, player.horizontalMovement = 0},
    );
    if (isPressedLeft == true) {
      if (kDebugMode) {
        print('left');
      }
    }
    add(buttonMoveLeft);
  }

  void addButtonRightMove() {
    final spriteComponent = SpriteComponent(
      sprite: Sprite(images.fromCache('HUD/ButtonMoveRight.png')),
    );

    buttonMoveRight = ButtonComponent(
      priority: 3,
      position: Vector2(160, size.y - 120),
      button: spriteComponent,
      onPressed: () => isPressedRight = true,
      onReleased: () => {isPressedRight = false, player.horizontalMovement = 0},
      // onCancelled: () =>
      //     {isPressedRight = false, player.horizontalMovement = 0},
    );
    if (isPressedRight == true) {
      if (kDebugMode) {
        print('right');
      }
    }
    add(buttonMoveRight);
  }

  void updateMove() {
    player.horizontalMovement = isPressedLeft ? -1 : (isPressedRight ? 1 : 0);
  }

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
      if (mapNames[currentMapIndex] == 'Level-04') {
        _win();
      } else {
        _loadMap();
      }
    }
  }

  void resetMap() {
    isPressedRight = false;
    isPressedLeft = false;
    removeAll(children);
    onLoad();
  }

  void _win() {
    hasWon = true;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (hasWon) {
      final paint = Paint()..color = Colors.black.withOpacity(0.5);
      canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);

      const textStyle = TextStyle(
        color: Colors.white,
        fontSize: 24,
      );
      const textSpan = TextSpan(
        text: 'Congratulations! You win!',
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      textPainter.layout(minWidth: size.x, maxWidth: size.x);
      textPainter.paint(
        canvas,
        Offset(0, size.y / 2 - textPainter.height / 2),
      );
    }
  }
}
