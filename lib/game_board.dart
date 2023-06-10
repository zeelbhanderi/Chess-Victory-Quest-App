import 'package:chess_victory_quest/components/piece.dart';
import 'package:chess_victory_quest/components/square.dart';
import 'package:flutter/material.dart';
import 'helper/methods.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {

  ChessPiece myPawn = ChessPiece(type: ChessPieceType.pawn,
      isWhite: true,
      imagePath: './assets/images/pawn.png');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        itemCount: 8 * 8,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Square(isWhite: isWhite(index), piece: myPawn,);
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
      ),
    );
  }
}
