import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:jump_game/components/player.dart';
import 'package:jump_game/game_jump.dart';

class Door extends SpriteAnimationComponent
    with HasGameRef<GameJump>, CollisionCallbacks {
  Door({position, size}) : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;

    add(RectangleHitbox(
        position: Vector2(6, 6),
        size: Vector2(4, 10),
        collisionType: CollisionType.passive));

    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Door/Door.png'),
        SpriteAnimationData.sequenced(
            amount: 1, stepTime: 1, textureSize: Vector2.all(16)));
    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) _onDoor();
    super.onCollisionStart(intersectionPoints, other);
  }

  void _onDoor() {
    Player player = game.player;
    if (player.fishNumber == 3) {
      animation = SpriteAnimation.fromFrameData(
          game.images.fromCache('Items/Door/NextMap.png'),
          SpriteAnimationData.sequenced(
              amount: 7,
              stepTime: 0.15,
              textureSize: Vector2.all(16),
              loop: false));
    }
  }
}
