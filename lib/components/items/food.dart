import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:jump_game/components/custom_hitbox.dart';
import 'package:jump_game/components/player.dart';
import 'package:jump_game/game_jump.dart';

class Food extends SpriteAnimationComponent
    with HasGameRef<GameJump>, CollisionCallbacks {
  final String food;
  final double stepTime = 0.1;
  final hitbox = CustomHitbox(offsetX: 6, offsetY: 6, width: 4, height: 4);
  bool collected = false;

  Food({this.food = 'Fish', position, size})
      : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
// push the layer food back //
    priority = 0;

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
  void colliedWithPlayer() async {
    if (!collected) {
      Player player = game.player;
      player.fishNumber += 1;
      collected = true;
      if (game.playSounds) {
        FlameAudio.play('player/getFood.wav', volume: game.soundVolume);
      }
      animation = SpriteAnimation.fromFrameData(
          game.images.fromCache('Items/Effect/Collected/Collected.png'),
          SpriteAnimationData.sequenced(
              amount: 6,
              stepTime: stepTime,
              textureSize: Vector2.all(16),
              loop: false));
      await animationTicker?.completed;
      removeFromParent();
    }
  }
}
