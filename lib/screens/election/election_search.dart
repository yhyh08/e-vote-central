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

class ElectionSearch extends StatefulWidget {
  const ElectionSearch({super.key});

  @override
  ElectionSearchState createState() => ElectionSearchState();
}

class ElectionSearchState extends State<ElectionSearch> {
  DateTime now = DateTime.now();
  // String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

  @override
  Widget build(BuildContext context) {
    return const TopBar(
      text: 'ElectionSearch',
      index: 1,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // https://www.youtube.com/watch?v=ZHdg2kfKmjI
            StandardSearchAnchor(
              searchBar: StandardSearchBar(
                bgColor: Color.fromARGB(255, 218, 211, 211),
              ),
              suggestions: StandardSuggestions(
                suggestions: [
                  StandardSuggestion(text: 'Suggestion 1'),
                  StandardSuggestion(text: 'Suggestion 2'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
