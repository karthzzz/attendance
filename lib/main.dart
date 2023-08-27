import 'package:attendance1/animation/splash_screen.dart';
import 'package:attendance1/firebase_options.dart';

import 'package:attendance1/widget/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

var kSchemeColor = ColorScheme.fromSeed(seedColor: Colors.green);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MaterialApp(
      theme: ThemeData().copyWith(
        colorScheme: kSchemeColor,
      ),
      home: SplashAnimationOfBook(),
    ),
  );
}
