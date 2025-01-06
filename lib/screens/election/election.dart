import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../gen/assets.gen.dart';
import '../../models/election_data.dart';
import '../../network_utlis/api_constant.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/top_bar.dart';
import 'election_detail/election_detail.dart';
import '../../utils/malaysia_time.dart';

class Election extends StatefulWidget {
  const Election({super.key});

  @override
  ElectionState createState() => ElectionState();
}

class ElectionState extends State<Election> {
  List<ElectionData> electionData = [];
  List<ElectionData> filteredData = [];
  int selectedSegment = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => afterBuildFunction(context));
    fetchElections();
  }

  Future<void> fetchElections() async {
    try {
      final response =
          await http.get(Uri.parse('$serverApiUrl/all-elections/'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          electionData = data.map((e) {
            String title = e['election_topic'] ?? 'Election Title';
            DateTime startDate = e['start_date'] != null
                ? DateTime.parse(e['start_date'])
                : DateTime.now();
            DateTime endDate = e['end_date'] != null
                ? DateTime.parse(e['end_date'])
                : DateTime.now();
            int id = e['election_id'] ?? e['id'] ?? 0;
            int orgId = e['org_id'] ?? 0;

            return ElectionData(title, startDate, endDate, orgId, id);
          }).toList();
          updateFilteredData();
        });
      } else {
        throw Exception('Failed to load elections');
      }
    } catch (e) {
      print('Error fetching elections: $e');
    }
  }

  void updateFilteredData() {
    DateTime now = MalaysiaTime.now();
    print('Current time: $now');

    setState(() {
      if (selectedSegment == 1) {
        filteredData = electionData
            .where((e) => e.endDate.isAfter(now) && e.startDate.isBefore(now))
            .toList();
      } else if (selectedSegment == 2) {
        filteredData =
            electionData.where((e) => e.startDate.isAfter(now)).toList();
      }
    });
  }

  Future<void> afterBuildFunction(BuildContext context) async {
    setState(() {
      filteredData = electionData;
    });
  }

  final DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TopBar(
      title: 'Election',
      index: 1,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customSliding(),
            SearchCol(
              onChanged: (String searchText) {
                debugPrint(searchText);
                setState(
                  () {
                    filteredData = electionData
                        .where((data) => data.title
                            .toLowerCase()
                            .contains(searchText.toLowerCase()))
                        .toList();
                  },
                );
              },
            ),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.2,
                crossAxisCount: 1,
                mainAxisSpacing: 10,
              ),
              itemCount: filteredData.length,
              itemBuilder: (BuildContext context, int index) {
                return electionCard(filteredData[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget customSliding() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: CustomSlidingSegmentedControl<int>(
        initialValue: selectedSegment,
        fixedWidth: 150,
        children: {
          1: Text(
            'Ongoing',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          2: Text(
            'Upcoming',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        },
        decoration: BoxDecoration(
          color: CupertinoColors.lightBackgroundGray,
          borderRadius: BorderRadius.circular(5),
        ),
        thumbDecoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.3),
              blurRadius: 4.0,
              spreadRadius: 1.0,
              offset: const Offset(0.0, 2.0),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInToLinear,
        onValueChanged: (v) {
          setState(() {
            selectedSegment = v;
            updateFilteredData();
          });
        },
      ),
    );
  }

  Widget electionCard(ElectionData data) {
    String formattedStartDate =
        DateFormat('dd/MM/yy , hh:mm a').format(data.startDate);
    String formattedEndDate =
        DateFormat('dd/MM/yy , hh:mm a').format(data.endDate);

    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5.0),
                topRight: Radius.circular(5.0),
              ),
              child: Image(
                image: Assets.images.voteday.image().image,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      data.title,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColorLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        print('Election Data: ${data.title}, ID: ${data.id}');
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ElectionDetail(
                              electionId: data.id,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'View More',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, bottom: 15),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    color: Theme.of(context).iconTheme.color,
                    size: 18,
                  ),
                  Text(
                    '$formattedStartDate - $formattedEndDate',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
