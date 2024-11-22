import 'package:flutter/material.dart';

import '../main.dart';
import '../screens/election/election_detail/candidate_profile.dart';
import '../screens/election/election_detail/election_detail.dart';
import '../screens/election/election_detail/election_info.dart';
import '../screens/election/election_detail/election_organization.dart';
import '../screens/election/election.dart';
import '../screens/home/dashboard.dart';
import '../screens/account/login_pin.dart';
import '../screens/account/register_pin.dart';
import '../screens/result/result_detail.dart';
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
        return MaterialPageRoute(builder: (_) => const LoginPin());
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
      case RouteList.candidateProfile:
        return MaterialPageRoute(builder: (_) => const CandidateProfile());
      // case RouteList.electionOrganization:
      //   return MaterialPageRoute(builder: (_) => ElectionOrganization());
      // case RouteList.result:
      //   return MaterialPageRoute(builder: (_) => const Result());
      case RouteList.resultDetail:
        return MaterialPageRoute(builder: (_) => const ResultDetail());
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
  static const String candidateProfile = '/CandidateProfile';
  static const String electionOrganization = '/ElectionOrganization';
  static const String result = '/Result';
  static const String resultDetail = '/ResultDetail';
}
