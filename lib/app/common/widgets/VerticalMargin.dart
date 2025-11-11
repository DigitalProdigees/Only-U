import 'package:flutter/material.dart';

class VerticalMargin extends StatelessWidget {
  const VerticalMargin({super.key, this.height = 10});
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}