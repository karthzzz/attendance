import 'package:attendance1/firebase_options.dart';
import 'package:attendance1/sms/frontend_sms.dart';
import 'package:attendance1/widget/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
     MaterialApp(
      theme: ThemeData(colorScheme: ColorScheme.dark()),
      home: MyApp()
    ),
  );
  runApp(const MaterialApp(home: Home(),));
}
 