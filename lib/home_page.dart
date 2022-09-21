import 'package:flutter/material.dart';
import 'package:snake_game/widget/blank_pixel.dart';
import 'package:snake_game/widget/food_pixel.dart';
import 'package:snake_game/widget/snake_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // grid dimensions

  int rowSize = 10;
  int totalNumberOfSquares = 100;

  // snak position
  List<int> snakePostion = [0, 1, 2];
  // food postion
  int foodPosition = 50;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            // high scores

            Expanded(
              child: Container(),
            ),
            // game grid
            Expanded(
              flex: 3,
              child: Container(
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
            // play button
            Expanded(
              child: Container(
                child: Center(
                  child: MaterialButton(
                    color: Colors.pink,
                    onPressed: () {},
                    child: const Text("Play"),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
