import 'package:flutter/material.dart';

import '../../../gen/assets.gen.dart';
import '../../../routes/route.dart';
import '../../../widgets/disable_elevated_button.dart';
import '../../../widgets/elevated_button.dart';
import '../../../models/candidate_card.dart';
import '../voted/vote_confirmation_dialog.dart';

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
            print(widget.candidate);
            Navigator.of(context).pushNamed(
              RouteList.candidateProfile,
              arguments: widget.candidate,
            );
          },
        ),
        const SizedBox(width: 10),
        DisElevatedBtn(
          btnText: hasVoted ? 'Voted' : 'Vote',
          hasSize: false,
          onPressed: hasVoted
              ? () {}
              : () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return VoteConfirmationDialog(
                        title: 'Vote',
                        message:
                            'Are you sure you want to vote for this candidate? This action cannot be undone.',
                        onConfirm: () {
                          Navigator.of(context).pop();
                          setState(() {
                            hasVoted = !hasVoted;
                          });
                          Navigator.of(context).pushNamed(RouteList.voted);
                        },
                        onCancel: () {
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  );

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
