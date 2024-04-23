import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:jump_game/game_jump.dart';

class JumpButton extends SpriteComponent
    with HasGameRef<GameJump>, TapCallbacks {
  final margin = 40;
  final buttonSize = 80;

  JumpButton();

  @override
  FutureOr<void> onLoad() {
    priority = 3;

    sprite = Sprite(game.images.fromCache('HUD/ButtonJump.png'));
    position = Vector2(gameRef.size.x - margin - buttonSize,
        gameRef.size.y - margin - buttonSize);
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.player.hasJumped = true;

    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    game.player.hasJumped = false;
    super.onTapUp(event);
  }
}
