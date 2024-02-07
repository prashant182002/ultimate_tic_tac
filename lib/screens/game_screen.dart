import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac/provider/room_data_provider.dart';
import 'package:tic_tac/resources/socket_methods.dart';
// import 'package:tic_tac/widgets/score_board.dart';
import 'package:tic_tac/widgets/tictactoe_board.dart';
import 'package:tic_tac/widgets/waiting_lobby.dart';
import '../utils/utils.dart';
import '../widgets/win_box.dart';

class GameScreen extends StatefulWidget {
  static String routeName='/game';
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

Widget toShow(RoomDataProvider roomDataProvider){
  if(roomDataProvider.winner=='X'){
    return WinBox(winnerName: roomDataProvider.player1.nickname);
  }
  if(roomDataProvider.winner=='O'){
    return WinBox(winnerName: roomDataProvider.player1.nickname);
  }
  return TicTacToeBoard( AI: 0,choice: '0',AItype: 0,);
}

class _GameScreenState extends State<GameScreen> {
  final SocketMethods _socketMethods=SocketMethods();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    RoomDataProvider roomDataProvider =
    Provider.of<RoomDataProvider>(context, listen: false);
    _socketMethods.updateRoomListner(roomDataProvider);
    _socketMethods.updatePlayersStateListner(roomDataProvider);
  }
  Widget build(BuildContext context) {
    RoomDataProvider roomDataProvider=Provider.of<RoomDataProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        _socketMethods.disp();
        bool confirm = await showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('Are you sure?'),
                content: Text('Do you want to leave the game?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: ()
                    {
                      _socketMethods.disp();
                      roomDataProvider.reset();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('No'),
                  ),
                ],
              ),
        );

        return confirm ?? false;
      },
      child: Scaffold(
        body:
        roomDataProvider.roomData['isJoin']
            ? const WaitingLobby()
            : SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  toShow(roomDataProvider),
                  Text('${roomDataProvider.roomData['turn']?['nickname'] ?? 'Unknown Player'}\'s turn')
                ],
              ),
            )
        )
      ),
    );
  }
}
