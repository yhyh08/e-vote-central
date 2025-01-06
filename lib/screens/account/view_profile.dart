import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';
import '../../widgets/top_bar.dart';
import 'profile_list.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return TopBar(
      title: 'Profile',
      index: 4,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 190,
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
                          backgroundImage: Assets.images.userlogo.image().image,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'User',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Software Engineer',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              const SizedBox(height: 5),
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
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  ProfileOption(
                    icon: Icons.person_outline,
                    title: 'Personal details',
                    onTap: () {
                      // Navigate to Personal Details page
                    },
                  ),
                  ProfileOption(
                    icon: Icons.apartment_outlined,
                    title: 'Organization',
                    onTap: () {
                      // Navigate to Organization page
                    },
                  ),
                  ProfileOption(
                    icon: Icons.language_outlined,
                    title: 'Languages',
                    onTap: () {
                      // Navigate to Languages page
                    },
                  ),
                  const Divider(),
                  ProfileOption(
                    icon: Icons.logout,
                    title: 'Sign Out',
                    onTap: () {
                      // Handle Sign Out
                    },
                    isSignOut: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
