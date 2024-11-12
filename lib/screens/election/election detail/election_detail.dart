import 'package:e_vote/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
            tabBar(),
          ],
        ),
      ),
    );
  }

  Widget top() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Image(
        image: Assets.images.voteday.image().image,
        // width: 400,
        // height: 150,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget topText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: Assets.images.voteday.image().image,
          width: 50,
        ),
        Column(
          children: [
            Text(
              " Sign up",
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Row(
              children: <Widget>[
                Text("Plantations"),
                Icon(Icons.favorite),
              ],
            ),
          ],
        ),
      ],
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
