import 'package:flutter/material.dart';

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isSignOut;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isSignOut = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSignOut
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).dialogBackgroundColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isSignOut
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).dialogBackgroundColor,
        ),
      ),
      trailing: isSignOut ? null : const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
