import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:jump_game/components/background_tile.dart';
import 'package:jump_game/components/collision_block.dart';
import 'package:jump_game/components/food.dart';
import 'package:jump_game/components/player.dart';
import 'package:jump_game/game_jump.dart';

class Level extends World with HasGameRef<GameJump> {
  late TiledComponent level;
  final String levelName;
  final Player player;
  List<CollisionBlock> collisionBlocks = [];

  Level({required this.levelName, required this.player});

  @override
  FutureOr<void> onLoad() async {
    // load level map
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(8));

    add(level);

    // _scrollingBackground();
    _spawningObject();
    _addCollisions();

    return super.onLoad();
  }

  void _scrollingBackground() {
    final backgroundLayer = level.tileMap.getLayer('Background');
    const tileSize = 16;
    final numTileY = (game.size.y / tileSize).floor();
    final numTileX = (game.size.x / tileSize).floor();

    if (backgroundLayer != null) {
      final backgroundColor =
          backgroundLayer.properties.getValue('BackgroundColor');
      for (double y = 0; y < numTileY; y++) {
        for (double x = 0; x < numTileX; x++) {
          final backgroundTile = BackgroundTile(
              color: backgroundColor ?? "Blue",
              position: Vector2(x * tileSize, y * tileSize - tileSize));

          add(backgroundTile);
        }
      }
    }
  }

  void _spawningObject() {
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoints');

    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y + 2);
            add(player);
            break;
          case 'Food':
            final food = Food(
                food: spawnPoint.name,
                position: Vector2(spawnPoint.x, spawnPoint.y),
                size: Vector2(spawnPoint.width, spawnPoint.height));
            add(food);
          default:
        }
      }
    }
  }

  void _addCollisions() {
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
                position: Vector2(collision.x, collision.y),
                size: Vector2(collision.width, collision.height),
                isPlatform: true);
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
                position: Vector2(collision.x, collision.y),
                size: Vector2(collision.width, collision.height));
            collisionBlocks.add(block);
            add(block);
            break;
        }
      }
    }
    player.collisionBlocks = collisionBlocks;
  }
}
