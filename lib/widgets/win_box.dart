import 'package:flutter/material.dart';

class WinBox extends StatelessWidget {
  final String winnerName;
  const WinBox({Key? key, required this.winnerName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child:Column(
          children: [
            Text("${winnerName} Win's",style: TextStyle(color: Colors.white),),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:  MaterialStateProperty.all<Color?>(Colors.blue)
              ),
                onPressed: (){},
                child: Text('EXIT'),
            )
          ],
        )
      ),
    );
  }
}
