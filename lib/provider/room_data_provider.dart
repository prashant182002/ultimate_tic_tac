import 'package:flutter/material.dart';
import 'package:tic_tac/models/player.dart';

class RoomDataProvider extends ChangeNotifier{

  bool firstLoad=false;
  Map<String,dynamic> _roomData = {};
  List<List<String>> _displayElements=
  [ ['','','','','','','','',''],
    ['','','','','','','','',''],
    ['','','','','','','','',''],
    ['','','','','','','','',''],
    ['','','','','','','','',''],
    ['','','','','','','','',''],
    ['','','','','','','','',''],
    ['','','','','','','','',''],
    ['','','','','','','','','']
  ];
  List<String> _wholeBoard=['','','','','','','','','',];
  Player _player1=Player(nickname: "", socketID: "", playerType: 'X');
  Player _player2=Player(nickname: "", socketID: "", playerType: 'O');
  var _boardToPlayOn=-1;
  var _winner='N';
  var _chance=1;
  var _moves=0;
  var _prechoice='';
  void reset(){
    _roomData={};
    _displayElements=[ ['','','','','','','','',''],
      ['','','','','','','','',''],
      ['','','','','','','','',''],
      ['','','','','','','','',''],
      ['','','','','','','','',''],
      ['','','','','','','','',''],
      ['','','','','','','','',''],
      ['','','','','','','','',''],
      ['','','','','','','','','']
    ];
    _wholeBoard=['','','','','','','','','',];
    _player1=Player(nickname: "", socketID: "", playerType: 'X');
    _player2=Player(nickname: "", socketID: "", playerType: 'O');
    _boardToPlayOn=-1;
    _winner='N';
    _chance=1;
    _moves=0;
    _prechoice='';
  }
  // var _highlight=-1;
  // bool  get conquered =>_conquered;
  int get boardToPlayOn=>_boardToPlayOn;
  Map<String,dynamic> get roomData=>_roomData;
  List<List<String>> get displayElements=>_displayElements;
  List<String> get wholeBoard=>_wholeBoard;
  Player get player1 =>_player1;
  Player get player2 =>_player2;
  String get winner=>_winner;
  int get chance=>_chance;
  int get moves=>_moves;
  String get preChoice=>_prechoice;
  // int get highlight=>_highlight;

  // void changeHighlight(int high){
  //   _highlight=high;
  // }
  void setBoardToPlayOn(int x){
    _boardToPlayOn=x;
  }
  void incrementMoves(){
    _moves++;
  }
  void updateChance(int c){
    _chance=c;
    // print(_chance);
  }
  void setPreChoice(String s){
    _prechoice=s;
  }
  void updateRoomData(Map<String,dynamic> data){
    print('updating......................');
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
  void assignElement(List<dynamic> wholeBoard,List<dynamic>board,dynamic boardToPlayOn,String winner){
    for(int i=0;i<9;i++){
      _wholeBoard[i]=wholeBoard[i].toString();
    }
    for(int i=0;i<9;i++){
      for(int j=0;j<9;j++){
        _displayElements[i][j]=board[i][j].toString();
      }
    }
    _winner=winner;
    print("Who is the winner ...................${winner}");
    _boardToPlayOn=boardToPlayOn;
    notifyListeners();
  }

}
// class RoomDataProviderAI extends ChangeNotifier{
//   List<List<String>> _displayElements=
//   [ ['','','','','','','','',''],
//     ['','','','','','','','',''],
//     ['','','','','','','','',''],
//     ['','','','','','','','',''],
//     ['','','','','','','','',''],
//     ['','','','','','','','',''],
//     ['','','','','','','','',''],
//     ['','','','','','','','',''],
//     ['','','','','','','','','']
//   ];
//   List<String> _wholeBoard=['','','','','','','','','',];
//   var _winner='N';
//   var _boardToPlayOn=-1;
//   var _chanceAI=1;
//   int get chance=>_chanceAI;
//   int get boardToPlayOn=>_boardToPlayOn;
//   List<List<String>> get displayElements=>_displayElements;
//   List<String> get wholeBoard=>_wholeBoard;
//   String get winner=>_winner;
//
//   void assignElement(List<dynamic> wholeBoard,List<dynamic>board,dynamic boardToPlayOn,String winner){
//     for(int i=0;i<9;i++){
//       _wholeBoard[i]=wholeBoard[i].toString();
//     }
//     for(int i=0;i<9;i++){
//       for(int j=0;j<9;j++){
//         _displayElements[i][j]=board[i][j].toString();
//       }
//     }
//     _winner=winner;
//     _boardToPlayOn=boardToPlayOn;
//     notifyListeners();
//   }
// }