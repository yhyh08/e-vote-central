import 'package:flutter/material.dart';

class ElectionInfo extends StatefulWidget {
  final String? description;
  final String? orgCat;
  final String? orgAddress;
  final String? orgWebsite;
  final String? orgEmail;
  final String? orgSize;

  const ElectionInfo({
    super.key,
    this.description,
    this.orgCat,
    this.orgAddress,
    this.orgWebsite,
    this.orgEmail,
    this.orgSize,
  });

  @override
  ElectionInfoState createState() => ElectionInfoState();
}

class ElectionInfoState extends State<ElectionInfo> {
  List<Map<String, dynamic>> get generalInfo => [
        {
          "icon": Icons.language,
          "label": "Website",
          "value": widget.orgWebsite ?? "No Website",
          "isLink": true,
        },
        {
          "icon": Icons.email,
          "label": "Email",
          "value": widget.orgEmail ?? "No Email",
          "isLink": true,
        },
        {
          "icon": Icons.business,
          "label": "Category",
          "value": widget.orgCat ?? "No Category",
          "isLink": false,
        },
        {
          "icon": Icons.people,
          "label": "Size",
          "value": widget.orgSize ?? "No Size",
          "isLink": false,
        },
        {
          "icon": Icons.location_city,
          "label": "Location",
          "value": widget.orgAddress ?? "No Address",
          "isLink": false,
        },
      ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "General Information",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 10),
          Text(
            widget.description ?? 'No description',
            maxLines: 4,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: generalInfo.length,
            itemBuilder: (context, index) {
              final info = generalInfo[index];
              return ListTile(
                leading: Icon(info['icon']),
                title: Text(info['label']),
                subtitle: Text(info['value']),
              );
            },
          ),
        ],
      ),
    );
  }
}
