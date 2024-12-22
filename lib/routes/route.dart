import 'package:e_vote/screens/register_as_candidate/signature.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/candidate_card.dart';
import '../screens/election/election_detail/candidate/candidate_profile.dart';
import '../screens/election/election_detail/candidate/candidate_profile_detail.dart';
import '../screens/election/election_detail/election_detail.dart';
import '../screens/election/election.dart';
import '../screens/election/voted/voted.dart';
import '../screens/home/dashboard.dart';
import '../screens/account/register_pin.dart';
import '../screens/register_as_candidate/first_register_as_candidate.dart';
import '../screens/register_as_candidate/forth_register_as_candidate.dart';
import '../screens/register_as_candidate/register_status.dart';
import '../screens/register_as_candidate/second_register_as_candidate.dart';
import '../screens/register_as_candidate/third_register_as_candidate.dart';
import '../screens/result/result.dart';
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
        final CandidateDetail candidate = settings.arguments as CandidateDetail;
        return MaterialPageRoute(
          builder: (_) => CandidateProfile(
            candidate: candidate,
          ),
        );
      case RouteList.candidateProfileDetail:
        return MaterialPageRoute(
            builder: (_) => const CandidateProfileDetail());
      case RouteList.voted:
        return MaterialPageRoute(builder: (_) => const Voted());
      case RouteList.result:
        return MaterialPageRoute(builder: (_) => const Result());
      case RouteList.resultDetail:
        return MaterialPageRoute(builder: (_) => const ResultDetail());
      case RouteList.registerStatus:
        return MaterialPageRoute(builder: (_) => const RegisterStatus());
      case RouteList.registerCandidateFirst:
        return MaterialPageRoute(
            builder: (_) => const RegisterCandidateFirst());
      case RouteList.registerCandidateSecond:
        return MaterialPageRoute(
            builder: (_) => const RegisterCandidateSecond());
      case RouteList.registerCandidateThird:
        return MaterialPageRoute(
            builder: (_) => const RegisterCandidateThird());
      case RouteList.registerCandidateForth:
        return MaterialPageRoute(
            builder: (_) => const RegisterCandidateForth());
      case RouteList.signatureCandidate:
        return MaterialPageRoute(builder: (_) => const SignatureCandidate());
      default:
        return MaterialPageRoute(builder: (_) => const MyApp());
    }
  }
}

class RouteList {
  static const String welcome = '/Welcome';
  static const String login = '/Login';
  static const String register = '/Register';
  static const String registerPin = '/RegisterPin';
  static const String dashboard = '/Dashboard';
  static const String election = '/Election';
  static const String electionDetail = '/ElectionDetail';
  static const String candidateProfile = '/CandidateProfile';
  static const String candidateProfileDetail = '/CandidateProfileDetail';
  static const String electionOrganization = '/ElectionOrganization';
  static const String voted = '/Voted';
  static const String result = '/Result';
  static const String resultDetail = '/ResultDetail';
  static const String registerStatus = '/RegisterStatus';
  static const String registerCandidateFirst = '/RegisterCandidateFirst';
  static const String registerCandidateSecond = '/RegisterCandidateSecond';
  static const String registerCandidateThird = '/RegisterCandidateThird';
  static const String registerCandidateForth = '/RegisterCandidateFirst';
  static const String signatureCandidate = '/SignatureCandidate';
}
