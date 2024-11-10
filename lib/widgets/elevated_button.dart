import 'package:flutter/material.dart';

class ElevatedBtn extends StatelessWidget {
  final void Function() onPressed;
  final String btnText;
  final bool btnColorWhite;

  const ElevatedBtn({
    required this.onPressed,
    required this.btnText,
    this.btnColorWhite = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: (btnColorWhite)
            ? Theme.of(context).primaryColor
            : Theme.of(context).primaryColorLight,
        side: BorderSide(
            width: (btnColorWhite) ? 0 : 2, color: const Color(0xFF7A1CAC)),
        minimumSize: const Size.fromHeight(60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Text(
        btnText,
        style: (btnColorWhite)
            ? Theme.of(context).textTheme.bodyLarge
            : Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: const Color(0xFF7A1CAC)),
      ),
    );
  }
}
