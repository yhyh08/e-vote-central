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
      height: MediaQuery.of(context).size.height / 3.9,
      alignment: Alignment.center,
      // decoration: BoxDecoration(
      //   // image: DecorationImage(
      //   //   image: Assets.backImage.image().image,
      //   //   fit: BoxFit.cover,
      //   //   opacity: 0.9,
      //   // ),
      //   color: Theme.of(context).primaryColorDark,
      //   borderRadius: const BorderRadius.only(
      //     bottomLeft: Radius.circular(25),
      //   ),
      // ),
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
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    descr,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            // Text(
            //   title,
            //   style: Theme.of(context).textTheme.displaySmall,
            // ),
            // const SizedBox(height: 10),
            // Text(
            //   descr,
            //   style: Theme.of(context).textTheme.titleSmall,
            // ),
          ],
        ),
      ),
    );
  }
}
