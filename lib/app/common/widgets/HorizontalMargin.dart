import 'package:flutter/material.dart';

class HorizontalMargin extends StatelessWidget {
  const HorizontalMargin({super.key, this.width = 10});
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: width);
  }
}