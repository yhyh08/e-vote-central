import 'package:flutter/material.dart';

class WCFormTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final String descr;
  final String? boldText;
  final String? descr2;

  const WCFormTitle({
    required this.title,
    required this.subtitle,
    required this.descr,
    this.boldText,
    this.descr2,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 45),
                    child: Text(
                      subtitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: descr,
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: <TextSpan>[
                        TextSpan(
                          text: boldText,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        TextSpan(
                          text: descr2,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
