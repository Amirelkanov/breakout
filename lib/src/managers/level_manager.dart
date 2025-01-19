import 'package:brick_breaker/src/brick_breaker.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

enum Difficulty { easy, medium, hard }

class LevelManager extends Component with HasGameRef<BrickBreaker> {
  LevelManager();

  ValueNotifier<Difficulty> difficulty = ValueNotifier(Difficulty.easy);

  int get numOfBrickRows {
    switch (difficulty.value) {
      case Difficulty.easy:
        return 3;
      case Difficulty.medium:
        return 4;
      case Difficulty.hard:
        return 5;
    }
  }

  void changeLevel(Difficulty newDifficulty) {
      difficulty.value = newDifficulty;

  }
}
