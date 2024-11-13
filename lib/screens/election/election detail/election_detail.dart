import 'package:e_vote/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../gen/assets.gen.dart';
import '../../../routes/route.dart';
import '../../../widgets/elevated_button.dart';
import '../../../widgets/title_btn.dart';
import '../../../../widgets/bottom_navigation.dart';

class ElectionDetail extends StatefulWidget {
  const ElectionDetail({super.key});

  @override
  ElectionDetailState createState() => ElectionDetailState();
}

class ElectionDetailState extends State<ElectionDetail> {
  final DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TopBar(
      text: 'Election Detail',
      index: 1,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            top(),
            topText(),
            const Divider(),
            // tabBar(),
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
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

  Widget tabBar() {
    return const Column(
      children: [
        TabBar(
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.cloud_outlined),
            ),
            Tab(
              icon: Icon(Icons.beach_access_sharp),
            ),
            Tab(
              icon: Icon(Icons.brightness_5_sharp),
            ),
          ],
        ),
        TabBarView(
          children: <Widget>[
            Center(
              child: Text("It's cloudy here"),
            ),
            Center(
              child: Text("It's rainy here"),
            ),
            Center(
              child: Text("It's sunny here"),
            ),
          ],
        ),
      ],
    );
  }
}
