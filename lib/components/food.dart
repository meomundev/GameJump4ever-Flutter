import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:jump_game/components/custom_hitbox.dart';
import 'package:jump_game/game_jump.dart';

class Food extends SpriteAnimationComponent
    with HasGameRef<GameJump>, CollisionCallbacks {
  final String food;
  final double stepTime = 0.1;
  final hitbox = CustomHitbox(offsetX: 2, offsetY: 2, width: 12, height: 12);
  bool _collected = false;

  Food({this.food = 'Fish', position, size})
      : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
    // push the layer food back //
    priority = -1;

    // add rectangle for the food when player has collision with the food will show effect //
    add(RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive));

    // animation of food //
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Foods/$food.png'),
        SpriteAnimationData.sequenced(
            amount: 6, stepTime: stepTime, textureSize: Vector2.all(16)));

    return super.onLoad();
  }

  // METHOD make effect when player touch the food //
  void colliedWithPlayer() {
    if (!_collected) {
      // animation collected when the player touch the food //
      animation = SpriteAnimation.fromFrameData(
          game.images.fromCache('Items/Collected/Collected.png'),
          SpriteAnimationData.sequenced(
              amount: 6,
              stepTime: stepTime,
              textureSize: Vector2.all(16),
              loop: false));
      _collected = true;
    }
    // delete animation and food //
    Future.delayed(const Duration(milliseconds: 600), () => removeFromParent());
  }
}
