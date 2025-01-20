import 'package:brick_breaker/src/managers/audio_manager.dart';
import 'package:flutter/material.dart';
import 'package:pixelarticons/pixel.dart';

import '../managers/level_manager.dart';

class GameSettingsCard extends StatelessWidget {
  const GameSettingsCard({
    super.key,
    required this.levelManager,
    required this.audioManager,
    required this.isPlaying,
  });

  final LevelManager levelManager;
  final AudioManager audioManager;
  final ValueNotifier<bool> isPlaying;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(12, 18, 12, 6),
        child: ValueListenableBuilder<bool>(
            valueListenable: isPlaying,
            builder: (BuildContext context, isPlaying, Widget? child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  LevelSelector(
                      levelManager: levelManager, isPlaying: isPlaying),
                  AudioBtn(audioManager: audioManager)
                ],
              );
            }));
  }
}

class LevelSelector extends StatelessWidget {
  const LevelSelector(
      {super.key, required this.levelManager, required this.isPlaying});

  final LevelManager levelManager;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Difficulty>(
        valueListenable: levelManager.difficulty,
        builder: (BuildContext context, difficulty, Widget? child) {
          return isPlaying
              ? Text(difficulty.name.toUpperCase())
              : DropdownButton<Difficulty>(
                  value: difficulty,
                  onChanged: (Difficulty? newDifficulty) {
                    if (newDifficulty != null) {
                      levelManager.changeLevel(newDifficulty);
                    }
                  },
                  items: Difficulty.values.map((Difficulty difficulty) {
                    return DropdownMenuItem<Difficulty>(
                      value: difficulty,
                      child: Text(difficulty.name.toUpperCase()),
                    );
                  }).toList(),
                );
        });
  }
}

class AudioBtn extends StatelessWidget {
  const AudioBtn({
    super.key,
    required this.audioManager,
  });

  final AudioManager audioManager;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: audioManager.audioOn,
      builder: (BuildContext context, audioOn, Widget? child) {
        return IconButton(
            icon: Icon(
              audioOn ? Pixel.volume3 : Pixel.volumex,
              size: 30,
              color: Colors.deepPurple.shade700,
            ),
            onPressed: () {
              audioManager.toggleSound();
            });
      },
    );
  }
}
