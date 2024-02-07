import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac/provider/room_data_provider.dart';
import 'package:tic_tac/resources/socket_methods.dart';
import 'package:tic_tac/responsive/responsive.dart';
import 'package:tic_tac/widgets/custom_button.dart';
import 'package:tic_tac/widgets/custom_text.dart';
import 'a_i_game_screen.dart';

class AIScreen extends StatefulWidget {
  static String routeName='/AI';
  const AIScreen({Key? key}) : super(key: key);

  @override
  State<AIScreen> createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen> {
  final SocketMethods _socketMethods=SocketMethods();
  var roomDataProvider ;
  var i = 0;
   @override
   void initState(){
     super.initState();
     roomDataProvider = Provider.of<RoomDataProvider>(context,listen: false);
     _socketMethods.createRoomSuccessListner(roomDataProvider,(){
       if(i==1 && mounted){
         Navigator.pushNamed(context,AIGameScreen.routeName);
       }
     });
   }

  @override
  void dispose() {
   _socketMethods.disp();
    super.dispose();
  }

  Widget build(BuildContext context) {
    print("screen");

    var choice='';

    final size=MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20,),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                  'Choose',
                style: TextStyle(
                  fontSize: 70,
                  color: Colors.white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      shadowColor: Colors.transparent,
                      side: choice=='X' ? BorderSide(
                        color: Colors.blue,
                      ):BorderSide(),
                    ),
                    child: Text('X', style: TextStyle(color: Colors.blue,fontSize: 50),),
                    onPressed: () {
                      // print(".........");
                      print(choice);
                      // setState((){
                        choice='X';
                      // });
                      // print(choice);
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        shadowColor: Colors.transparent,
                      side: choice=='O' ? BorderSide(
                        color: Colors.red,
                      ):BorderSide(),
                    ),
                    child: Text('O', style: TextStyle(color: Colors.red,fontSize: 50),),
                    onPressed: () {choice='O';},
                  ),
                ],
              ),
              SizedBox(height: 20,),
              CustomButton(onTap: ()=>
              {
                print('tapped button'),
                if(choice==''){
                  showDialog(context: context, builder: (context){
                    return AlertDialog(title: Text('choice cannot be empty'),);
                  })
                }
                else{
                  Provider.of<RoomDataProvider>(context,listen: false).setPreChoice(choice),
                  _socketMethods.createRoom('PLAYER',1),
                  i=1
        }
              }, text: 'Choose')
            ],
          ),
        ),
      ),
    );
  }
}
