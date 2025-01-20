import 'dart:async';
import 'dart:math' as math;

import 'package:brick_breaker/src/managers/audio_manager.dart';
import 'package:brick_breaker/src/managers/level_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'components/components.dart';
import 'config.dart';

enum PlayState { welcome, playing, gameOver, won }

class BrickBreaker extends FlameGame with HasCollisionDetection, TapDetector {
  BrickBreaker()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        );

  AudioManager audio = AudioManager();
  LevelManager level = LevelManager();

  final ValueNotifier<int> score = ValueNotifier(0);
  final ValueNotifier<bool> isPlaying = ValueNotifier(false);

  final rand = math.Random();

  double get width => size.x;

  double get height => size.y;

  late PlayState _playState;

  PlayState get playState => _playState;

  set playState(PlayState playState) {
    _playState = playState;
    switch (playState) {
      case PlayState.welcome:
        isPlaying.value = false;
        overlays.add(playState.name);
        audio.playBg('menu.mp3');
      case PlayState.gameOver:
        isPlaying.value = false;
        overlays.add(playState.name);
        audio.play('failed_ball.wav');
      case PlayState.won:
        isPlaying.value = false;
        overlays.add(playState.name);
        audio.playBg('game_win.mp3');
      case PlayState.playing:
        isPlaying.value = true;
        overlays.removeAll([
          PlayState.welcome.name,
          PlayState.gameOver.name,
          PlayState.won.name
        ]);
        audio.playBg('game.mp3');
    }
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    await add(audio);
    await audio.initialize();

    camera.viewfinder.anchor = Anchor.topLeft;
    playState = PlayState.welcome;
    world.add(PlayArea());
  }

  void startGame() {
    if (playState == PlayState.playing) return;

    world.removeAll(world.children.query<Ball>());
    world.removeAll(world.children.query<Bat>());
    world.removeAll(world.children.query<Brick>());

    playState = PlayState.playing;
    score.value = 0;

    world.add(Ball(
        difficultyModifier: difficultyModifier,
        radius: ballRadius,
        position: size / 2,
        velocity: Vector2((rand.nextDouble() - 0.5) * width, height * 0.2)
            .normalized() // This keeps the speed of the ball consistent no matter which direction the ball goes
          ..scale(height / 3)));

    world.add(Bat(
        size: Vector2(batWidth, batHeight),
        cornerRadius: const Radius.circular(ballRadius / 2),
        position: Vector2(width / 2, height * 0.95)));

    // Add bricks
    world.addAll([
      for (var i = 0; i < numOfBricksInARow; i++)
        for (var j = 1; j <= level.numOfBrickRows; j++)
          Brick(
            position: Vector2(
              (i + 0.5) * brickWidth + (i + 1) * brickMargin,
              (j + 2.0) * brickHeight + j * brickMargin,
            ),
            strength: level.getBrickStrength(rand),
          ),
    ]);
  }

  @override
  void onTap() {
    super.onTap();
    startGame();
  }

  @override
  Color backgroundColor() => Colors.deepPurple.shade100;
}
