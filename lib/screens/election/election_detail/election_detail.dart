import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../gen/assets.gen.dart';
import '../../../network_utlis/api_constant.dart';
import '../../../common/constants/malaysia_time.dart';
import '../../../widgets/top_bar.dart';
import '../../../models/candidate_detail.dart';
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
  final DateTime now = MalaysiaTime.now();
  late TabController _tabController;
  Map<String, dynamic> electionDetail = {};
  Map<String, dynamic> organizationData = {};
  String organizationName = 'Loading...';
  String viewOrgan = '';
  List<CandidateDetail> candidates = [];
  bool isLoadingCandidates = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchElectionDetail();
    fetchOrganizationData(widget.electionId);
    fetchCandidates();
  }

  Future<void> _fetchElectionDetail() async {
    try {
      if (widget.electionId <= 0) throw Exception('Invalid election ID');

      final response = await http.get(
        Uri.parse('$serverApiUrl/election-info/${widget.electionId}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          electionDetail = data;
        });

        if (data['org_id'] != null) {
          await fetchOrganizationData(data['org_id']);
        }
      } else {
        throw Exception(
            'Failed to load election details: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        electionDetail = {'error': e.toString()};
      });
    }
  }

  Future<void> fetchOrganizationData(int orgId) async {
    try {
      final response = await http.get(
        Uri.parse('$serverApiUrl/organization-info/$orgId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final orgData = json.decode(response.body);
        setState(() {
          organizationData = orgData;
          organizationName = orgData['org_name'] ?? 'Unknown Organization';
          viewOrgan = organizationName;
        });
      } else {
        throw Exception('Failed to load organization');
      }
    } catch (e) {
      print('Error fetching organization: $e');
      setState(() {
        organizationName = 'Error loading organization';
        viewOrgan = organizationName;
      });
    }
  }

  Future<void> fetchCandidates() async {
    try {
      final response = await http.get(
        Uri.parse('$serverApiUrl/election-candidates/${widget.electionId}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> candidatesJson = responseData['candidates'] ?? [];

        setState(() {
          candidates = candidatesJson
              .map((json) => CandidateDetail.fromJson(json))
              .toList();
          isLoadingCandidates = false;
        });
      } else {
        throw Exception('Failed to load candidates');
      }
    } catch (e) {
      setState(() {
        isLoadingCandidates = false;
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
                  ElectionInfo(
                    description: electionDetail['description'],
                    orgCat: organizationData['org_cat'],
                    orgAddress: organizationData['org_address'],
                    orgWebsite: organizationData['org_website'],
                    orgEmail: organizationData['org_email'],
                    orgSize: organizationData['org_size']?.toString(),
                  ),
                  ElectionOrganization(),
                  isLoadingCandidates
                      ? const Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : ElectionPosition(
                          candidates: candidates,
                          organizationName: viewOrgan,
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
                    _getElectionType(electionDetail['type']),
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
                          style: Theme.of(context).textTheme.labelSmall,
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
                          organizationName,
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
      return '$startDate - $endDate';
    }
  }

  String _getElectionType(dynamic type) {
    if (type == null) return 'Loading...';
    final typeValue = int.tryParse(type.toString());

    switch (typeValue) {
      case 1:
        return 'General Election';
      case 0:
        return 'Special Election';
      default:
        return 'Unknown Election Type';
    }
  }
}
