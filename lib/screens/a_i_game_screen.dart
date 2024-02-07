import 'dart:html';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac/provider/room_data_provider.dart';
import 'package:tic_tac/resources/socket_methods.dart';
// import 'package:tic_tac/widgets/score_board.dart';
import 'package:tic_tac/widgets/tictactoe_board.dart';
import 'package:tic_tac/widgets/waiting_lobby.dart';
import 'package:tic_tac/widgets/win_box.dart';
import '../utils/utils.dart';
import 'package:flutterwebapp_reload_detector/flutterwebapp_reload_detector.dart';


String yo(RoomDataProvider? roomDataProvider) {
  if (roomDataProvider != null && roomDataProvider.chance == 1) {
    return 'PLAYER';
  }
  return "AI";
}

Widget toShow(RoomDataProvider roomDataProvider){
  if(roomDataProvider.winner != 'N' && roomDataProvider.preChoice != null) {
    if (roomDataProvider.winner == roomDataProvider.preChoice) {
      return WinBox(winnerName: 'Player');
    }
    if (roomDataProvider.winner != roomDataProvider.preChoice) {
      return WinBox(winnerName: 'AI');
    }
  }
  return TicTacToeBoard(AI: 1, choice: roomDataProvider.preChoice ?? 'default', AItype: 1);
}

class AIGameScreen extends StatefulWidget {
  static String routeName = '/AIRoom';
  static final SocketMethods _socketMethods=SocketMethods();

  const AIGameScreen({Key? key}) : super(key: key);

  @override
  State<AIGameScreen> createState() => _AIGameScreenState();
}

class _AIGameScreenState extends State<AIGameScreen> {
  @override
  Widget build(BuildContext context) {
    var roomDataProvider=Provider.of<RoomDataProvider>(context);
    if(roomDataProvider.firstLoad) {
      print("first");
      roomDataProvider.firstLoad = false;
    }
    else{
      print("second");
      roomDataProvider.reset();
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
    return WillPopScope(
      onWillPop: () async {
        AIGameScreen._socketMethods.disp();
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
                      AIGameScreen._socketMethods.disp();
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
          body:SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    toShow(roomDataProvider),
                    SizedBox(height: 20,),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${yo(roomDataProvider ?? RoomDataProvider())}\'s turn'),
                          SizedBox(width: 10,),
                          yo(roomDataProvider)=='AI'? Image.asset(
                            'assets/giphy.gif',
                            width: 20, // Set width
                            height: 20,
                          ):Container(),
                        ],
                      ),
                    )
                  ],
                ),
              )
          )
      ),
    );
  }
}
