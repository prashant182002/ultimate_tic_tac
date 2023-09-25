import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac/provider/room_data_provider.dart';
import 'package:tic_tac/screens/create_room_screen.dart';
import 'package:tic_tac/screens/game_screen.dart';
import 'package:tic_tac/screens/join_room_screen.dart';
import 'package:tic_tac/screens/main_menu_screen.dart';
import 'package:tic_tac/utils/colors.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => RoomDataProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: bgColor,
        ),
        routes: {
          MainMenuScreen.routeName:(context)=>MainMenuScreen(),
          JoinRoomScreen.routeName:(context)=>JoinRoomScreen(),
          CreateRoomScreen.routeName:(context)=>CreateRoomScreen(),
          GameScreen.routeName:(context)=>GameScreen(),
        },
        initialRoute: MainMenuScreen.routeName,
      )
    );
  }
}
