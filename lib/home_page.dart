import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snake_game/widget/blank_pixel.dart';
import 'package:snake_game/widget/food_pixel.dart';
import 'package:snake_game/widget/snake_pixel.dart';

enum snakeDirection { DOWN, UP, LEFT, RIGHT }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // grid dimensions

  int rowSize = 10;
  int totalNumberOfSquares = 100;
  bool gameHasStarted = false;

  // snak position
  List<int> snakePostion = [0, 1, 2];
  // food postion
  int foodPosition = 55;

  // current score
  int currentScore = 0;

  // snake direction is initally to the right

  var currentDirection = snakeDirection.RIGHT;

  // start the game when start button is clicked

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 400), (timer) {
      setState(() {
        // move the snake
        moveSnake();

        // if game is over
        if (isGameOver()) {
          // cancel the timer
          timer.cancel();
          // show message to the user
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("game is over"),
                  content: Column(
                    children: [
                      Text("current score: ${currentScore.toString()}"),
                      const TextField(
                        decoration: InputDecoration(hintText: "Enter name?"),
                      ),
                    ],
                  ),
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        submitScore();
                        Navigator.pop(context);
                        restartGame();
                      },
                      color: Colors.pink,
                      child: const Text("Sumbit"),
                    )
                  ],
                );
              });
        }
      });
    });
  }

  // submit the score to the firebase database
  void submitScore() {
    //
  }

  void eatFood() {
    currentScore++;
    // making sure the food is not where the snake is
    while (snakePostion.contains(foodPosition)) {
      foodPosition = Random().nextInt(totalNumberOfSquares);
    }
  }

  void moveSnake() {
    switch (currentDirection) {
      case snakeDirection.RIGHT:
        {
          // ADD HEAD TO THE SANKE

          // if the snake is at the right wall , we need to adjust

          if (snakePostion.last % rowSize == 9) {
            snakePostion.add(snakePostion.last + 1 - rowSize);
          } else {
            snakePostion.add(snakePostion.last + 1);
          }
        }

        break;
      case snakeDirection.LEFT:
        {
          // ADD HEAD TO THE SANKE

          // if the snake head in the left wall , we need to adjust

          if (snakePostion.last % rowSize == 0) {
            snakePostion.add(snakePostion.last - 1 + rowSize);
          } else {
            snakePostion.add(snakePostion.last - 1);
          }
        }

        break;

      case snakeDirection.UP:
        {
          // ADD HEAD TO THE SANKE

          // if the snake head in the top wall , we need to adjust

          if (snakePostion.last < rowSize) {
            snakePostion
                .add(snakePostion.last - rowSize + totalNumberOfSquares);
          } else {
            snakePostion.add(snakePostion.last - rowSize);
          }
        }

        break;

      case snakeDirection.DOWN:
        {
          // ADD HEAD TO THE SANKE

          // if the snake head in the bottom wall , we need to adjust

          if (snakePostion.last + rowSize > totalNumberOfSquares) {
            snakePostion
                .add(snakePostion.last + rowSize - totalNumberOfSquares);
          } else {
            snakePostion.add(snakePostion.last + rowSize);
          }
        }

        break;

      default:
    }

    if (snakePostion.last == foodPosition) {
      // snake is eating the food
      eatFood();
    } else {
      // REMOVE THE TILE FROM THE SNAKE

      snakePostion.removeAt(0);
    }
  }

  // is game over

  bool isGameOver() {
    // the game is over when snake is run into itself
    // this accurs when there is duplicate position in snake position list

    // the list is the body of the snake without the last snake positon

    List<int> snakeBody = snakePostion.sublist(0, snakePostion.length - 1);

    // check if the last snake positon index [head] is included in snake body if true the sanke hit itself and game is over

    if (snakeBody.contains(snakePostion.last)) {
      return true;
    } else {
      return false;
    }
  }

  // game restart

  restartGame() {
    setState(() {
      snakePostion = [0, 1, 2];
    });
    foodPosition = 55;
    currentDirection = snakeDirection.RIGHT;
    gameHasStarted = false;
    currentScore = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            // high scores

            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Current Score"),
                      // user current score
                      Text(
                        currentScore.toString(),
                        style: const TextStyle(
                          fontSize: 36,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  // high scores top 5 or top 10
                  const Text(
                    "high scores",
                    style: TextStyle(fontSize: 36),
                  )
                ],
              ),
            ),
            // game grid
            Expanded(
              flex: 3,
              child: SizedBox(
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (details.delta.dy > 0 &&
                        currentDirection != snakeDirection.UP) {
                      currentDirection = snakeDirection.DOWN;
                    } else if (details.delta.dy < 0 &&
                        currentDirection != snakeDirection.DOWN) {
                      currentDirection = snakeDirection.UP;
                    }
                  },
                  onHorizontalDragUpdate: (details) {
                    if (details.delta.dx > 0 &&
                        currentDirection != snakeDirection.LEFT) {
                      currentDirection = snakeDirection.RIGHT;
                    } else if (details.delta.dx < 0 &&
                        currentDirection != snakeDirection.RIGHT) {
                      currentDirection = snakeDirection.LEFT;
                    }
                  },
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: rowSize,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: totalNumberOfSquares,
                    itemBuilder: (BuildContext context, int index) {
                      if (snakePostion.contains(index)) {
                        return const SnakePixel();
                      } else if (foodPosition == index) {
                        return const FoodPixel();
                      }
                      return const BlankPixel();
                    },
                  ),
                ),
              ),
            ),
            // play button
            Expanded(
              child: SizedBox(
                child: Center(
                  child: MaterialButton(
                    color: gameHasStarted ? Colors.grey : Colors.pink,
                    onPressed: gameHasStarted ? () {} : startGame,
                    child: const Text("Play"),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
