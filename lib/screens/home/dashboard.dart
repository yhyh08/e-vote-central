import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_header.dart';
import '../trending.dart';
import '../../../widgets/bottom_navigation.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  var _userInfo = 'emptyUserInfo';
  String? username;

  // home screen show username
  Future<void> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String userInfo = prefs.getString('user_data') ?? '';

    dynamic userObj = jsonDecode(userInfo);
    username = userObj['response']['user']['username'];

    setState(() {
      _userInfo = username ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavigation(currentIndex: 0),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Homeheader(
                username: _userInfo,
              ),
              Trending(),
              const FindNearShop(),
              FindService(),
            ],
          ),
        ),
      ),
    );
  }
}
