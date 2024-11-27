import 'package:e_vote/widgets/elevated_button.dart';
import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';
import '../../routes/route.dart';
import '../../widgets/top_bar.dart';

class RegisterStatus extends StatefulWidget {
  const RegisterStatus({super.key});

  @override
  RegisterStatusState createState() => RegisterStatusState();
}

class RegisterStatusState extends State<RegisterStatus> {
  @override
  Widget build(BuildContext context) {
    return TopBar(
      title: 'Register as Candidate',
      index: 3,
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    'Register Status',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                ListTile(
                  leading: Image(
                    image: Assets.images.logo.image().image,
                    width: 70,
                  ),
                  title: Text(
                    'Election 5',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  subtitle: Text(
                    '1 day ago',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).splashColor,
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      side: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: null,
                    child: Text(
                      'Pending',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: Align(
              alignment: Alignment.bottomRight,
              child: ElevatedBtn(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(RouteList.registerCandidateFirst);
                },
                btnText: 'Register New',
                hasSize: false,
                width: 180,
              ),
            ),
          )
        ],
      ),
    );
  }
}
