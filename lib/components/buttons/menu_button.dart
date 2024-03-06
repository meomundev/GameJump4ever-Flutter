import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:jump_game/game_jump.dart';
import 'package:jump_game/screens/navigator_helper.dart';

class MenuButton extends SpriteComponent
    with HasGameRef<GameJump>, TapCallbacks {
  final margin = 32;
  final buttonSize = 64;
  bool openMenu = false;

  MenuButton();

  @override
  FutureOr<void> onLoad() {
    priority = 3;
    sprite = Sprite(game.images.fromCache('HUD/Menu.png'));
    position =
        Vector2(gameRef.size.x - margin - buttonSize, (0 + margin).toDouble());

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);

    NavigatorHelper.menuButton();
  }
}
