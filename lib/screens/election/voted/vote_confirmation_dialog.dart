import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import '../../../widgets/elevated_button.dart';

class VoteConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const VoteConfirmationDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  Future<void> _authenticateAndConfirm(BuildContext context) async {
    final LocalAuthentication auth = LocalAuthentication();
    try {
      bool isAuthenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to confirm your vote',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (isAuthenticated) {
        onConfirm();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).hintColor,
            content: Text('Authentication failed',
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).hintColor,
          content: Text('Error during authentication: $e',
              style: Theme.of(context).textTheme.bodyMedium),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).dialogBackgroundColor,
            textStyle: Theme.of(context).textTheme.bodyLarge,
          ),
          child: const Text('Cancel'),
        ),
        ElevatedBtn(
          onPressed: () => _authenticateAndConfirm(context),
          btnText: 'Confirm',
          hasSize: false,
        ),
      ],
    );
  }
}
