import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../gen/assets.gen.dart';
// import '../../models/result_list.dart';
import '../../models/result_list.dart';
import '../../network_utlis/api.dart';
import '../../network_utlis/api_constant.dart';
import '../../routes/route.dart';
import '../result/result_listtile.dart';
import '../../widgets/title_btn.dart';
import '../../../widgets/bottom_navigation.dart';
import '../election/election_detail/election_detail.dart';
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
  String _latestElectionTitle = 'Loading...';
  Map<String, dynamic> _latestElection = {};
  bool _isDisposed = false;
  List<ResultList> results = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeUserInfo();
    _fetchLatestElection();
    fetchElectionResults();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
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
        print('Fetching user info for phone: $_phoneNumber');
        final userInfo = await _network.getUserInfo(_phoneNumber!);
        print('User info response: $userInfo');

        if (mounted) {
          setState(() {
            _userInfo = userInfo['name'] ?? 'Guest';
          });
        }
        print('Username for this account: $_userInfo');
      }
    } catch (e) {
      print('Error loading user info: $e');
      if (mounted) {
        setState(() {
          _userInfo = 'Guest';
        });
      }
    }
  }

  Future<void> _fetchLatestElection() async {
    if (_isDisposed) return;
    try {
      final latestElection = await _network.getLatestElection();
      if (_isDisposed) return;
      if (mounted) {
        setState(() {
          _latestElection = latestElection;
          _latestElectionTitle =
              latestElection['election_topic'] ?? 'Election Topic';
        });
      }
    } catch (e) {
      if (_isDisposed) return;
      if (mounted) {
        setState(() {
          _latestElectionTitle = 'Error loading election';
          _latestElection = {};
        });
      }
    }
  }

  Future<void> fetchElectionResults() async {
    try {
      final response = await http.get(
        Uri.parse('$serverApiUrl/election/results'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> electionsList = jsonData['elections'] ?? [];

        setState(() {
          results = electionsList
              .map((data) => ResultList(
                    resultTitle: data['election_topic'] ?? '',
                    resultImage: null,
                    startDate: DateTime.parse(data['start_date'] ?? ''),
                    endDate: DateTime.parse(data['end_date'] ?? ''),
                    electionId: data['election_id'] ?? 0,
                  ))
              .toList();
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching results: $e');
      setState(() => isLoading = false);
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
              username: _userInfo.capitalize(),
            ),
            // TitleBtn(
            //   leftText: 'Update Profile Information',
            //   leftText1: 'For future voting',
            //   left: false,
            //   rightText: 'Update',
            //   onTap: () {
            //     // Navigator.of(context).pushNamed(RouteList.register);
            //   },
            // ),
            // const Divider(),
            Column(
              children: [
                TitleBtn(
                  leftText: 'Latest Election',
                  rightText: 'See More',
                  onTap: () {
                    Navigator.of(context).pushNamed(RouteList.election);
                  },
                ),
                latestElec(),
                const SizedBox(height: 10),
                TitleBtn(
                  leftText: 'Result',
                  rightText: 'See More',
                  onTap: () {
                    Navigator.of(context).pushNamed(RouteList.result);
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
            if (_latestElection.containsKey('election_id')) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ElectionDetail(
                    electionId: _latestElection['election_id'],
                  ),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    _latestElectionTitle,
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
          itemCount: results.length,
          itemBuilder: (context, index) {
            return ResultListTile(result: results[index]);
          },
        ),
      ],
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
