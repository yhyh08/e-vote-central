import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../gen/assets.gen.dart';
import '../../models/result_list.dart';
import 'result_detail.dart';

class ResultListTile extends StatelessWidget {
  final ResultList result;

  const ResultListTile({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Image(
            image: Assets.images.logo.image().image,
            width: 70,
          ),
          title: Text(
            result.resultTitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          subtitle: Text(
            '${DateFormat('dd/MM/yyyy').format(result.startDate)} - ${DateFormat('dd/MM/yyyy').format(result.endDate)}',
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ResultDetail(),
                  settings: RouteSettings(
                    arguments: result,
                  ),
                ),
              );
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
