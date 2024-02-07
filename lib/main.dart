import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac/provider/room_data_provider.dart';
import 'package:tic_tac/screens/a_i_game_screen.dart';
import 'package:tic_tac/screens/a_i_screen.dart';
import 'package:tic_tac/screens/alpha_ai_game_screen.dart';
import 'package:tic_tac/screens/alpha_ai_screen.dart';
import 'package:tic_tac/screens/create_room_screen.dart';
import 'package:tic_tac/screens/game_screen.dart';
import 'package:tic_tac/screens/join_room_screen.dart';
import 'package:tic_tac/screens/main_menu_screen.dart';
import 'package:tic_tac/utils/colors.dart';
void main() {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => RoomDataProvider()),
        ],
          child: const MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
      ),
      routes: {
        MainMenuScreen.routeName:(context)=>const MainMenuScreen(),
        JoinRoomScreen.routeName:(context)=>const JoinRoomScreen(),
        CreateRoomScreen.routeName:(context)=>const CreateRoomScreen(),
        GameScreen.routeName:(context)=>const GameScreen(),
        AIScreen.routeName:(context)=>const AIScreen(),
        AlphaAIScreen.routeName:(context)=>const AlphaAIScreen(),
        AIGameScreen.routeName:(context)=>const AIGameScreen(),
        AlphaAIGameScreen.routeName:(context)=>const AlphaAIGameScreen()
      },
      initialRoute: MainMenuScreen.routeName,
    );
  }
}
