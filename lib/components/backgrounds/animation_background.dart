import 'package:flame/components.dart';
import 'package:jump_game/game_jump.dart';

enum allObjects {
  glass1,
  glass2,
  glass3,
  torch,
  waterFallLeft,
  waterFallRight,
  waterFall1,
  waterFall2,
  waterLine,
  waterLineSmall,
  waterSurface,
}

class AnimationBackground extends SpriteAnimationGroupComponent
    with HasGameRef<GameJump> {}
