import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../widgets/elevated_button.dart';
import '../../../../widgets/top_bar.dart';
import 'candidate_info.dart';
import 'info_row.dart';

class CandidateProfile extends StatefulWidget {
  // final CandidateDetail candidate;

  const CandidateProfile({
    super.key,
    // required this.candidate,
  });

  @override
  CandidateProfileState createState() => CandidateProfileState();
}

class CandidateProfileState extends State<CandidateProfile> {
  @override
  Widget build(BuildContext context) {
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
                                'widget.candidate.name',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                ' widget.candidate.role',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              const SizedBox(height: 5),
                              Row(
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
                                ],
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedBtn(
                onPressed: () {},
                btnColorWhite: false,
                btnText: 'Vote',
              ),
            ),
            const CandidateInfo(
              title: "Short Biographys",
              content:
                  "Daniel Jackson is a dedicated software engineer with 11 years of experience in the tech industry. As a strong advocate for innovation and digital...",
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  InfoRow(
                    icon: Icons.email_outlined,
                    label: "Email",
                    value: "daniel@gmail.com",
                  ),
                  SizedBox(height: 5),
                  InfoRow(
                    icon: Icons.phone_outlined,
                    label: "Phone",
                    value: "+6019-2345678",
                  ),
                  SizedBox(height: 5),
                  InfoRow(
                    icon: Icons.work_outline,
                    label: "10+ years of experience",
                    value: "SoftShift",
                  ),
                ],
              ),
            ),
            const CandidateInfo(
              title: "Election Manifesto",
              content:
                  "Our vision is to create a transparent, efficient, and inclusive society where technology empowers every citizen. We commit to enhancing public services...",
            ),
          ],
        ),
      ),
    );
  }
}
