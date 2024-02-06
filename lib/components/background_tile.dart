import 'dart:async';

import 'package:flame/components.dart';
import 'package:jump_game/game_jump.dart';

class BackgroundTile extends SpriteComponent with HasGameRef<GameJump> {
  final String color;
  BackgroundTile({this.color = "Blue", position}) : super(position: position);

  @override
  FutureOr<void> onLoad() {
    size = Vector2.all(16);
    sprite = Sprite(game.images.fromCache('Background/$color.png'));
    return super.onLoad();
  }
}
