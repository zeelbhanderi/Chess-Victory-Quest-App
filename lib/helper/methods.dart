bool isWhite(int index){
  int x = index ~/ 8; // give integer division  (row)
  int y = index % 8; // gives the remainder ie. (Column)
  bool isWhite = (x + y) % 2 == 0;
   return isWhite;
}