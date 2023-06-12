import 'package:chess_victory_quest/components/piece.dart';
import 'package:chess_victory_quest/components/square.dart';
import 'package:chess_victory_quest/value/colors.dart';
import 'package:flutter/material.dart';
import 'helper/methods.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  //A 2-dimensional list representing the chessboard,
  //with each position possibly containing a chess piece
  late List<List<ChessPiece?>> board;

  //The currently selected piece on the chess board,
  //if no piece is selected, this is null.
  ChessPiece? selectedPiece;

  //the Row index of the selected piece
  //Default value -1 indicated no piece is currently selected
  int selectedRow = -1;

  //the Col index of the selected piece
  //Default value -1 indicated no piece is currently selected
  int selectedCol = -1;

  //A list of valid moves for currently selected piece
  //each move is represented as a list with 2 elements: row and col
  List<List<int>> validMoves = [];

  void pieceSelected(int row, int col) {
    setState(() {
      //selected a piece if there is a piece in that position
      if (board[row][col] != null) {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }

      //if a piece is selected, calculate it's vaild moves
      validMoves =
          calculateRawValidMoves(selectedRow, selectedCol, selectedPiece);
    });
  }

  List<List<int>> calculateRawValidMoves(int row, int col, ChessPiece? piece) {
    List<List<int>> candidateMoves = [];

    //different directions based on their color
    int direction = piece!.isWhite ? -1 : 1;

    switch (piece.type) {
      case ChessPieceType.pawn:
        //pawns can moves forward if the square is not occupied
        if (isInBoard(row + direction, col) &&
            board[row + direction][col] == null) {
          candidateMoves.add([row + direction, col]);
        }
        //paws can moves 2 squares forward if they are at their intial positions
        if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if (isInBoard(row + 2 * direction, col) &&
              board[row + 2 * direction][col] == null &&
              board[row + direction][col] == null) {
            candidateMoves.add([row + 2 * direction, col]);
          }
        }
        //paws can kill diagonally
        if (isInBoard(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]!.isWhite) {
          candidateMoves.add([row + direction, col - 1]);
        }
        if (isInBoard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.isWhite) {
          candidateMoves.add([row + direction, col + 1]);
        }

        break;
      case ChessPieceType.rook:
        //Horizontal and vertical directions
        var directions = [
          [-1, 0], //up
          [1, 0], //down
          [0, -1], //left
          [0, 1] //right
        ];

        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = row + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }

        break;
      case ChessPieceType.knight:
        break;
      case ChessPieceType.bishop:
        break;
      case ChessPieceType.queen:
        break;
      case ChessPieceType.king:
        break;

      default:
    }

    return candidateMoves;
  }

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  //TODO: INITIALIZE BOARD
  void _initializeBoard() {
    // initialize the board with nulls, meaning non pieces in those positions
    List<List<ChessPiece?>> newBoard =
        List.generate(8, (index) => List.generate(8, (index) => null));

    //Place pawns
    for (int i = 0; i < 8; i++) {
      newBoard[1][i] = ChessPiece(
          type: ChessPieceType.pawn,
          isWhite: false,
          imagePath: './assets/images/pawn.png');
      newBoard[6][i] = ChessPiece(
          type: ChessPieceType.pawn,
          isWhite: true,
          imagePath: './assets/images/pawn.png');
    }

    //Place rooks
    newBoard[0][0] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: false,
        imagePath: './assets/images/rook.png');
    newBoard[0][7] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: false,
        imagePath: './assets/images/rook.png');
    newBoard[7][0] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: true,
        imagePath: './assets/images/rook.png');
    newBoard[7][7] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: true,
        imagePath: './assets/images/rook.png');

    //Place knights
    newBoard[0][1] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: false,
        imagePath: './assets/images/knight.png');
    newBoard[0][6] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: false,
        imagePath: './assets/images/knight.png');
    newBoard[7][1] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: true,
        imagePath: './assets/images/knight.png');
    newBoard[7][6] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: true,
        imagePath: './assets/images/knight.png');

    //Place bishops
    newBoard[0][2] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: false,
        imagePath: './assets/images/bishop.png');
    newBoard[0][5] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: false,
        imagePath: './assets/images/bishop.png');
    newBoard[7][2] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: true,
        imagePath: './assets/images/bishop.png');
    newBoard[7][5] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: true,
        imagePath: './assets/images/bishop.png');

    //Place queens
    newBoard[0][3] = ChessPiece(
        type: ChessPieceType.queen,
        isWhite: false,
        imagePath: './assets/images/queen.png');
    newBoard[7][4] = ChessPiece(
        type: ChessPieceType.queen,
        isWhite: true,
        imagePath: './assets/images/queen.png');

    //Place kings
    newBoard[0][4] = ChessPiece(
        type: ChessPieceType.queen,
        isWhite: false,
        imagePath: './assets/images/king.png');
    newBoard[7][3] = ChessPiece(
        type: ChessPieceType.queen,
        isWhite: true,
        imagePath: './assets/images/king.png');

    board = newBoard;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: GridView.builder(
        itemCount: 8 * 8,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          //get the row and col position of this square
          int row = index ~/ 8;
          int col = index % 8;

          //check if this square is selected
          bool isSelected = selectedRow == row && selectedCol == col;

          //check if this square is a valid move
          bool isValidMove = false;
          for (var position in validMoves) {
            //compare row and col
            if (position[0] == row && position[1] == col) {
              isValidMove = true;
            }
          }

          return Square(
            isWhite: isWhite(index),
            isSelected: isSelected,
            piece: board[row][col],
            onTap: () => pieceSelected(row, col),
            isValidMove: isValidMove,
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
      ),
    );
  }
}
