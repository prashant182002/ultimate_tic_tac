import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac/provider/room_data_provider.dart';
import 'package:tic_tac/resources/socket_methods.dart';
import 'package:tic_tac/responsive/responsive.dart';
import 'package:tic_tac/screens/alpha_ai_game_screen.dart';
import 'package:tic_tac/widgets/custom_button.dart';
import 'package:tic_tac/widgets/custom_text.dart';

class AlphaAIScreen extends StatefulWidget {
  static String routeName='/AlphaAI';
  const AlphaAIScreen({Key? key}) : super(key: key);

  @override
  State<AlphaAIScreen> createState() => _AlphaAIScreenState();
}

class _AlphaAIScreenState extends State<AlphaAIScreen> {
  final SocketMethods _socketMethods=SocketMethods();
  var roomDataProvider ;
  var i = 0;

  @override
  void initState(){
    super.initState();
    roomDataProvider = Provider.of<RoomDataProvider>(context,listen: false);
    _socketMethods.createRoomSuccessListner(roomDataProvider,(){
      if(i==1 && mounted){
        print("done");
        Navigator.pushNamed(context,AlphaAIGameScreen.routeName);
      }
    });
  }

  @override
  void dispose() {
    _socketMethods.disp();
    super.dispose();
  }

  Widget build(BuildContext context) {
    RoomDataProvider roomDataProvider=Provider.of<RoomDataProvider>(context,listen: false);
    var choice='';
    print(choice);
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
                      print(".........");
                      print(choice);
                      choice='X';
                      print(choice);
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
                if(choice==''){
                  showDialog(context: context, builder: (context){
                    return AlertDialog(title: Text('choice cannot be empty'),);
                  })
                }
                else{
                  roomDataProvider.setPreChoice(choice),
                  _socketMethods.createRoom('PLAYER',2),
                  i=1
                }
              }, text: 'Create')
            ],
          ),
        ),
      ),
    );
  }
}
