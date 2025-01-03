import 'package:flutter/material.dart';

class ElevatedBtn extends StatelessWidget {
  final void Function() onPressed;
  final String btnText;
  final double width;
  final bool btnColorWhite;
  final bool hasSize;

  const ElevatedBtn({
    required this.onPressed,
    required this.btnText,
    this.width = 130,
    this.btnColorWhite = true,
    this.hasSize = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return hasSize
        ? ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: (btnColorWhite)
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).secondaryHeaderColor,
              side: BorderSide(
                  width: (btnColorWhite) ? 0 : 2,
                  color: const Color(0xFF7A1CAC)),
              minimumSize: const Size.fromHeight(55),
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
          )
        : SizedBox(
            width: width,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: (btnColorWhite)
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).primaryColorLight,
                side: BorderSide(
                    width: (btnColorWhite) ? 0 : 2,
                    color: const Color(0xFF7A1CAC)),
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
            ),
          );
  }
}
