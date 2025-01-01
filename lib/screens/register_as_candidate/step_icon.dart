import 'package:flutter/material.dart';

class StepIcon extends StatelessWidget {
  final int activeIndex;

  const StepIcon({
    required this.activeIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          // Step 1
          stepIcon(Icons.how_to_vote_rounded, 0, context),
          stepDivider(context),

          // Step 2
          stepIcon(Icons.manage_accounts_outlined, 1, context),
          stepDivider(context),

          // Step 3
          stepIcon(Icons.person_2_outlined, 2, context),
          stepDivider(context),

          // Step 4
          stepIcon(Icons.file_upload_outlined, 3, context),
          stepDivider(context),

          // Step 5
          stepIcon(Icons.dangerous, 4, context),
          stepDivider(context),
        ],
      ),
    );
  }

  Widget stepIcon(IconData icon, int index, BuildContext context) {
    final bool isActive = index <= activeIndex;
    return CircleAvatar(
      radius: 20,
      backgroundColor: isActive
          ? Theme.of(context).primaryColor
          : Theme.of(context).primaryColorLight,
      child: Icon(
        icon,
        color: isActive
            ? Theme.of(context).secondaryHeaderColor
            : Theme.of(context).dialogBackgroundColor,
        size: 20,
      ),
    );
  }

  Widget stepDivider(BuildContext context) {
    return Expanded(
      child: Divider(
        thickness: 2,
        color: Theme.of(context).dividerColor,
      ),
    );
  }
}
