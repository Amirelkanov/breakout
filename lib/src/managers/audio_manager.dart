import 'package:brick_breaker/src/brick_breaker.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';

class AudioManager extends Component with HasGameRef<BrickBreaker> {
  AudioManager();

  initialize() async {
    await FlameAudio.audioCache.loadAll([
      'brick_hit_1.wav',
      'brick_hit_2.wav',
      'brick_hit_3.wav',
      'failed_ball.wav',
      'game.mp3',
      'game_win.mp3',
      'menu.mp3',
    ]);

    FlameAudio.bgm.initialize();
  }

  ValueNotifier<bool> audioOn = ValueNotifier(true);

  // Randomly chooses what sound to play
  void choicePlay(List<String> audioFiles) {
    play(audioFiles[game.rand.nextInt(audioFiles.length)]);
  }

  void play(String audioFile) {
    if (audioOn.value) FlameAudio.play(audioFile, volume: 0.4);
  }

  void playBg(String audioFile) {
    if (audioOn.value) FlameAudio.bgm.play(audioFile, volume: 0.4);
  }

  void toggleSound() {
    audioOn.value = !audioOn.value;

    if (audioOn.value) {
      if (game.playState == PlayState.playing ||
          game.playState == PlayState.gameOver) {
        playBg('game.mp3');
      } else if (game.playState == PlayState.welcome) {
        playBg('menu.mp3');
      }
    } else {
      FlameAudio.bgm.stop();
    }
  }
}
