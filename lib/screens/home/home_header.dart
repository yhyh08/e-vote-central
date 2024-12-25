import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../../../routes/route.dart';

class Homeheader extends StatelessWidget {
  final String username;

  const Homeheader({
    Key? key,
    required this.username,
  }) : super(key: key);

  Future<void> _handleLogout(BuildContext context) async {
    try {
      bool confirm = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return dialog(context);
            },
          ) ??
          false;

      if (confirm) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        if (context.mounted) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(RouteList.login, (route) => false);
        }

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Logged out successfully'),
              backgroundColor: Theme.of(context).focusColor,
            ),
          );
        }
      }
    } catch (e) {
      print('Error during logout: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error logging out'),
            backgroundColor: Theme.of(context).hintColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).secondaryHeaderColor,
      child: Container(
        height: 180,
        padding: const EdgeInsets.only(top: 30),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.account_circle_rounded,
                      size: 50,
                    ),
                    onPressed: () {
                      // Navigator.of(context).pushNamed(RouteList.account);
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to E-Vote',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        username,
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(color: Colors.white),
                      )
                    ],
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(
                          Icons.logout,
                          size: 28,
                        ),
                        onPressed: () => _handleLogout(context),
                      ),
                      // Icons.notifications_none_outlined,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dialog(BuildContext context) {
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
  }
}
