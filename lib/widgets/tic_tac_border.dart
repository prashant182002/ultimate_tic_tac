import 'package:flutter/material.dart';

class TicTacBorder {
  static Border customBorder(int index,double width) {
    BorderSide rightBorder=BorderSide.none;
    if(index%3==1 || index%3==0){
      rightBorder=BorderSide(
        color:Colors.white24,
        width: width
      );
    }

    BorderSide bottomBorder=BorderSide.none;
    if(index>=0 && index<=5){
      bottomBorder=BorderSide(
          color:Colors.white24,
          width: width
      );
    }

    return Border(
      right: rightBorder,
      bottom: bottomBorder,
    );
  }
}
