import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:jump_game/components/player.dart';
import 'package:jump_game/game_jump.dart';

enum State { running, stomped }

class FlyMonster extends SpriteAnimationGroupComponent
    with HasGameRef<GameJump> {
  static const stepTime = 0.3;
  final double offNeg;
  final double offPos;
  final bool isVertical;
  late final SpriteAnimation _runningAnimation;
  late final SpriteAnimation _stompedAnimation;
  final textureSize = Vector2(16, 16);
  double rangeNeg = 0;
  double rangePos = 0;
  static const tileSize = 8;
  double moveDirection = 1;
  static const moveSpeed = 50;
  late final Player player;
  static const _bounceHeight = 160.0;
  bool gotStomped = false;

  FlyMonster(
      {this.isVertical = false,
      this.offNeg = 0,
      this.offPos = 0,
      position,
      size})
      : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;

    player = game.player;
    _loadAllAnimations();
    add(RectangleHitbox(position: Vector2(2, 2), size: Vector2(12, 12)));

    if (isVertical) {
      rangeNeg = position.y - offNeg * tileSize;
      rangePos = position.y + offPos * tileSize;
    } else {
      rangeNeg = position.x - offNeg * tileSize;
      rangePos = position.x + offPos * tileSize;
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (isVertical) {
      _moveVertically(dt);
    } else {
      _moveHorizontally(dt);
    }

    super.update(dt);
  }

  void _moveVertically(double dt) {
    if (position.y >= rangePos) {
      moveDirection = -1;
    } else if (position.y <= rangeNeg) {
      moveDirection = 1;
    }
    position.y += moveDirection * moveSpeed * dt;
  }

  void _moveHorizontally(double dt) {
    if (position.x >= rangePos) {
      moveDirection = -1;
    } else if (position.x <= rangeNeg) {
      moveDirection = 1;
    }
    position.x += moveDirection * moveSpeed * dt;
  }

  void _loadAllAnimations() {
    _runningAnimation = _spriteAnimation('Running', 2);
    _stompedAnimation = _spriteAnimation('Stomped', 3);

    animations = {
      State.running: _runningAnimation,
      State.stomped: _stompedAnimation
    };

    current = State.running;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Monsters/FlyMonster/$state.png'),
        SpriteAnimationData.sequenced(
            amount: amount, stepTime: stepTime, textureSize: textureSize));
  }

  void collidedWithPlayer() async {
    if (player.velocity.y > 0 && player.y + player.height > position.y) {
      gotStomped = true;
      if (game.playSounds) {
        FlameAudio.play('player/stomp.wav', volume: game.soundVolume);
      }
      current = State.stomped;
      player.velocity.y = -_bounceHeight;
      Future.delayed(const Duration(microseconds: 100000), () {
        gotStomped = false;
        current = State.running;
      });
    } else {
      player.collidedWithMonster();
    }
  }
}
