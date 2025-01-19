import 'package:brick_breaker/src/managers/audio_manager.dart';
import 'package:flutter/material.dart';

import '../managers/level_manager.dart';

class GameSettingsCard extends StatelessWidget {
  const GameSettingsCard({
    super.key,
    required this.levelManager,
    required this.audioManager,
  });

  final LevelManager levelManager;
  final AudioManager audioManager;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 18, 12, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ValueListenableBuilder<Difficulty>(
              valueListenable: levelManager.difficulty,
              builder: (BuildContext context, difficulty, Widget? child) {
                return DropdownButton<Difficulty>(
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
              }),
          ValueListenableBuilder<bool>(
            valueListenable: audioManager.audioOn,
            builder: (BuildContext context, audioOn, Widget? child) {
              return IconButton(
                  icon: Icon(
                    audioOn ? Icons.volume_up : Icons.volume_off,
                    size: 30,
                    color: Colors.deepPurple.shade700,
                  ),
                  onPressed: () {
                    audioManager.toggleSound();
                  });
            },
          )
        ],
      ),
    );
  }
}
