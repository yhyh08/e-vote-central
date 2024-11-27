import 'package:flutter/material.dart';

import '../../routes/route.dart';
import '../gen/assets.gen.dart';
import '../widgets/elevated_button.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          content(context),
        ],
      ),
    );
  }
}

Widget content(BuildContext context) {
  return Container(
    color: Theme.of(context).primaryColorLight,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    child: Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: Assets.images.logo.image().image,
                width: MediaQuery.of(context).size.width / 1.4,
              ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedBtn(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(RouteList.login);
              },
              btnText: 'Signin',
            ),
            const SizedBox(height: 20),
            // ElevatedBtn(
            //   onPressed: () {
            //     Navigator.of(context).pushReplacementNamed(RouteList.register);
            //   },
            //   btnText: 'Singup',
            //   btnColorWhite: false,
            // ),
          ],
        ),
      ],
    ),
  );
}
