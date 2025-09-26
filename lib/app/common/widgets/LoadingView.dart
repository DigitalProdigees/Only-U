import 'package:flutter/material.dart';
import 'package:only_u/app/data/constants.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(color: secondaryColor));
  }
}
