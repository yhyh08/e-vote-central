import 'package:flutter/material.dart';

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
          onPressed: onConfirm,
          btnText: 'Confirm',
          hasSize: false,
        ),
      ],
    );
  }
}
