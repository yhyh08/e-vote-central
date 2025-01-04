import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../models/candidate_detail.dart';
import '../../../../routes/route.dart';
import '../../../../widgets/disable_elevated_button.dart';
import '../../../../widgets/top_bar.dart';
import '../../voted/vote_confirmation_dialog.dart';
import 'candidate_info.dart';
import 'info_row.dart';
import '../../../../providers/vote_provider.dart';

class CandidateProfile extends StatefulWidget {
  final CandidateDetail candidate;

  const CandidateProfile({
    super.key,
    required this.candidate,
  });

  @override
  CandidateProfileState createState() => CandidateProfileState();
}

class CandidateProfileState extends State<CandidateProfile> {
  @override
  Widget build(BuildContext context) {
    final voteProvider = Provider.of<VoteProvider>(context);
    final hasVoted = voteProvider.hasVotedFor(widget.candidate.id);
    final hasVotedPosition =
        voteProvider.hasVotedForPosition(widget.candidate.position);

    return TopBar(
      title: 'Candidate Profile',
      index: 1,
      isBack: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 230,
              child: Stack(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
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
                          backgroundImage: Assets.images.voteday.image().image,
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
                                widget.candidate.position,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              const SizedBox(height: 5),
                              socialBtn()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DisElevatedBtn(
                btnText: hasVoted
                    ? 'Voted'
                    : hasVotedPosition
                        ? 'Position Already Voted'
                        : 'Vote',
                onPressed: (hasVoted || hasVotedPosition)
                    ? () {}
                    : () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return VoteConfirmationDialog(
                              title: 'Vote',
                              message:
                                  'Are you sure you want to vote for ${widget.candidate.name} as ${widget.candidate.position}? You can only vote for one candidate per position.',
                              onConfirm: () async {
                                final scaffoldContext =
                                    ScaffoldMessenger.of(context);
                                final navigatorContext = Navigator.of(context);

                                try {
                                  navigatorContext.pop();

                                  await voteProvider.voteForCandidate(
                                    widget.candidate.id,
                                    widget.candidate.position,
                                  );

                                  if (!mounted) return;
                                  await navigatorContext
                                      .pushReplacementNamed(RouteList.voted);
                                } catch (e) {
                                  scaffoldContext.showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Failed to submit vote: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              onCancel: () {
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        );
                      },
              ),
            ),
            CandidateInfo(
              title: 'Short Biographys',
              content: widget.candidate.biography,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  InfoRow(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: widget.candidate.email,
                  ),
                  InfoRow(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: widget.candidate.phone,
                  ),
                  InfoRow(
                    icon: Icons.work,
                    label: 'Job',
                    value: widget.candidate.job,
                  ),
                  InfoRow(
                    icon: Icons.ac_unit,
                    label: 'Nationality',
                    value: widget.candidate.nationality,
                  ),
                  InfoRow(
                    icon: Icons.electric_bolt,
                    label: 'Religion',
                    value: widget.candidate.religion,
                  ),
                ],
              ),
            ),
            CandidateInfo(
              title: 'Election Manifesto',
              content: widget.candidate.manifesto,
            ),
          ],
        ),
      ),
    );
  }

  Widget socialBtn() {
    return Row(
      children: [
        GestureDetector(
          child: SvgPicture.asset(
            Assets.svg.facebook,
            color: Theme.of(context).highlightColor,
            width: 20,
          ),
          onTap: () {},
        ),
        const SizedBox(width: 10),
        GestureDetector(
          child: SvgPicture.asset(
            Assets.svg.whatsapp,
            color: Theme.of(context).highlightColor,
            width: 20,
          ),
          onTap: () {},
        ),
        const SizedBox(width: 10),
        GestureDetector(
          child: SvgPicture.asset(
            Assets.svg.telegram,
            color: Theme.of(context).highlightColor,
            width: 20,
          ),
          onTap: () {},
        ),
        const SizedBox(width: 10),
        GestureDetector(
          child: SvgPicture.asset(
            Assets.svg.instagram,
            color: Theme.of(context).highlightColor,
            width: 20,
          ),
          onTap: () {},
        ),
        const SizedBox(width: 10),
        GestureDetector(
          child: SvgPicture.asset(
            Assets.svg.linkedin,
            color: Theme.of(context).highlightColor,
            width: 20,
          ),
          onTap: () {},
        ),
      ],
    );
  }
}
