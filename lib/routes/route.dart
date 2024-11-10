import 'package:flutter/material.dart';

import '../main.dart';
import '../screens/home/dashboard.dart';
import '../screens/login_pin.dart';
import '../screens/register_pin.dart';
import '../screens/welcome.dart';
import '../screens/login.dart';
import '../screens/register.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case RouteList.welcome:
        return MaterialPageRoute(builder: (_) => const Welcome());
      case RouteList.login:
        return MaterialPageRoute(builder: (_) => const Login());
      case RouteList.loginPin:
        return MaterialPageRoute(builder: (_) => const LoginPin());
      case RouteList.register:
        return MaterialPageRoute(builder: (_) => const Register());
      case RouteList.registerPin:
        return MaterialPageRoute(builder: (_) => const RegisterPin());
      case RouteList.dashboard:
        return MaterialPageRoute(builder: (_) => const Dashboard());
      default:
        return MaterialPageRoute(builder: (_) => const MyApp());
    }
  }
}

class RouteList {
  static const String welcome = '/Welcome';
  static const String login = '/Login';
  static const String loginPin = '/LoginPin';
  static const String register = '/Register';
  static const String registerPin = '/RegisterPin';
  static const String dashboard = '/Dashboard';
}
