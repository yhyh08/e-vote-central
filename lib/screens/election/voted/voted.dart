import 'package:e_vote/widgets/elevated_button.dart';
import 'package:flutter/material.dart';

import '../../../../../widgets/top_bar.dart';
import '../../../gen/assets.gen.dart';

class Voted extends StatefulWidget {
  const Voted({
    super.key,
  });

  @override
  VotedState createState() => VotedState();
}

class VotedState extends State<Voted> {
  @override
  Widget build(BuildContext context) {
    return TopBar(
      title: 'Election Detail',
      index: 1,
      isBack: true,
      body: SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Image(
                image: Assets.images.voteSuccess1.image().image,
              ),
              const SizedBox(height: 20),
              Text(
                'Vote Success!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 30),
              Text(
                'Your vote has been successfully recorded.\n Thank you for voting!',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedBtn(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                btnText: 'View Election',
              )
            ],
          ),
        ),
      ),
    );
  }
}
