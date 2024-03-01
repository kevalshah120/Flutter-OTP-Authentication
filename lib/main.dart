import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/home_screen/home_screen.dart';
import 'screens/login_screen/login_screen.dart';
import 'screens/otp_screen/otp_screen.dart';

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    Platform.isAndroid
        ? await Firebase.initializeApp(
            options: const FirebaseOptions(
                apiKey: 'AIzaSyAbC4WPkWHx5TOkxpLN8JB-M2Bgo69MuRk',
                appId: '1:10220019127:android:d9ee6f170bc6d1f11fdc32',
                messagingSenderId: '10220019127',
                projectId: 'stockchain-789e1')
                )

        : await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter OTP Authentication',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 253, 188, 51),
      ),
      home: LoginScreen(),
      routes: <String, WidgetBuilder>{
        '/otpScreen': (BuildContext ctx) => OtpScreen(),
        '/homeScreen': (BuildContext ctx) => HomeScreen(),
      },
    );
  }
}
