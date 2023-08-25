import 'package:attendance1/firebase_options.dart';
import 'package:attendance1/widget/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

final kColorSheme =
    ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 47, 116, 82));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
     MaterialApp(
      theme: ThemeData(colorScheme: kColorSheme),
      home: Home(),
    ),
  );
}
