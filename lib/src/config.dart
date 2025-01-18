import 'dart:ui';

const brickColors = [
  // Add this const
  Color(0xff43aa8b),
  Color(0xff43aa8b),
  Color(0xff43aa8b),
  Color(0xff43aa8b),
  Color(0xff43aa8b),
];

const gameWidth = 820.0;
const gameHeight = 1600.0;
const ballRadius = gameWidth * 0.02;
const batWidth = gameWidth * 0.2;
const batHeight = ballRadius * 2;
// How far the bat steps for each left or right arrow key press.
const batStep = gameWidth * 0.05;

const brickMargin = gameWidth * 0.015;
final brickWidth =
    (gameWidth - (brickMargin * (brickColors.length + 1))) / brickColors.length;
const brickHeight = gameHeight * 0.03;
const difficultyModifier = 1.03;
