import 'package:flutter/material.dart';
import 'package:tic_tac/resources/socket_methods.dart';
import 'package:tic_tac/responsive/responsive.dart';
import 'package:tic_tac/widgets/custom_button.dart';
import 'package:tic_tac/widgets/custom_text.dart';
import 'package:tic_tac/widgets/custom_textfield.dart';
import 'game_screen.dart';

class CreateRoomScreen extends StatefulWidget {
  static String routeName='/create-room';
  const CreateRoomScreen({Key? key}) : super(key: key);

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _nameController=TextEditingController();
  final SocketMethods _socketMethods=SocketMethods();

  @override

  void initState(){
    super.initState();
    _socketMethods.createRoomSuccessListner(context);
  }

  void dispose(){
    super.dispose();
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
                    ], text: 'Create Room', fontSize: 70),
                SizedBox(height: size.height*0.08,),
                CustomTextField(controller: _nameController,hinttext: 'Enter your nickname',),
                SizedBox(height: size.height*0.04,),
                CustomButton(onTap: ()=>
                {
                  // print(_nameController.text);
                  _socketMethods.createRoom(_nameController.text)
                }, text: 'Create')

              ],
            ),
          ),
        ),
    );
  }
}