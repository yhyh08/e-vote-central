import 'package:flutter/material.dart';

import '../../../gen/assets.gen.dart';
import '../../../models/candidate_card.dart';
import '../../../widgets/top_bar.dart';

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
      index: 2,
      isBack: true,
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            // Positioned(
            //   top: 55,
            //   left: 20,
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       CircleAvatar(
            //         radius: 35,
            //         backgroundImage: 'widget.candidate.candidateImage',
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.symmetric(vertical: 5),
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text(
            //               ' widget.candidate.name',
            //               style: Theme.of(context).textTheme.titleSmall,
            //             ),
            //             const SizedBox(height: 5),
            //             Text(
            //               'widget.candidate.titl'e,
            //               style: Theme.of(context).textTheme.labelSmall,
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: Assets.images.voteday.image().image,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Daniel Jackson",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Text(
                              "Software Engineer",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    // Social Media Icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.facebook, color: Colors.blue),
                          onPressed: () {
                            // Facebook action
                          },
                        ),
                        // IconButton(
                        //   icon: Icon(Icons.whatsapp, color: Colors.green),
                        //   onPressed: () {
                        //     // WhatsApp action
                        //   },
                        // ),
                        // IconButton(
                        //   icon: Icon(Icons.instagram, color: Colors.pink),
                        //   onPressed: () {
                        //     // Instagram action
                        //   },
                        // ),
                        // IconButton(
                        //   icon: Icon(Icons.linkedin, color: Colors.blue),
                        //   onPressed: () {
                        //     // LinkedIn action
                        //   },
                        // ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    // Vote Button
                    OutlinedButton(
                      onPressed: () {
                        // Vote action
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.purple),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        "Vote",
                        style: TextStyle(color: Colors.purple),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Short Biography Section
            SectionCard(
              title: "Short Biography",
              trailing: "View More",
              content:
                  "Daniel Jackson is a dedicated software engineer with 11 years of experience in the tech industry. As a strong advocate for innovation and digital...",
              icon: Icons.info_outline,
            ),
            const SizedBox(height: 16.0),

            // Email and Phone Section
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 2.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    InfoRow(
                      icon: Icons.email_outlined,
                      label: "Email",
                      value: "daniel@gmail.com",
                    ),
                    Divider(color: Colors.grey[300]),
                    InfoRow(
                      icon: Icons.phone_outlined,
                      label: "Phone",
                      value: "+6019-2345678",
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Experience Section
            SectionCard(
              title: "10+ years of experience",
              trailing: "",
              content: "SoftShift\n10 yrs 11 months",
              icon: Icons.work_outline,
            ),
            const SizedBox(height: 16.0),

            // Election Manifesto Section
            SectionCard(
              title: "Election Manifesto",
              trailing: "View More",
              content:
                  "Our vision is to create a transparent, efficient, and inclusive society where technology empowers every citizen. We commit to enhancing public services...",
              icon: Icons.description_outlined,
            ),
          ],
        ),
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final String title;
  final String trailing;
  final String content;
  final IconData icon;

  SectionCard({
    required this.title,
    required this.trailing,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: Colors.purple),
                    const SizedBox(width: 8.0),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (trailing.isNotEmpty)
                  Text(
                    trailing,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              content,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.purple),
        const SizedBox(width: 8.0),
        Text(
          "$label: ",
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }
}
