import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac/provider/room_data_provider.dart';
import 'package:tic_tac/resources/socket_methods.dart';
import 'package:tic_tac/widgets/tic_tac_border.dart';
import 'package:flutterwebapp_reload_detector/flutterwebapp_reload_detector.dart';

class TicTacToeBoard extends StatefulWidget {
  final int AI;
  final int AItype;
  final String choice;
  const TicTacToeBoard({
    Key? key,
    required this.AI,
    required this.AItype,
    required this.choice,
  }) : super(key: key);

  @override
  State<TicTacToeBoard> createState() => _TicTacToeBoardState();
}

class _TicTacToeBoardState extends State<TicTacToeBoard> {
  int get AI => widget.AI;
  int get AIType => widget.AItype;
  String get choice=>widget.choice;
  final SocketMethods _socketMethods=SocketMethods();
  bool _isInitialLoad = true;

  @override
  void initState(){
    super.initState();
    final roomDataProvider = Provider.of<RoomDataProvider>(context, listen: false);
    if(AI==0)
      _socketMethods.tappedListner(context);
    else {
      if(choice=='O'){
        roomDataProvider.displayElements[4][4]='X';
        roomDataProvider.setBoardToPlayOn(4);
      }
      _socketMethods.checkedListner(roomDataProvider);
    }
  }

  void tapped(int mainBoard,int localBoard,RoomDataProvider roomDataProvider){
    if(AI==1){
      print('tapped............................');
      _socketMethods.checker(
          mainBoard,
          localBoard,
          roomDataProvider.roomData['_id'],
          roomDataProvider.displayElements,
          roomDataProvider.wholeBoard,
          roomDataProvider.preChoice,
          roomDataProvider.moves,
          0,
          AIType
      );
    }
    else {
      _socketMethods.tapGrid(
          mainBoard,
          localBoard,
          roomDataProvider.roomData['_id'],
          roomDataProvider.displayElements,
          roomDataProvider.wholeBoard
      );
    }
  }
  bool absorb(RoomDataProvider roomDataProvider){
    // print('absorbed...........................');
    if(AI==0){
      if(roomDataProvider.roomData['turn']['socketID'] != _socketMethods.socketClient?.id) {
        return true;
      }
      return false;
    }
    else{
      if(roomDataProvider.chance==1) return false;
      return true;
    }
  }
  bool absorb2(RoomDataProvider roomDataProvider,int mainBoard){
    // print('absorb2........................');
    return roomDataProvider.boardToPlayOn!=mainBoard && roomDataProvider.boardToPlayOn!=-1;
  }
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    RoomDataProvider roomDataProvider=Provider.of<RoomDataProvider>(context);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: size.height*0.7,
        maxWidth: 500
      ),
      child: AbsorbPointer(
        absorbing: absorb(roomDataProvider) ,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (BuildContext context,int mainBoard){
            return Container(
              decoration: BoxDecoration(
                  border: TicTacBorder.customBorder(mainBoard,6.0),
                  color: (roomDataProvider.boardToPlayOn==mainBoard || (roomDataProvider.boardToPlayOn==-1 && roomDataProvider.wholeBoard[mainBoard]==''))?Colors.red:Colors.indigo,
              ),
              child: AbsorbPointer(
                absorbing: absorb2(roomDataProvider, mainBoard),
                child: roomDataProvider.wholeBoard[mainBoard]!='' ?
                Center(
                  child: Text(
                      roomDataProvider.wholeBoard[mainBoard],
                    style: const TextStyle(
                      fontSize: 150,
                    ),
                  ),
                ) :GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemBuilder:(BuildContext context,int localBoard) {
                    return GestureDetector(
                      onTap: ()=>tapped(mainBoard,localBoard,roomDataProvider),
                      child: Container(
                        decoration: BoxDecoration(
                            border: TicTacBorder.customBorder(localBoard,2.0),
                          color: Colors.transparent,
                        ),
                        child: Center(
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 100),
                            child: Text(
                                roomDataProvider.displayElements[mainBoard][localBoard],
                                style:TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 40,
                                        color: roomDataProvider.displayElements[mainBoard][localBoard]=='O'? Colors.red:Colors.blue,
                                      )
                                    ]
                                )
                            ),
                          ),
                        )
                      ),
                    );
                  },
                  itemCount: 9,
                ),
              ),
            );
          },
          itemCount: 9,
        ),
      ),
    );
  }
}
