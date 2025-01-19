import 'package:brick_breaker/src/brick_breaker.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

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

  bool audioOn = true;

  void play(String audioFile) {
    if (audioOn) FlameAudio.play(audioFile);
  }

  void playBg(String audioFile) {
    if (audioOn) FlameAudio.bgm.play(audioFile);
  }

  //TODO
  void toggleSound() {
    audioOn = !audioOn;

    /*if (audioOn) {
      playBg();
    } else {
      FlameAudio.bgm.stop();
    }*/
  }
}
