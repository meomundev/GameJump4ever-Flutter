import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:jump_game/components/collision_block.dart';
import 'package:jump_game/components/custom_hitbox.dart';
import 'package:jump_game/components/food.dart';
import 'package:jump_game/components/utils.dart';
import 'package:jump_game/game_jump.dart';

// ENUM player state //
enum PlayerState { idle, running, jumping, falling }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<GameJump>, KeyboardHandler, CollisionCallbacks {
  String character;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  final double stepTime = 0.15;
  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;
  List<CollisionBlock> collisionBlocks = [];
  final double _gravity = 7;
  final double _jumpForce = 300;
  final double _terminalVelocity = 300;
  bool isOnGround = false;
  bool hasJumped = false;
  CustomHitbox hitbox =
      CustomHitbox(offsetX: 3, offsetY: 2, width: 10, height: 14);

  Player({position, this.character = 'cat_white'}) : super(position: position);

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    // debugMode = true;

// add rectangle for check whatever the player touch on the game //
    add(RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height)));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    _updatePlayerState(dt);
    _checkHorizontalCollisions();
    _applyGravity(dt);
    _checkVerticalCollisions();
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;

    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyN);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyM);
    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    hasJumped = keysPressed.contains(LogicalKeyboardKey.keyZ);

    return super.onKeyEvent(event, keysPressed);
  }

// METHOD the player touch something //
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Food) {
      other.colliedWithPlayer();
    }
    super.onCollision(intersectionPoints, other);
  }

// METHOD animations //
  void _loadAllAnimations() {
    // idleAnimation = _spriteAnimation('Idle', 4, 12, 12);
    // runningAnimation = _spriteAnimation('Running', 7, 15, 11);
    // jumpingAnimation = _spriteAnimation('Jumping', 1, 13, 11);
    // fallingAnimation = _spriteAnimation('Falling', 1, 13, 11);

    idleAnimation = _spriteAnimation('Idle2', 4, 16, 16);
    runningAnimation = _spriteAnimation('Running2', 6, 16, 16);
    jumpingAnimation = _spriteAnimation('Jumping2', 1, 16, 16);
    fallingAnimation = _spriteAnimation('Falling2', 1, 16, 16);

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation
    };

    current = PlayerState.idle;
  }

// get sprite animation from cache //
  SpriteAnimation _spriteAnimation(
      String state, int amount, double vec2widht, double vec2height) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('main_charater/$character/$state.png'),
        SpriteAnimationData.sequenced(
            amount: amount,
            stepTime: stepTime,
            textureSize: Vector2(vec2widht, vec2height)));
  }

// METHOD for the player move //
  void _updatePlayerMovement(double dt) {
    if (hasJumped && isOnGround) _playerJump(dt);
    if (velocity.y > _gravity) isOnGround = false;
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

// METHOD handle all player state, use ENUM //
  void _updatePlayerState(double dt) {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }
// check if velocity horizontal != 0, add the animation running
    if (velocity.x > 0 || velocity.x < 0) {
      playerState = PlayerState.running;
    }
// check when velocity vertical > 0, add animation falling
    if (velocity.y > 0) {
      playerState = PlayerState.falling;
    }
// check when velocity vertical < 0, add animation jumping
    if (velocity.y < 0) {
      playerState = PlayerState.jumping;
    }
    current = playerState;
  }

// METHOD check player horizontal collision //
  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - hitbox.offsetX - hitbox.width;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.offsetX + hitbox.width;
            break;
          }
        }
      }
    }
  }

// METHOD add the gravity on the game //
  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

// METHOD check player vertical collision //
  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
          }
        }
      }
    }
  }

// METHOD player jump //
  void _playerJump(double dt) {
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false;
  }
}
