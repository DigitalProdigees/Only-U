import 'package:flutter/material.dart';

class Custominputfield extends StatelessWidget {
  Custominputfield({super.key, this.hintText, this.controller,this.obscureText = false});
  TextEditingController? controller;
  String? hintText ;
  bool obscureText ;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        style: const TextStyle(
          color: Color(0xFFE7F6FF), // input text color
          fontSize: 14,
          fontFamily: 'Rubik',
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFFE7F6FF),
            fontSize: 14,
            fontFamily: 'Rubik',
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 10,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),

            borderSide: BorderSide(
              color: Color(0x802C94D2).withValues(),

              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Color(0xFF2C94D2), // darker when focused
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
