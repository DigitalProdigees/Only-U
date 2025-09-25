import 'package:flutter/material.dart';
import 'package:only_u/app/data/constants.dart';

class WelcomWidget extends StatelessWidget {
  const WelcomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: 10),
      child: Text("Welcome to OnlyU", style: redHeadingStyle),
    );
  }
}
