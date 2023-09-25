import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac/provider/room_data_provider.dart';
import 'package:tic_tac/resources/socket_methods.dart';
import 'package:tic_tac/widgets/tic_tac_border.dart';

class TicTacToeBoard extends StatefulWidget {
  const TicTacToeBoard({Key? key}) : super(key: key);

  @override
  State<TicTacToeBoard> createState() => _TicTacToeBoardState();
}

class _TicTacToeBoardState extends State<TicTacToeBoard> {
  final SocketMethods _socketMethods=SocketMethods();
  int allowedX=-1,allowedY=-1;
  @override
  void initState(){
    super.initState();
    _socketMethods.tappedListner(context);
  }
  void tapped(int mainBoard,int localBoard,RoomDataProvider roomDataProvider){
    _socketMethods.tapGrid(mainBoard,localBoard,
        roomDataProvider.roomData['_id'],
        // roomDataProvider.displayElements
    );
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
        absorbing: roomDataProvider.roomData['turn']['socketID'] != _socketMethods.socketClient?.id ,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (BuildContext context,int mainBoard){
            return Container(
              decoration: BoxDecoration(
                  border: TicTacBorder.customBorder(mainBoard,6.0)
              ),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemBuilder:(BuildContext context,int localBoard) {
                  return GestureDetector(
                    onTap: ()=>tapped(mainBoard,localBoard,roomDataProvider),
                    child: Container(
                      decoration: BoxDecoration(
                          border: TicTacBorder.customBorder(localBoard,2.0)
                      ),
                      child: Center(
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 100),
                          child: Text(
                              roomDataProvider.newElement,
                              style:TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 40,
                                      color: roomDataProvider.newElement=='O'? Colors.red:Colors.blue,
                                    )
                                  ]
                              )
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: 9,
              ),
            );
          },
          itemCount: 9,
        ),
      ),
    );
  }
}
