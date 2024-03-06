import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:jump_game/game_jump.dart';

class Lava extends SpriteAnimationComponent with HasGameRef<GameJump> {
  static const stepTime = 0.5;

  Lava({position, size}) : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;

    priority = -1;
    add(RectangleHitbox(position: Vector2(0, 2), size: Vector2(176, 6)));
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Lava/Lava.png'),
        SpriteAnimationData.sequenced(
            amount: 2, stepTime: stepTime, textureSize: Vector2(176, 8)));
    return super.onLoad();
  }
}
