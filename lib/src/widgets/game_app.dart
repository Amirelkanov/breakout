import 'package:brick_breaker/src/widgets/game_settings_card.dart';
import 'package:brick_breaker/src/widgets/score_card.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../brick_breaker.dart';
import '../config.dart';
import 'overlay_screen.dart';

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  late final BrickBreaker game;

  @override
  void initState() {
    super.initState();
    game = BrickBreaker();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.pressStart2pTextTheme().apply(
          bodyColor: Colors.deepPurple,
          displayColor: Colors.deepPurple.shade400,
        ),
      ),
      home: Scaffold(
        body: Container(
          color: Colors.deepPurple.shade200,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    ScoreCard(score: game.score),
                    Expanded(
                      child: FittedBox(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.deepPurple.shade50, width: 3)),
                          width: gameWidth,
                          height: gameHeight,
                          child: GameWidget(
                            game: game,
                            overlayBuilderMap: {
                              PlayState.welcome.name: (context, game) =>
                                  const OverlayScreen(
                                    title: 'TAP TO PLAY',
                                    subtitle: 'Use swipe to move bat',
                                  ),
                              PlayState.gameOver.name: (context, game) =>
                                  const OverlayScreen(
                                    title: 'G A M E   O V E R',
                                    subtitle: 'Tap to Play Again',
                                  ),
                              PlayState.won.name: (context, game) =>
                                  const OverlayScreen(
                                    title: 'Y O U   W O N ! ! !',
                                    subtitle: 'Tap to Play Again',
                                  ),
                            },
                          ),
                        ),
                      ),
                    ),
                    GameSettingsCard(
                      levelManager: game.level,
                      audioManager: game.audio,
                      isPlaying: game.isPlaying,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
