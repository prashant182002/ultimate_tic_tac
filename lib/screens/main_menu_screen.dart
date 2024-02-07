import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac/responsive/responsive.dart';
import 'package:tic_tac/screens/create_room_screen.dart';
import '../provider/room_data_provider.dart';
import '../widgets/custom_button.dart';
import 'a_i_screen.dart';
import 'alpha_ai_screen.dart';
import 'join_room_screen.dart';


class MainMenuScreen extends StatelessWidget {
  static String routeName='/main-menu';
  const MainMenuScreen({Key? key}) : super(key: key);
  void createRoom(BuildContext context){
    Navigator.pushNamed(context, CreateRoomScreen.routeName);
  }
  void joinRoom(BuildContext context){
    Navigator.pushNamed(context, JoinRoomScreen.routeName);
  }
  void aiRoom(BuildContext context){
    Navigator.pushNamed(context, AIScreen.routeName);
  }
  void alphaAiRoom(BuildContext context){
    Navigator.pushNamed(context, AlphaAIScreen.routeName);
  }
  @override
  Widget build(BuildContext context) {
    RoomDataProvider roomDataProvider=Provider.of<RoomDataProvider>(context);
    roomDataProvider.firstLoad=true;
    return Scaffold(
        body:Responsive(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(onTap: ()=>createRoom(context),
                  text: 'Create Room'),
              const SizedBox(height: 20,),
              CustomButton(onTap: ()=>joinRoom(context),
                  text: 'Join Room'),
              const SizedBox(height: 20,),
              CustomButton(onTap: ()=>aiRoom(context),
                  text: 'Play against Classical Engine'),
              const SizedBox(height: 20,),
              CustomButton(onTap: ()=>alphaAiRoom(context),
                  text: 'Play against Modern Engine'),
            ],),

        )
    );
  }
}
