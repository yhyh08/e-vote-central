import 'package:flutter/material.dart';

class TitleBtn extends StatelessWidget {
  final String leftText;
  final String leftText1;
  final bool left;
  final String rightText;
  final void Function() onTap;

  const TitleBtn({
    required this.leftText,
    this.leftText1 = '',
    this.left = true,
    required this.rightText,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: [
          Row(
            children: [
              (left)
                  ? Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            leftText,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    )
                  : Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            leftText,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            leftText1,
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        ],
                      ),
                    ),
              Expanded(
                child: GestureDetector(
                  onTap: onTap,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      rightText,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
