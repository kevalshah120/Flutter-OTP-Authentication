import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_module/screens/WatchlitScreen.dart';
import 'package:flutter_otp_module/screens/home_screen/home_screen.dart';
import 'package:flutter_otp_module/screens/login_screen/login_screen.dart';
import 'package:flutter_otp_module/screens/mylist.dart';
import 'package:flutter_otp_module/screens/otp_screen/otp_screen.dart';
import 'package:flutter_otp_module/screens/splashscreen.dart';
import 'package:flutter_otp_module/screens/stocksearch.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: MyCustomSplashScreen(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext ctx) => LoginScreen(),
        '/otpScreen': (BuildContext ctx) => OtpScreen(),
        '/homeScreen': (BuildContext ctx) => HomeScreen(),
        '/watchlistScreen': (BuildContext ctx) => WatchlistScreen(),
        '/mylist': (BuildContext ctx) => WatchListScreen(),
        '/searchScreen': (context) => SearchScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    } catch (e) {
      print("Error initializing SharedPreferences: $e");
    }

    // Wait for 2 seconds before navigating to the appropriate screen
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => isLoggedIn ? WatchlistScreen() : LoginScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
