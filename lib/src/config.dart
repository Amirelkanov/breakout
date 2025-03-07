const gameWidth = 820.0;
const gameHeight = 1600.0;
const ballRadius = gameWidth * 0.02;
const batWidth = gameWidth * 0.25;
const batHeight = ballRadius * 2;

const brickMargin = gameWidth * 0.015;

const numOfBricksInARow = 5;
final brickWidth =
    (gameWidth - (brickMargin * (numOfBricksInARow + 1))) / numOfBricksInARow;
const brickHeight = gameHeight * 0.03;
const difficultyModifier = 1.03;
