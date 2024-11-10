import 'package:flutter/material.dart';

import '../../routes/route.dart';
import '../gen/assets.gen.dart';

class WCFormTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final String descr;

  const WCFormTitle({
    required this.title,
    required this.subtitle,
    required this.descr,
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
                  Text(
                    descr,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
