import 'package:flutter/material.dart';

import '../../../gen/assets.gen.dart';
import '../../../routes/route.dart';

class Homeheader extends StatelessWidget {
  final String username;

  const Homeheader({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 180,
        padding: const EdgeInsets.only(top: 30),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.images.backImage.image().image,
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
          color: Theme.of(context).primaryColorDark,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to SUC service',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        username,
                        style: Theme.of(context).textTheme.headlineLarge,
                      )
                    ],
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.account_circle_rounded,
                      size: 28,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(RouteList.account);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
