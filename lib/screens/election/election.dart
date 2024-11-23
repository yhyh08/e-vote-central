import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';

import '../../gen/assets.gen.dart';
import '../../routes/route.dart';
import '../../widgets/top_bar.dart';

class Election extends StatefulWidget {
  const Election({super.key});

  @override
  ElectionState createState() => ElectionState();
}

class ElectionState extends State<Election> {
  List<DataSample> electionData = [
    DataSample('2024 General Election: Your Voice, Your Choice'),
    DataSample('Shape Tomorrow: Cast Your Vote!'),
    DataSample('2024 Election: Defining Our Nation Next Chapter'),
  ];
  List<DataSample> filteredData = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => afterBuildFunction(context));
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
            // searchBar(),
            SearchBar(
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
          print(v);
        },
      ),
    );
  }

  // Widget searchBar() {
  //   return Column(
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //         child: TextField(
  //           style: TextStyle(color: Theme.of(context).primaryColorDark),
  //           cursorColor: Theme.of(context).primaryColor,
  //           decoration: InputDecoration(
  //             suffixIcon: Icon(
  //               Icons.search_rounded,
  //               color: Theme.of(context).dialogBackgroundColor,
  //             ),
  //             hintText: 'Search...',
  //             hintStyle: Theme.of(context).textTheme.bodyMedium,
  //             focusedBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(7.0),
  //               borderSide: BorderSide(
  //                 color: Theme.of(context).primaryColor,
  //               ),
  //             ),
  //             enabledBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(7.0),
  //               borderSide: BorderSide(
  //                 color: Theme.of(context).dividerColor,
  //               ),
  //             ),
  //           ),
  //           onChanged: (String searchText) {
  //             debugPrint(searchText);
  //             setState(
  //               () {
  //                 filteredData = electionData
  //                     .where((data) => data.title
  //                         .toLowerCase()
  //                         .contains(searchText.toLowerCase()))
  //                     .toList();
  //               },
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget electionCard(DataSample data) {
    String formattedDate = DateFormat('dd/MM/yy , hh:mm a').format(now);

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
                        Navigator.of(context)
                            .pushNamed(RouteList.electionDetail);
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
                    '$formattedDate - $formattedDate',
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

class DataSample {
  DataSample(
    this.title,
  );

  final String title;
}
