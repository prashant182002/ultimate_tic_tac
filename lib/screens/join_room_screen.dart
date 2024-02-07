import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac/resources/socket_methods.dart';

import '../provider/room_data_provider.dart';
import '../responsive/responsive.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_textfield.dart';
import 'game_screen.dart';

class JoinRoomScreen extends StatefulWidget {
  static String routeName='/join-room';
  const JoinRoomScreen({Key? key}) : super(key: key);

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController _gameIdController =TextEditingController();
  final TextEditingController _nameController =TextEditingController();
  final SocketMethods _socketMethods=SocketMethods();
  var roomDataProvider;
  var i=0;
  @override

  void initState(){
    roomDataProvider = Provider.of<RoomDataProvider>(context,listen: false);
    super.initState();
    _socketMethods.joinRoomSuccessListner(roomDataProvider,(){
      if(i==1){
        Navigator.pushNamed(context,GameScreen.routeName);
      }
    });
    // _socketMethods.errorOccuredListner(context);
    _socketMethods.updatePlayersStateListner(roomDataProvider);
  }
  void dispose(){
    super.dispose();
    _socketMethods.disp();
    _gameIdController.dispose();
    _nameController.dispose();
  }
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20,),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CustomText(
                  shadows: [
                    Shadow(
                      blurRadius: 40,
                      color: Colors.blue,
                    )
                  ], text: 'Join Room', fontSize: 70),
              SizedBox(height: size.height*0.08,),
              CustomTextField(controller: _nameController,hinttext: 'Enter your nickname',),
              SizedBox(height: size.height*0.04,),
              CustomTextField(controller: _gameIdController,hinttext: 'Enter game Id',),
              SizedBox(height: size.height*0.04,),
              CustomButton(onTap: ()
              {
                    print(_nameController.text);
                        _socketMethods.joinRoom(
                            _nameController.text, _gameIdController.text);
                            i=1;
                      }, text: 'Join')
            ],
          ),
        ),
      ),
    );
  }
}
