import 'package:flutter/material.dart';

import '../models/result_list.dart';
import '../routes/route.dart';

class ResultListTile extends StatelessWidget {
  final ResultList result;

  const ResultListTile({
    required this.result,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Image(
            image: result.resultImage,
            width: 70,
          ),
          title: Text(
            result.resultTitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          subtitle: Text(
            result.resultPassDay,
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
            onPressed: () {
              Navigator.of(context).pushNamed(RouteList.resultDetail);
            },
            child: Text(
              'View',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
