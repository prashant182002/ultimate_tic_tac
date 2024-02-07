import 'package:flutter/material.dart';
import 'package:tic_tac/resources/game_methods.dart';
import 'package:tic_tac/screens/main_menu_screen.dart';

void showSnackBar(BuildContext context,String content){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(content)
      )
  );
}

void showGameDialog(BuildContext context,String text){
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context){
    return AlertDialog(
      title: Text(text),
      actions:[
        TextButton(onPressed: (){
          Navigator.pushNamed(context,MainMenuScreen.routeName);
        }, child: const Text('Exit'))
      ]
    );
  });
}