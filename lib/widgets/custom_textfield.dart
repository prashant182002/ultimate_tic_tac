import 'package:flutter/material.dart';
import 'package:tic_tac/utils/colors.dart';

class CustomTextField extends StatelessWidget {
  final String hinttext;
  final TextEditingController controller;
  final bool isReadOnly;
  const CustomTextField({Key? key,
    required this.controller,
    required this.hinttext,
    this.isReadOnly=false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.blue,
            blurRadius: 5,
            spreadRadius: 1,
          )
        ]
      ),
      child: TextField(
        readOnly: isReadOnly,
        controller: controller,
        decoration: InputDecoration(
          fillColor: bgColor,
          filled: true,
          hintText: hinttext,
        ),
      ),
    );
  }
}
