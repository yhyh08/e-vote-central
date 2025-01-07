import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../gen/assets.gen.dart';
import '../../routes/route.dart';
import '../../widgets/top_bar.dart';
import 'profile_list.dart';
import '../../providers/user_provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  Future<void> handleLogout(BuildContext context) async {
    try {
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Cancel',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: Text(
                  'Logout',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        },
      );

      if (confirm == true) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.signOut();

        if (!mounted) return;

        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteList.login,
          (Route<dynamic> route) => false,
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Signed out successfully'),
            backgroundColor: Theme.of(context).focusColor,
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign out: $e'),
          backgroundColor: Theme.of(context).hintColor,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return TopBar(
          title: "Profile",
          index: 4,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 200,
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
                              backgroundImage:
                                  Assets.images.voteday.image().image,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Consumer<UserProvider>(
                                    builder: (context, userProvider, child) {
                                      return Text(
                                        userProvider.username.isNotEmpty
                                            ? userProvider.username
                                            : 'Guest',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'user@user.com',
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
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
                          Navigator.of(context)
                              .pushNamed(RouteList.organization);
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
                        onTap: () => handleLogout(context),
                        isSignOut: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
