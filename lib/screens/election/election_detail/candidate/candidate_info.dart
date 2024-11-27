import 'package:flutter/material.dart';

import '../../../../routes/route.dart';

class CandidateInfo extends StatelessWidget {
  final String title;
  final String content;
  final bool isDetail;

  const CandidateInfo({
    super.key,
    required this.title,
    required this.content,
    this.isDetail = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              isDetail
                  ? const SizedBox()
                  : GestureDetector(
                      child: Text(
                        'View More',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onTap: () => Navigator.of(context)
                          .pushNamed(RouteList.candidateProfileDetail),
                    ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            maxLines: isDetail ? 50 : 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
