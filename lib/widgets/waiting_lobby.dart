import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac/provider/room_data_provider.dart';
import 'package:tic_tac/widgets/custom_textfield.dart';

class WaitingLobby extends StatefulWidget {
  const WaitingLobby({Key? key}) : super(key: key);

  @override
  State<WaitingLobby> createState() => _WaitingLobbyState();
}

class _WaitingLobbyState extends State<WaitingLobby> {
  late TextEditingController roomIdController;
  @override
  void initState(){
    super.initState();
    roomIdController=TextEditingController(
      text: Provider.of<RoomDataProvider>(context,listen: false).roomData['_id']
    );
  }
  void dispose(){
    super.dispose();
    roomIdController.dispose();
  }
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Waiting for a player to join'),
        const SizedBox(height: 20,),
        CustomTextField(
            controller: roomIdController,
            hinttext: '',
            isReadOnly: true,
        )
      ],
    );
  }
}
