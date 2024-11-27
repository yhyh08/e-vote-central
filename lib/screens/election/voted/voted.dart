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
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Text('Voted'),
              Image(
                image: Assets.images.voteday1.image().image,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
