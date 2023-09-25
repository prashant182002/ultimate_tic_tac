import 'package:flutter/material.dart';
import 'package:tic_tac/models/player.dart';

class RoomDataProvider extends ChangeNotifier{
  Map<String,dynamic> _roomData = {};
  // List<List<String>> _displayElements=
  // [ ['','','','','','','','',''],
  //   ['','','','','','','','',''],
  //   ['','','','','','','','',''],
  //   ['','','','','','','','',''],
  //   ['','','','','','','','',''],
  //   ['','','','','','','','',''],
  //   ['','','','','','','','',''],
  //   ['','','','','','','','',''],
  //   ['','','','','','','','','']];
  // List<String> _mainBoard=['','','','','','','','','',];
  // int _filledBoxes=0;
  String _newElement='';
  Player _player1=Player(nickname: "", socketID: "", playerType: 'X');
  Player _player2=Player(nickname: "", socketID: "", playerType: 'O');

  Map<String,dynamic> get roomData=>_roomData;
  // List<List<String>> get displayElements=>_displayElements;
  // List<String> get mainBoard=>_mainBoard;
  // int get filledBoxes=>_filledBoxes;
  String get newElement => _newElement;
  Player get player1 =>_player1;
  Player get player2 =>_player2;

  void updateRoomData(Map<String,dynamic> data){
    _roomData=data;
    notifyListeners();
  }
  void updatePlayer1(Map<String,dynamic> player1Data){
    _player1=Player.fromMap(player1Data);
    notifyListeners();
  }
  void updatePlayer2(Map<String,dynamic> player2Data){
    _player2=Player.fromMap(player2Data);
    notifyListeners();
  }
  void assignElement(int x,int y,String choice){
    _newElement=choice;
    notifyListeners();
  }
  // void setFilledBoxesTo0(){
  //   _filledBoxes=0;
  // }
}