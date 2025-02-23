import 'package:flutter/material.dart';

import '../../../gen/assets.gen.dart';
import '../../../routes/route.dart';
import '../../../widgets/elevated_button.dart';
import '../../../models/candidate_detail.dart';

class ElectionPosition extends StatelessWidget {
  final List<CandidateDetail> candidates;
  final String organizationName;

  const ElectionPosition({
    Key? key,
    required this.candidates,
    required this.organizationName,
  }) : super(key: key);

  Map<String, List<CandidateDetail>> _groupPosition() {
    final grouped = <String, List<CandidateDetail>>{};
    for (var candidate in candidates) {
      if (!grouped.containsKey(candidate.position)) {
        grouped[candidate.position] = [];
      }
      grouped[candidate.position]!.add(candidate);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupeCandidates = _groupPosition();

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: groupeCandidates.length,
        itemBuilder: (context, index) {
          final position = groupeCandidates.keys.elementAt(index);
          final positionCandidates = groupeCandidates[position]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  position,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: positionCandidates.length,
                itemBuilder: (context, idx) {
                  final candidate = positionCandidates[idx];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: 85,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              image: DecorationImage(
                                image: Assets.images.voteday1.image().image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundImage:
                                          Assets.images.userlogo.image().image,
                                      // NetworkImage(
                                      //   '$serverApiUrl/images/${candidate.image}',
                                      // ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            candidate.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall,
                                          ),
                                          Text(
                                            candidate.email,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          Text(
                                            candidate.gender,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                viewVoteBtn(context, candidate),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget viewVoteBtn(BuildContext context, CandidateDetail candidate) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      ElevatedBtn(
        btnText: 'View Profile',
        hasSize: false,
        width: MediaQuery.of(context).size.width / 1.25,
        onPressed: () {
          Navigator.of(context).pushNamed(
            RouteList.candidateProfile,
            arguments: candidate,
          );
        },
      ),
    ],
  );
}
