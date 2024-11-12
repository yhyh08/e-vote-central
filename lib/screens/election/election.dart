import 'package:e_vote/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:standard_searchbar/new/standard_search_anchor.dart';
import 'package:standard_searchbar/new/standard_search_bar.dart';
import 'package:standard_searchbar/new/standard_suggestion.dart';
import 'package:standard_searchbar/new/standard_suggestions.dart';
import 'package:intl/intl.dart';

import '../../gen/assets.gen.dart';
import '../../routes/route.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/title_btn.dart';
import '../../../widgets/bottom_navigation.dart';

class Election extends StatefulWidget {
  const Election({super.key});

  @override
  ElectionState createState() => ElectionState();
}

class ElectionState extends State<Election> {
  DateTime now = DateTime.now();
  // String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

  @override
  Widget build(BuildContext context) {
    return TopBar(
      text: 'Election',
      index: 1,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customSliding(),
            // https://www.youtube.com/watch?v=ZHdg2kfKmjI
            // const StandardSearchAnchor(
            //   searchBar: StandardSearchBar(
            //     bgColor: Color.fromARGB(255, 218, 211, 211),
            //   ),
            //   suggestions: StandardSuggestions(
            //     suggestions: [
            //       StandardSuggestion(text: 'Suggestion 1'),
            //       StandardSuggestion(text: 'Suggestion 2'),
            //     ],
            //   ),
            // ),
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(RouteList.electionSearch);
                },
                icon: Icon(
                  Icons.search_rounded,
                  color: Theme.of(context).primaryColorDark,
                )),
            electionCard(),
            a(),
          ],
        ),
      ),
    );
  }

  Widget customSliding() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
      child: CustomSlidingSegmentedControl<int>(
        initialValue: 1,
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.3),
              blurRadius: 4.0,
              spreadRadius: 1.0,
              offset: const Offset(
                0.0,
                2.0,
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInToLinear,
        onValueChanged: (v) {
          print(v);
        },
      ),
    );
  }

  Widget electionCard() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Image(
                  image: Assets.images.voteday.image().image,
                  // width: 400,
                  height: 150,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '2024 General Election: Your Voice, Your Choice',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'View More',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget a() {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: InkWell(
          onTap: () => print("ciao"),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
                child: Image.network('https://placeimg.com/640/480/any',
                    // width: 300,
                    height: 150,
                    fit: BoxFit.fill),
              ),
              ListTile(
                title: Text('Pub 1'),
                subtitle: Text('Location 1'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}