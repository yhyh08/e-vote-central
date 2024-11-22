import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../gen/assets.gen.dart';
import '../../../widgets/top_bar.dart';
import '../../../models/candidate_card.dart';
import 'election_info.dart';
import 'election_organization.dart';
import 'election_position.dart';

class ElectionDetail extends StatefulWidget {
  const ElectionDetail({super.key});

  @override
  ElectionDetailState createState() => ElectionDetailState();
}

class ElectionDetailState extends State<ElectionDetail>
    with SingleTickerProviderStateMixin {
  final DateTime now = DateTime.now();
  late TabController _tabController;
  final List<CandidateDetail> candidates = [
    CandidateDetail(
      name: 'Daniel Jackson',
      title: 'Software Engineer',
      address: '1789 North Street, San Antonio, TX 78201',
      candidateImage: Assets.images.voteday.image().image,
    ),
    CandidateDetail(
      name: 'Christina Eng',
      title: 'Teacher',
      address: '1789 North Street, San Antonio, TX 78201',
      candidateImage: Assets.images.voteday.image().image,
    ),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
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
    String formattedDate = DateFormat('dd/MM/yy , hh:mm a').format(now);

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '2024 General Election',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  'Election of the new Chairman',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      color: Theme.of(context).iconTheme.color,
                      size: 18,
                    ),
                    Text(
                      '$formattedDate - $formattedDate',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(wordSpacing: 0),
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
                    Text(
                      'Organization 1',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
