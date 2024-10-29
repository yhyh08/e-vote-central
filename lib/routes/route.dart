import 'package:flutter/material.dart';

import '../main.dart';
import '../screens/login.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      // case RouteList.welcome:
      //   return MaterialPageRoute(builder: (_) => const Welcome());
      case RouteList.login:
        return MaterialPageRoute(builder: (_) => const Login());
      default:
        return MaterialPageRoute(builder: (_) => const MyApp());
    }
  }
}

class RouteList {
  static const String welcome = '/Welcome';
  static const String login = '/Login';
}
