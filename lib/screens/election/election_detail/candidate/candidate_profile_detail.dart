import 'package:flutter/material.dart';

import '../../../../widgets/top_bar.dart';
import '../election_organization.dart';
import 'candidate_info.dart';
import 'info_row.dart';

class CandidateProfileDetail extends StatefulWidget {
  const CandidateProfileDetail({
    super.key,
  });

  @override
  CandidateProfileDetailState createState() => CandidateProfileDetailState();
}

class CandidateProfileDetailState extends State<CandidateProfileDetail> {
  @override
  Widget build(BuildContext context) {
    return TopBar(
      title: 'Candidate Profile',
      index: 1,
      isBack: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CandidateInfo(
              title: 'Short Biographys',
              content:
                  'Daniel Jackson is a dedicated software engineer with 11 years of experience in the tech industry. As a strong advocate',
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  InfoRow(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: 'daniel@gmail.com',
                  ),
                  SizedBox(height: 5),
                  InfoRow(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: '+6019-2345678',
                  ),
                  SizedBox(height: 5),
                  InfoRow(
                    icon: Icons.work_outline,
                    label: '10+ years of experience',
                    value: 'SoftShift',
                  ),
                ],
              ),
            ),
            ElectionOrganization(),
            const CandidateInfo(
              title: 'Election Manifesto',
              content:
                  'Our vision is to create a transparent, efficient, and inclusive society where technology empowers every citizen. We commit to enhancing',
            ),
          ],
        ),
      ),
    );
  }
}
