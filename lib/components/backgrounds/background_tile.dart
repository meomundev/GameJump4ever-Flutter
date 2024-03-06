import 'dart:async';

import 'package:flame/components.dart';
import 'package:jump_game/game_jump.dart';

class BackgroundTile extends SpriteComponent with HasGameRef<GameJump> {
  final String color;

  BackgroundTile({this.color = 'Blue', position}) : super(position: position);

  final double scrollSpeed = 0.4;

  @override
  FutureOr<void> onLoad() {
    priority = -2;
    size = Vector2.all(16.2);
    sprite = Sprite(game.images.fromCache('Background/$color.png'));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.y += scrollSpeed;
    double tizeSize = 16;
    int scrollHeight = (game.size.y / tizeSize).floor();
    if (position.y + tizeSize + 0.1 > scrollHeight * tizeSize) {
      position.y = -tizeSize;
    }
    super.update(dt);
  }
}
