import 'package:flutter/material.dart';
import 'package:tic_tac/resources/socket_methods.dart';

import '../responsive/responsive.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_textfield.dart';

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
  @override

  void initState(){
    super.initState();
    _socketMethods.joinRoomSuccessListner(context);
    _socketMethods.errorOccuredListner(context);
    _socketMethods.updatePlayersStateListner(context);
  }
  void dispose(){
    super.dispose();
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
                      }, text: 'Join')
            ],
          ),
        ),
      ),
    );
  }
}
