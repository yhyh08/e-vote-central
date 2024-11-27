import 'package:flutter/material.dart';

import '../../../gen/assets.gen.dart';
import '../../../routes/route.dart';
import '../../../widgets/elevated_button.dart';
import '../../../models/candidate_card.dart';

class ElectionPosition extends StatefulWidget {
  final CandidateDetail candidate;

  const ElectionPosition({
    super.key,
    required this.candidate,
  });

  @override
  State<ElectionPosition> createState() => _ElectionPositionState();
}

class _ElectionPositionState extends State<ElectionPosition> {
  bool hasVoted = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 310,
        padding: const EdgeInsets.all(15),
        child: Card(
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
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                    ),
                    child: Image(
                      image: Assets.images.voteday1.image().image,
                      height: 85,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 55,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: widget.candidate.candidateImage,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.candidate.name,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.candidate.role,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          const SizedBox(height: 5),
                          RichText(
                            text: TextSpan(
                              children: [
                                const WidgetSpan(
                                  child: Icon(
                                    Icons.location_on,
                                    size: 16,
                                  ),
                                ),
                                TextSpan(
                                  text: widget.candidate.address,
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          viewVoteBtn()
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
    );
  }

  Widget viewVoteBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedBtn(
          btnText: 'View Profile',
          hasSize: false,
          onPressed: () {
            Navigator.of(context).pushNamed(RouteList.candidateProfile);
          },
        ),
        const SizedBox(width: 10),
        ElevatedBtn(
          btnText: hasVoted ? 'Voted' : 'Vote',
          hasSize: false,
          btnColorWhite: false,
          onPressed: hasVoted
              ? () {}
              : () {
                  setState(() {
                    hasVoted = !hasVoted;
                  });
                  // Implement voting functionality

                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(
                  //     content: Text('${'widget.user.name'} marked as voted'),
                  //   ),
                  // );
                },
        ),
      ],
    );
  }
}
