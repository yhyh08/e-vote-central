import 'package:flutter/material.dart';

import '../../models/result_list.dart';
import '../../widgets/result_listtile.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/top_bar.dart';

class Result extends StatefulWidget {
  const Result({super.key});

  @override
  ResultState createState() => ResultState();
}

class ResultState extends State<Result> {
  List<ResultList> filteredData = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => afterBuildFunction(context));
  }

  Future<void> afterBuildFunction(BuildContext context) async {
    setState(() {
      filteredData = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TopBar(
      title: 'Result',
      index: 2,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
            child: SearchCol(
              onChanged: (String searchText) {
                debugPrint(searchText);
                setState(
                  () {
                    filteredData = results
                        .where((data) => data.resultTitle
                            .toLowerCase()
                            .contains(searchText.toLowerCase()))
                        .toList();
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              'Elections',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                return ResultListTile(result: filteredData[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
