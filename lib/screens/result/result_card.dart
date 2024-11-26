import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';
import '../../models/result.dart';

class ResultCard extends StatelessWidget {
  final CandidateResult candidate;

  const ResultCard({
    super.key,
    required this.candidate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).secondaryHeaderColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image(
                  image: Assets.images.voteday1.image().image,
                  height: 75,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 45),
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: candidate.image,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          candidate.name,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          candidate.role,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        const SizedBox(height: 5),
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(text: '${candidate.votes} ballot - '),
                              TextSpan(
                                text: '${candidate.percentage}%',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
