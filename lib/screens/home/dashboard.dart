import 'package:e_vote/models/result_list.dart';
import 'package:e_vote/network_utlis/api.dart';
import 'package:e_vote/widgets/result_listtile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../gen/assets.gen.dart';
import '../../widgets/title_btn.dart';
import '../../../widgets/bottom_navigation.dart';
import 'home_header.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  String _userInfo = '';
  String? _phoneNumber;
  final Network _network = Network();

  @override
  void initState() {
    super.initState();
    _initializeUserInfo();
  }

  Future<void> _initializeUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    _phoneNumber = localStorage.getString('user_phone');
    if (_phoneNumber != null) {
      await _loadUserInfo();
    } else {
      print('No phone number found in storage.');
    }
  }

  Future<void> _loadUserInfo() async {
    try {
      if (_phoneNumber != null) {
        final userInfo = await _network.getUserInfo(_phoneNumber!);
        setState(() {
          _userInfo = userInfo['name'] ?? 'Guest';
        });
      }
    } catch (e) {
      print('Error loading user info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      bottomNavigationBar: const BottomNavigation(currentIndex: 0),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Homeheader(
              username: _userInfo,
            ),
            TitleBtn(
              leftText: 'Update Profile Information',
              leftText1: 'For future voting',
              left: false,
              rightText: 'Update',
              onTap: () {
                // Navigator.of(context).pushNamed(RouteList.register);
              },
            ),
            const Divider(),
            Column(
              children: [
                TitleBtn(
                  leftText: 'Latest Election',
                  rightText: 'See More',
                  onTap: () {
                    // Navigator.of(context).pushNamed(RouteList.register);
                  },
                ),
                latestElec(),
                const SizedBox(height: 10),
                TitleBtn(
                  leftText: 'Result',
                  rightText: 'See More',
                  onTap: () {
                    // Navigator.of(context).pushNamed(RouteList.register);
                  },
                ),
                resultList(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget latestElec() {
    return Center(
      child: Container(
        width: 350,
        height: 180,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorDark,
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: Assets.images.voteday1.image().image,
            opacity: 0.5,
            fit: BoxFit.cover,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            // Navigator.of(context).pushReplacementNamed(RouteList.register);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    '2024 General Election: Your Voice, Your Choice',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.arrow_circle_right_outlined,
                      color: Theme.of(context).splashColor,
                      size: 30,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget resultList() {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: 2,
          itemBuilder: (context, index) {
            return ResultListTile(result: results[index]);
          },
        ),
      ],
    );
  }
}
