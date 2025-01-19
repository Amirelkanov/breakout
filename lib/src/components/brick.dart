import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../brick_breaker.dart';
import '../config.dart';
import 'ball.dart';
import 'bat.dart';

class Brick extends RectangleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
  int strength;

  Brick(
      {required super.position,
      Color color = Colors.deepPurpleAccent,
      this.strength = 1})
      : super(
          size: Vector2(brickWidth, brickHeight),
          anchor: Anchor.center,
          paint: Paint()
            ..color = color
            ..style = PaintingStyle.fill,
          children: [RectangleHitbox()],
        );

  void _updateColor() {
    if (strength == 3) {
      paint.color = Colors.deepPurpleAccent.shade700;
    } else if (strength == 2) {
      paint.color = Colors.deepPurpleAccent.shade400;
    } else if (strength == 1) {
      paint.color = Colors.deepPurpleAccent.shade200;
    } else {
      paint.color = Colors.transparent;
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (strength > 1) {
      game.audio.play('brick_hit.wav');
      strength--;
      _updateColor();
    } else {
      game.audio.choicePlay([
        'brick_destroy_1.wav',
        'brick_destroy_2.wav',
        'brick_destroy_3.wav'
      ]);

      removeFromParent();
      game.score.value++;

      if (game.world.children.query<Brick>().length == 1) {
        game.playState = PlayState.won;
        game.world.removeAll(game.world.children.query<Ball>());
        game.world.removeAll(game.world.children.query<Bat>());
      }
    }
  }

  @override
  void onLoad() {
    super.onLoad();
    _updateColor();
  }
}
