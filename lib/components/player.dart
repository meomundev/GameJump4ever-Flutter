import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:jump_game/components/collision_block.dart';
import 'package:jump_game/components/custom_hitbox.dart';
import 'package:jump_game/components/items/door.dart';
import 'package:jump_game/components/monsters/flyMonster.dart';
import 'package:jump_game/components/items/food.dart';
import 'package:jump_game/components/items/lava.dart';
import 'package:jump_game/components/monsters/monster.dart';
import 'package:jump_game/components/items/saw.dart';
import 'package:jump_game/components/monsters/slimeGray.dart';
import 'package:jump_game/components/monsters/slimeGreen.dart';
import 'package:jump_game/components/monsters/slimePurple.dart';
import 'package:jump_game/components/monsters/slimeYellow.dart';
import 'package:jump_game/components/utils.dart';
import 'package:jump_game/game_jump.dart';

// ENUM player state //
enum PlayerState {
  idle,
  running,
  jumping,
  falling,
  death,
  appearing,
  disappearing
}

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<GameJump>, KeyboardHandler, CollisionCallbacks {
  String character;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation deathAnimation;
  late final SpriteAnimation appearingAnimation;
  late final SpriteAnimation disappearingAnimation;
  final double stepTime = 0.15;
  double horizontalMovement = 0;
  double moveSpeed = 70;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;
  List<CollisionBlock> collisionBlocks = [];
  final double _gravity = 7;
  final double _jumpForce = 170;
  final double _terminalVelocity = 300;
  bool isOnGround = false;
  bool hasJumped = false;
  CustomHitbox hitbox =
      CustomHitbox(offsetX: 3, offsetY: 4, width: 10, height: 12);
  Vector2 startingPosition = Vector2.zero();
  bool gotHit = false;
  bool onDoor = false;
  double fixedDeltaTime = 1 / 60;
  double accumulatedTime = 0;
  int fishNumber = 0;

  Player({position, this.character = 'cat_white'}) : super(position: position);

  @override
  FutureOr<void> onLoad() {
    priority = 1;
    _loadAllAnimations();
    // debugMode = true;

    startingPosition = Vector2(position.x, position.y);
    add(RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height)));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    accumulatedTime += dt;
    while (accumulatedTime >= fixedDeltaTime) {
      if (!gotHit && !onDoor) {
        _updatePlayerMovement(fixedDeltaTime);
        _updatePlayerState(fixedDeltaTime);
        _checkHorizontalCollisions();
        _applyGravity(fixedDeltaTime);
        _checkVerticalCollisions();
      }
      accumulatedTime -= fixedDeltaTime;
    }

    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    hasJumped = keysPressed.contains(LogicalKeyboardKey.keyZ);

    return super.onKeyEvent(event, keysPressed);
  }

// METHOD the player touch something //
  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (!onDoor) {
      if (other is Food) other.colliedWithPlayer();
      if (other is Saw) _respawn();
      if (other is Monster) other.collidedWithPlayer();
      if (other is Door) _onDoor();
      if (other is Lava) _respawn();
      if (other is FlyMonster) other.collidedWithPlayer();
      if (other is SlimeGreen) other.collidedWithPlayer();
      if (other is SlimeYellow) other.collidedWithPlayer();
      if (other is SlimeGray) other.collidedWithPlayer();
      if (other is SlimePurple) other.collidedWithPlayer();
    }

    super.onCollisionStart(intersectionPoints, other);
  }

// METHOD animations //
  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 4, 16, 16);
    runningAnimation = _spriteAnimation('Running', 7, 16, 16);
    jumpingAnimation = _spriteAnimation('Jumping', 1, 16, 16);
    fallingAnimation = _spriteAnimation('Falling', 1, 16, 16);
    deathAnimation = _spriteAnimation('Death', 1, 16, 16)..loop = false;
    appearingAnimation = _specialSpriteAnimation('Appear', 5);
    disappearingAnimation = _spriteAnimation('Disappear', 5, 16, 16);

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
      PlayerState.death: deathAnimation,
      PlayerState.appearing: appearingAnimation,
      PlayerState.disappearing: disappearingAnimation,
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

  SpriteAnimation _specialSpriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('main_charater/$character/$state.png'),
        SpriteAnimationData.sequenced(
            amount: amount,
            stepTime: stepTime,
            textureSize: Vector2.all(16),
            loop: false));
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
    if (game.playSounds) {
      FlameAudio.play('player/jump.wav', volume: game.soundVolume);
    }
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false;
  }

  void _respawn() async {
    fishNumber = 0;
    if (game.playSounds) {
      FlameAudio.play('player/gotHit.wav', volume: game.soundVolume);
    }
    const allowMoveDuration = Duration(microseconds: 500);
    gotHit = true;
    current = PlayerState.death;

    await animationTicker?.completed;
    animationTicker?.reset();

    // always direction is right when respawn
    scale.x = 1;
    position = startingPosition;
    current = PlayerState.appearing;

    await animationTicker?.completed;
    animationTicker?.reset();
    velocity = Vector2.zero();
    _updatePlayerState(650);
    Future.delayed(allowMoveDuration, () => gotHit = false);
    game.resetMap();
  }

  void collidedWithMonster() {
    _respawn();
  }

  void _onDoor() {
    if (fishNumber >= 3) {
      if (game.playSounds) {
        FlameAudio.play('player/onDoor.wav', volume: game.soundVolume);
      }
      onDoor = true;
      current = PlayerState.disappearing;

      const onDoorDuration = Duration(milliseconds: 700);
      Future.delayed(onDoorDuration, () {
        onDoor = false;
        position = Vector2.all(-1000);
      });

      const waitToChangeMap = Duration(seconds: 1);
      Future.delayed(waitToChangeMap, () {
        game.loadNextMap();
      });
    }
  }
}
