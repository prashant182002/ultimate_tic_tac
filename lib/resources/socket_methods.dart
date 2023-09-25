import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/src/socket.dart';
import 'package:tic_tac/provider/room_data_provider.dart';
import 'package:tic_tac/resources/game_methods.dart';
import 'package:tic_tac/resources/socket_client.dart';
import 'package:tic_tac/screens/game_screen.dart';
import '../utils/utils.dart';

class SocketMethods{
  final _socketClient=SocketClient.instance?.socket!;
  Socket? get socketClient=>_socketClient;
  //EMITS
  void createRoom(String nickname){
    if(nickname.isNotEmpty){
        print('creating');
      _socketClient?.emit('createRoom',{
        'nickname':nickname,
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

  void tapGrid(int mainBoard,int localBoard,String roomId){
    // if(displayElements[mainBoard][localBoard]==''){
      _socketClient?.emit('tap',{
        'mainBoard':mainBoard,
        'localBoard':localBoard,
        'roomId':roomId
      });
    // }
  }

  //LISTNERS
  void createRoomSuccessListner(BuildContext context){
    _socketClient?.on('createRoomSuccess',(room)=>{
      print("$room .............."),
      Provider.of<RoomDataProvider>(context,listen:false)
          .updateRoomData(room),
      Navigator.pushNamed(context,GameScreen.routeName)
    });
  }
  void joinRoomSuccessListner(BuildContext context){
    _socketClient?.on('joinRoomSuccess',(room)=>{
      print("joinnnnnn $room"),
      Provider.of<RoomDataProvider>(context,listen:false)
          .updateRoomData(room),
      Navigator.pushNamed(context,GameScreen.routeName)
    });
  }
  void errorOccuredListner(BuildContext context){
    _socketClient?.on('errorOccurred',(data)=>{
      showSnackBar(context,data)
    });
  }

  //FUNTIONS
  void updatePlayersStateListner(BuildContext context){
    print('updatePlayers');
    _socketClient?.on('updatePlayers',(playerData){
      Provider.of<RoomDataProvider>(context,listen: false).updatePlayer1(playerData[0]);
      Provider.of<RoomDataProvider>(context,listen: false).updatePlayer2(playerData[1]);
    });
  }
  void updateRoomListner(BuildContext context){
    print('updateRoom');
    _socketClient?.on('updateRoom',(data){
      Provider.of<RoomDataProvider>(context,listen: false).updateRoomData(data);
    });
  }
  void tappedListner(BuildContext context){
    _socketClient?.on('tapped',(data){
      RoomDataProvider roomDataProvider=Provider.of<RoomDataProvider>(context,listen: false);
      roomDataProvider.updateRoomData(data['room']);
    });
  }
}