import 'dart:async';
import 'dart:math' as math;

import 'package:brick_breaker/src/managers/audio_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';

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

  final ValueNotifier<int> score = ValueNotifier(0);
  final rand = math.Random();

  double get width => size.x;

  double get height => size.y;

  late PlayState _playState;

  PlayState get playState => _playState;

  set playState(PlayState playState) {
    _playState = playState;
    switch (playState) {
      case PlayState.welcome:
        overlays.add(playState.name);
        audio.playBg('menu.mp3');
      case PlayState.gameOver:
        overlays.add(playState.name);
        audio.play('failed_ball.wav');
      case PlayState.won:
        overlays.add(playState.name);
        audio.playBg('game_win.mp3');
      case PlayState.playing:
        overlays.remove(PlayState.welcome.name);
        overlays.remove(PlayState.gameOver.name);
        overlays.remove(PlayState.won.name);
        audio.playBg('game.mp3');
    }
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    await add(audio);
    await audio.initialize();

    camera.viewfinder.anchor = Anchor.topLeft;

    world.add(PlayArea());
    playState = PlayState.welcome;
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
          // ball's velocity is then scaled up to be a 1/4 of the height of the game
          ..scale(height / 3)));

    world.add(Bat(
        size: Vector2(batWidth, batHeight),
        cornerRadius: const Radius.circular(ballRadius / 2),
        position: Vector2(width / 2, height * 0.95)));

    // Add bricks
    world.addAll([
      for (var i = 0; i < brickColors.length; i++)
        for (var j = 1; j <= 5; j++)
          Brick(
            position: Vector2(
              (i + 0.5) * brickWidth + (i + 1) * brickMargin,
              (j + 2.0) * brickHeight + j * brickMargin,
            ),
            color: brickColors[i],
          ),
    ]);
  }

  @override
  void onTap() {
    super.onTap();
    startGame();
  }

  @override
  Color backgroundColor() => const Color(0xfff2e8cf);
}
