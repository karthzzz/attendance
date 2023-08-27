import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class SplashAnimationOfBook extends StatelessWidget {
  const SplashAnimationOfBook({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: RiveAnimation.asset(
          'assets/excel/113-173-loading-book (1).riv',
        ),
      ),
    );
  }
}
