import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/result.dart';
import '../../models/result_list.dart';
import '../../network_utlis/api_constant.dart';
import '../../widgets/top_bar.dart';
import 'result_card.dart';

class ResultDetail extends StatefulWidget {
  const ResultDetail({super.key});

  @override
  ResultDetailState createState() => ResultDetailState();
}

class ResultDetailState extends State<ResultDetail> {
  List<CandidateResult> candidates = [];
  bool isLoading = true;
  ResultList? electionData;

  @override
  void initState() {
    super.initState();
    debugPrint('ResultDetail initState called');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get the arguments here
    final args = ModalRoute.of(context)?.settings.arguments;
    debugPrint(
        'didChangeDependencies - Received arguments type: ${args.runtimeType}');

    if (args is ResultList && electionData == null) {
      debugPrint('Processing arguments - Election Topic: ${args.resultTitle}');
      debugPrint('Processing arguments - Election ID: ${args.electionId}');

      setState(() {
        electionData = args;
      });
      fetchCandidateResults();
    } else if (electionData == null) {
      debugPrint('Invalid or missing arguments');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchCandidateResults() async {
    if (electionData == null) {
      debugPrint('No election data available');
      return;
    }

    debugPrint('Fetching results for election: ${electionData?.resultTitle}');
    try {
      final response = await http.get(
        Uri.parse('$serverApiUrl/election/results'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        debugPrint('API Response received');

        final List<dynamic> electionsList = jsonData['elections'] ?? [];
        final election = electionsList.firstWhere(
          (e) => e['election_id'] == electionData?.electionId,
          orElse: () => null,
        );

        if (election != null) {
          debugPrint('Found matching election');
          final Map<String, dynamic> groupedCandidates =
              election['grouped_candidates'] as Map<String, dynamic>;
          final allCandidates = <CandidateResult>[];

          groupedCandidates.forEach((position, candidatesList) {
            final List<dynamic> candidates = candidatesList as List<dynamic>;
            for (var candidate in candidates) {
              allCandidates.add(CandidateResult.fromJson(candidate, position));
            }
          });

          setState(() {
            candidates = allCandidates;
            isLoading = false;
          });
          debugPrint('Loaded ${candidates.length} candidates');
        } else {
          debugPrint('No matching election found');
          setState(() => isLoading = false);
        }
      }
    } catch (e) {
      debugPrint('Error fetching candidate results: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TopBar(
      title: "Result",
      index: 2,
      isBack: true,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    electionData?.resultTitle ?? 'Election Results',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Candidates List",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      itemCount: candidates.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 3.5 / 5,
                      ),
                      itemBuilder: (context, index) {
                        final candidate = candidates[index];
                        return ResultCard(candidate: candidate);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
