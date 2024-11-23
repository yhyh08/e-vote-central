import 'package:flutter/material.dart';
import 'package:flutter_walkthrough_screen/flutter_walkthrough_screen.dart';
import 'package:e_vote/screens/account/login.dart';

class TestScreen extends StatelessWidget {
  final List<OnbordingData> list = [
    const OnbordingData(
      image: AssetImage("images/pic1.png"),
      titleText: Text("Welcome to E-Vote Central"),
      descText: Text(
          "Register from anywhere at any time without having to go through stress"),
    ),
    const OnbordingData(
      image: AssetImage("images/pic2.png"),
      titleText: Text("This is Title2"),
      descText: Text(
          "Check out the different elections currently taking place in your area"),
    ),
    const OnbordingData(
      image: AssetImage("images/pic3.png"),
      titleText: Text("This is Title3"),
      descText: Text(
          "Explore the profile of candidates before you vote and learn more about each candidate's policies and qualifications."),
    ),
    const OnbordingData(
      image: AssetImage("images/pic4.png"),
      titleText: Text("This is Title4"),
      descText: Text("Select your preferred candidate to cast your vote."),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroScreen(
      onbordingDataList: list,
      colors: [
        Theme.of(context).primaryColorLight,
        Colors.red,
      ],
      pageRoute: MaterialPageRoute(
        builder: (context) => const Login(),
      ),
      nextButton: Text(
        "Next",
        style: TextStyle(
          color: Theme.of(context).primaryColorLight,
        ),
      ),
      lastButton: Text(
        "Get Started",
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
      skipButton: Text(
        "Skip",
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
      selectedDotColor: Theme.of(context).secondaryHeaderColor,
      unSelectdDotColor: Theme.of(context).shadowColor,
    );
  }
}
