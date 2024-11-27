import 'package:flutter/material.dart';

class DisElevatedBtn extends StatelessWidget {
  final void Function() onPressed;
  final String btnText;
  final bool isBtnClick;
  final bool hasSize;

  const DisElevatedBtn({
    required this.onPressed,
    required this.btnText,
    this.isBtnClick = false,
    this.hasSize = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return hasSize
        ? ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColorLight,
              side: BorderSide(
                width: 1,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Text(
              btnText,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF7A1CAC),
                  ),
            ),
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColorLight,
              side: BorderSide(
                width: 1,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Text(
              btnText,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF7A1CAC),
                  ),
            ),
          );
  }
}
