import 'package:flutter/material.dart';

import '../main.dart';
import '../screens/election/election detail/election_detail.dart';
import '../screens/election/election detail/election_info.dart';
import '../screens/election/election.dart';
import '../screens/home/dashboard.dart';
import '../screens/account/login_pin.dart';
import '../screens/account/register_pin.dart';
import '../screens/welcome.dart';
import '../screens/account/login.dart';
import '../screens/account/register.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case RouteList.welcome:
        return MaterialPageRoute(builder: (_) => const Welcome());
      case RouteList.login:
        return MaterialPageRoute(builder: (_) => const Login());
      case RouteList.loginPin:
        return MaterialPageRoute(
            builder: (_) => const LoginPin(
                  phoneNum: '',
                ));
      case RouteList.register:
        return MaterialPageRoute(builder: (_) => const Register());
      case RouteList.registerPin:
        return MaterialPageRoute(builder: (_) => const RegisterPin());
      case RouteList.dashboard:
        return MaterialPageRoute(builder: (_) => const Dashboard());
      case RouteList.election:
        return MaterialPageRoute(builder: (_) => const Election());
      case RouteList.electionDetail:
        return MaterialPageRoute(builder: (_) => const ElectionDetail());
      // case RouteList.phoneSignInPage:
      //   return MaterialPageRoute(builder: (_) => const PhoneSignInPage());
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
  static const String election = '/Election';
  static const String electionDetail = '/ElectionDetail';
  // static const String phoneSignInPage = '/PhoneSignInPage';
}
