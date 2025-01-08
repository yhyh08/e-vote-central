import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/theme.dart';
import 'providers/vote_provider.dart';
import 'routes/route.dart';
import 'screens/home/dashboard.dart';
import 'screens/splash_screen.dart';
import 'services/vote_service.dart';
import 'providers/registration_state.dart';
import 'providers/user_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => VoteProvider(
            VoteService(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => RegistrationState()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      // home: const Dashboard(),
      home: const CheckAuth(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

class CheckAuth extends StatefulWidget {
  const CheckAuth({super.key});

  @override
  State<CheckAuth> createState() => _CheckAuthState();
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
      child = const Dashboard();
    } else {
      child = const SplashScreen();
    }
    return Scaffold(
      body: child,
    );
  }
}
