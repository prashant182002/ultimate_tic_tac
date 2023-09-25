import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac/provider/room_data_provider.dart';
import 'package:tic_tac/resources/socket_methods.dart';
import 'package:tic_tac/widgets/score_board.dart';
import 'package:tic_tac/widgets/tictactoe_board.dart';
import 'package:tic_tac/widgets/waiting_lobby.dart';

class GameScreen extends StatefulWidget {
  static String routeName='/game';
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final SocketMethods _socketMethods=SocketMethods();
  @override
  void initState(){
    super.initState();
    _socketMethods.updateRoomListner(context);
    _socketMethods.updatePlayersStateListner(context);
  }
  Widget build(BuildContext context) {
    RoomDataProvider roomDataProvider=Provider.of<RoomDataProvider>(context);
    // print(isJoin);
    return Scaffold(
      body:
      roomDataProvider.roomData['isJoin']
          ? const WaitingLobby()
          : SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TicTacToeBoard(),
                Text('${roomDataProvider.roomData['turn']['nickname']}\'s turn')
              ],
            ),
          )
      )
    );
  }
}
