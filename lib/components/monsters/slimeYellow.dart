import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:jump_game/components/player.dart';
import 'package:jump_game/game_jump.dart';

enum State { idle, running, stomped }

class SlimeYellow extends SpriteAnimationGroupComponent
    with HasGameRef<GameJump>, CollisionCallbacks {
  final double offNeg;
  final double offPos;
  static const stepTime = 0.15;
  final textureSize = Vector2(16, 16);
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _runningAnimation;
  late final SpriteAnimation _stompedAnimation;
  double rangeNeg = 0;
  double rangePos = 0;
  static const tileSize = 8;
  Vector2 velocity = Vector2.zero();
  late final Player player;
  double moveDirection = 1;
  double targetDirection = -1;
  static const moveSpeed = 40;
  bool gotStomped = false;
  static const _bounceHeight = 160.0;

  SlimeYellow({this.offNeg = 0, this.offPos = 0, super.position, super.size});

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
    priority = 2;

    player = game.player;
    _loadAllAnimations();
    _calculateRange();
    add(RectangleHitbox(position: Vector2(0, 2), size: Vector2(16, 14)));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (!gotStomped) {
      _updateState();
      _movement(dt);
    }
    super.update(dt);
  }

  void _loadAllAnimations() {
    _idleAnimation = _spriteAnimation('Idle', 4);
    _runningAnimation = _spriteAnimation('Running', 4);
    _stompedAnimation = _spriteAnimation('Stomped', 1);

    animations = {
      State.idle: _idleAnimation,
      State.running: _runningAnimation,
      State.stomped: _stompedAnimation,
    };

    current = State.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Monsters/SlimeYellow/$state.png'),
        SpriteAnimationData.sequenced(
            amount: amount, stepTime: stepTime, textureSize: textureSize));
  }

  void _calculateRange() {
    rangeNeg = position.x - offNeg * tileSize;
    rangePos = position.x + offPos * tileSize;
  }

  void _movement(dt) {
    double playerOffset = (player.scale.x > 0) ? 0 : -player.width;
    double monsterOffset = (scale.x > 0) ? 0 : -width;

    velocity.x = 0;
    if (playerInRange()) {
      targetDirection =
          (player.x + playerOffset < position.x + monsterOffset) ? -1 : 1;
      velocity.x = targetDirection * moveSpeed;
    }
    moveDirection = lerpDouble(moveDirection, targetDirection, 0.1) ?? 1;
    position.x += velocity.x * dt;
  }

  bool playerInRange() {
    double playerOffset = (player.scale.x > 0) ? 0 : -player.width;
    return player.x + playerOffset >= rangeNeg &&
        player.x + playerOffset <= rangePos &&
        player.y + player.height > position.y &&
        player.y < position.y + height;
  }

  void _updateState() {
    current = (velocity.x != 0) ? State.running : State.idle;

    if ((moveDirection > 0 && scale.x > 0) ||
        (moveDirection < 0 && scale.x < 0)) {
      flipHorizontallyAroundCenter();
    }
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
