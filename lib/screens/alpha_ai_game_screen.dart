import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac/provider/room_data_provider.dart';
import 'package:tic_tac/resources/socket_methods.dart';
// import 'package:tic_tac/widgets/score_board.dart';
import 'package:tic_tac/widgets/tictactoe_board.dart';
import 'package:tic_tac/widgets/waiting_lobby.dart';
import '../utils/utils.dart';
import '../widgets/win_box.dart';

String yo(RoomDataProvider roomDataProvider){
  if(roomDataProvider.chance==1){
    return 'PLAYER';
  }
  return "AI";
}

Widget toShow(RoomDataProvider roomDataProvider){
  if(roomDataProvider.winner=='N'){
    return TicTacToeBoard(AI: 1,choice: roomDataProvider.preChoice,AItype: 2,);
  }
  if(roomDataProvider.winner==roomDataProvider.preChoice){
    return const WinBox(winnerName: 'Player');
  }
    return const WinBox(winnerName: 'AI');
}

class AlphaAIGameScreen extends StatelessWidget {
  static String routeName = '/AlphaAIRoom';
  static final SocketMethods _socketMethods=SocketMethods();
  const AlphaAIGameScreen({Key? key}) : super(key: key);

  @override
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
      child:  Scaffold(
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
                          Text('${yo(roomDataProvider)}\'s turn'),
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
