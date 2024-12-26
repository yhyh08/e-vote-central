import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../gen/assets.gen.dart';
import '../../../network_utlis/api_constant.dart';
import '../../../widgets/top_bar.dart';
import '../../../models/candidate_card.dart';
import 'election_info.dart';
import 'election_organization.dart';
import 'election_position.dart';

class ElectionDetail extends StatefulWidget {
  final int electionId;
  const ElectionDetail({
    super.key,
    required this.electionId,
  });

  @override
  ElectionDetailState createState() => ElectionDetailState();
}

class ElectionDetailState extends State<ElectionDetail>
    with SingleTickerProviderStateMixin {
  final DateTime now = DateTime.now();
  late TabController _tabController;
  Map<String, dynamic> electionDetail = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchElectionDetail(widget.electionId);
  }

  Future<void> fetchElectionDetail(int electionId) async {
    try {
      if (electionId <= 0) throw Exception('Invalid election ID');

      final response = await http.get(
        Uri.parse('$serverApiUrl/election-info/$electionId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          electionDetail = json.decode(response.body);
        });
      } else {
        throw Exception(
            'Failed to load election details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching election details: $e');
      // Consider showing an error message to the user
      setState(() {
        electionDetail = {'error': e.toString()};
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TopBar(
      title: 'Election Detail',
      index: 1,
      isBack: true,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            top(),
            topText(),
            const Divider(),
            TabBar(
              unselectedLabelColor: Theme.of(context).primaryColorDark,
              labelColor: Theme.of(context).hintColor,
              tabs: [
                Tab(
                  child: Text(
                    'Info',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Tab(
                  child: Text(
                    'Organization',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Tab(
                  child: Text(
                    'Position',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  const ElectionInfo(),
                  ElectionOrganization(),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: candidates.length,
                    itemBuilder: (context, index) {
                      return ElectionPosition(candidate: candidates[index]);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget top() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image(
            image: Assets.images.voteday1.image().image,
            height: 120,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Widget topText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      child: Row(
        children: [
          Image(
            image: Assets.images.voteday.image().image,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    electionDetail['election_topic']?.toString() ??
                        'Loading...',
                    style: Theme.of(context).textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    electionDetail['description']?.toString() ?? 'Loading...',
                    style: Theme.of(context).textTheme.labelSmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        color: Theme.of(context).iconTheme.color,
                        size: 18,
                      ),
                      Expanded(
                        child: Text(
                          _formatDateRange(
                            electionDetail['start_date']?.toString(),
                            electionDetail['end_date']?.toString(),
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(wordSpacing: 0),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.apartment_rounded,
                        color: Theme.of(context).iconTheme.color,
                        size: 18,
                      ),
                      Expanded(
                        child: Text(
                          electionDetail['organization_name']?.toString() ??
                              'Loading...',
                          style: Theme.of(context).textTheme.labelSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateRange(String? startDate, String? endDate) {
    if (startDate == null || endDate == null) return 'Dates not available';

    try {
      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate);
      final formatter = DateFormat('dd/MM/yyyy');
      return '${formatter.format(start)} - ${formatter.format(end)}';
    } catch (e) {
      print('Error formatting dates: $e');
      return '$startDate - $endDate';
    }
  }
}
