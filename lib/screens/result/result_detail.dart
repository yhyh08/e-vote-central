import 'package:flutter/material.dart';

import '../../models/result.dart';
import '../../widgets/top_bar.dart';
import 'result_card.dart';

class ResultDetail extends StatefulWidget {
  const ResultDetail({super.key});

  @override
  ResultDetailState createState() => ResultDetailState();
}

class ResultDetailState extends State<ResultDetail> {
  @override
  Widget build(BuildContext context) {
    return TopBar(
      title: "Result",
      index: 3,
      isBack: true,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                children: [
                  Text(
                    "Election 5",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Candidates",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: candidates.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 3 / 4,
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
