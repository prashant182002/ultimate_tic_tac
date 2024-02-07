import 'dart:js';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/src/socket.dart';
import 'package:tic_tac/provider/room_data_provider.dart';
import 'package:tic_tac/resources/game_methods.dart';
import 'package:tic_tac/resources/socket_client.dart';
import 'package:tic_tac/screens/a_i_screen.dart';
import 'package:tic_tac/screens/game_screen.dart';
import '../screens/a_i_game_screen.dart';
import '../screens/alpha_ai_game_screen.dart';
import '../utils/utils.dart';

class SocketMethods{
  final _socketClient=SocketClient.instance?.socket!;
  Socket? get socketClient=>_socketClient;
  void disp(){
    socketClient?.close();
  }
  //EMITS
  void createRoom(String nickname,var AI){
    // print("vps agya"),
    if(nickname.isNotEmpty){
        print('creating');
      _socketClient?.emit('createRoom',{
        'nickname':nickname,
        'AI':AI
      });
    }
  }

  void joinRoom(String nickname,String roomId){
    if(nickname.isNotEmpty && roomId.isNotEmpty){
      print(nickname);
      _socketClient?.emit('joinRoom',{
        'nickname':nickname,
        'roomId':roomId,
      });
    }
  }

  void tapGrid(int mainBoard,int localBoard,String roomId,List<List<String>> board,List<String> wholeBoard){
      _socketClient?.emit('tap',{
        'mainBoard':mainBoard,
        'localBoard':localBoard,
        'roomId':roomId,
        'board':board,
        'wholeBoard':wholeBoard
      });
    // }
  }

  void checker(int mainBoard,int localBoard,String roomID,List<List<String>> board,List<String> wholeBoard,String choice,int moves,int AI,int type){
    print('checking.');
    _socketClient?.emit('check',{
      'mainBoard':mainBoard,
      'localBoard':localBoard,
      'board':board,
      'wholeBoard':wholeBoard,
      'choice':choice,
      'roomId':roomID,
      'moves':moves,
      'AI':AI,
      'AItype':type
    });
  }

  //LISTNERS
  void createRoomSuccessListner(RoomDataProvider roomDataProvider,abc()){
    _socketClient?.on('createRoomSuccess',(data) {
      print("vps agya");
      print(data['room']);
      print(roomDataProvider);
      if (roomDataProvider != null) {
        roomDataProvider.updateRoomData(data['room']);
      }
      print("Shivendu");
      abc();
    });
  }

  void joinRoomSuccessListner(RoomDataProvider roomDataProvider,abc()){
    _socketClient?.on('joinRoomSuccess',(room){
      // print("joinnnnnn $room"),
    if (roomDataProvider != null) {
        roomDataProvider.updateRoomData(room);
  }
      // roomDataProvider.updateRoomData(room),
    abc();
      // Navigator.pushNamed(context,GameScreen.routeName)
    });
  }
  // void errorOccuredListner(BuildContext context){
  //   _socketClient?.on('errorOccurred',(data)=>{
  //     showSnackBar(context,data)
  //   });
  // }

  //FUNTIONS
  void updatePlayersStateListner(RoomDataProvider roomDataProvider){
    print('updatePlayers');
    _socketClient?.on('updatePlayers',(playerData){
      roomDataProvider.updatePlayer1(playerData[0]);
      roomDataProvider.updatePlayer2(playerData[1]);
    });
  }
  void updateRoomListner(RoomDataProvider roomDataProvider){
    print('updateRoom');
    _socketClient?.on('updateRoom',(data){
      roomDataProvider.updateRoomData(data);
    });
  }
  void tappedListner(BuildContext context){
    _socketClient?.on('tapped',(data){
      // print(data);
      RoomDataProvider roomDataProvider=Provider.of<RoomDataProvider>(context,listen: false);
      roomDataProvider.assignElement(data['wholeBoard'],data['board'],data['boardToPlayOn'],data['Winner']);
      roomDataProvider.updateRoomData(data['room']);
    });
  }

  // void engineRes(BuildContext context){
  //   RoomDataProvider roomDataProvider=Provider.of<RoomDataProvider>(context,listen: false);
  //   print('engine');
  //
  // }

  void checkedListner(RoomDataProvider roomDataProvider){
    _socketClient?.on('checked',(dataa){
      print('checked');
      var AItype=dataa['AItype'];
      // RoomDataProvider roomDataProvider=Provider.of<RoomDataProvider>(context,listen: false);
      // print('Winner data type ${data['Winner'].runtimeType}');
      print(dataa['Winner'].toString());
      roomDataProvider.assignElement(dataa['wholeBoard'],dataa['board'],dataa['boardToPlayOn'],dataa['Winner'].toString());
      // print(dataa['AI']);
      roomDataProvider.updateChance(dataa['AI']);
      if(dataa['AI']==0){
        roomDataProvider.incrementMoves();
        String xo;
        print("B");
        roomDataProvider.preChoice=='X'?xo='O':xo='X';
        _socketClient?.on('AIres',(data){
          print(data['main']);
          print(data['local']);
          print('...................');
          checker(data['main'], data['local'],
            roomDataProvider.roomData['_id'],
            roomDataProvider.displayElements,
            roomDataProvider.wholeBoard,
            xo,
            roomDataProvider.moves,
            1,
            AItype
          );
        });
        // _socketClient?.off('AIres', data['AI']);
        print("BBB");
      }
    });

  }

}