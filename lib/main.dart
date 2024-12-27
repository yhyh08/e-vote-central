import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/theme.dart';
import 'routes/route.dart';
import 'screens/home/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      // home: const Dashboard(),
      home: CheckAuth(),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isAuth = false;
  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      setState(() {
        isAuth = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isAuth) {
      child = Dashboard();
    } else {
      child = SplashScreen();
    }
    return Scaffold(
      body: child,
    );
  }
}
