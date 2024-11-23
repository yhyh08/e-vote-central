import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';
import '../../models/result.dart';
import '../../widgets/top_bar.dart';

class ResultDetail extends StatefulWidget {
  const ResultDetail({super.key});

  @override
  ResultDetailState createState() => ResultDetailState();
}

class ResultDetailState extends State<ResultDetail> {
  List<Candidate> candidates = [
    Candidate(
      name: "Daniel Chengi",
      role: "Software Engineer",
      image: Assets.images.voteday1.image().image,
      votes: 250,
      percentage: 83,
    ),
    Candidate(
      name: "Taylor Selene",
      role: "Software Engineer",
      image: Assets.images.voteday1.image().image,
      votes: 50,
      percentage: 17,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return TopBar(
      title: "Result",
      index: 3,
      body:

          //   actions: [
          //     IconButton(
          //       icon: Icon(Icons.notifications),
          //       onPressed: () {
          //         // Handle notifications
          //       },
          //     ),
          //   ],
          // ),
          // body:
          Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Election Title
                Text(
                  "Election 5",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 16.0),

                // Candidates Section
                Text(
                  "Candidates",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 16.0),

                // Candidate Cards
                Expanded(
                  child: GridView.builder(
                    itemCount: candidates.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 3 / 4, // Adjust for proper card size
                    ),
                    itemBuilder: (context, index) {
                      final candidate = candidates[index];
                      return CandidateCard(candidate: candidate);
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Simulating dynamic state change
                setState(() {
                  candidates.add(
                    Candidate(
                      name: "New Candidate",
                      role: "Data Scientist",
                      image: Assets.images.voteday1.image().image,
                      votes: 100,
                      percentage: 50,
                    ),
                  );
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                "Add Candidate",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CandidateCard extends StatelessWidget {
  final Candidate candidate;

  const CandidateCard({super.key, required this.candidate});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40.0,
            backgroundImage: candidate.image,
          ),
          const SizedBox(height: 8),
          Text(
            candidate.name,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Text(
            candidate.role,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "${candidate.votes} ballot • ${candidate.percentage}%",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
