import 'package:e_vote/network_utlis/api_constant.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../models/result_list.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/top_bar.dart';
import 'result_listtile.dart';

class Result extends StatefulWidget {
  const Result({super.key});

  @override
  ResultState createState() => ResultState();
}

class ResultState extends State<Result> {
  List<ResultList> filteredData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchElectionResults();
  }

  Future<void> fetchElectionResults() async {
    try {
      final response = await http.get(
        Uri.parse('$serverApiUrl/election/results'),
      );

      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> electionsList = jsonData['elections'] ?? [];

        setState(() {
          filteredData =
              electionsList.map((data) => ResultList.fromJson(data)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load election results');
      }
    } catch (e) {
      debugPrint('Error fetching results: $e');
      setState(() => isLoading = false);
    }
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
                    filteredData = filteredData
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
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
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
