import 'package:flutter/material.dart';

class ElectionInfo extends StatefulWidget {
  const ElectionInfo({super.key});

  @override
  ElectionInfoState createState() => ElectionInfoState();
}

class ElectionInfoState extends State<ElectionInfo> {
  final String description =
      "Aute aute esse velit ullamco mollit irure ad sunt amet magna. Dolore dolor sunt pariatur ipsum adipisicing amet anim. Excepteur";

  final List<Map<String, dynamic>> generalInfo = [
    {
      "icon": Icons.language,
      "label": "Website",
      "value": "AI Logix.com",
      "isLink": true,
    },
    {
      "icon": Icons.email,
      "label": "Email",
      "value": "AI Logix.com",
      "isLink": true,
    },
    {
      "icon": Icons.business,
      "label": "Industry",
      "value": "Aute aute fugiat qui sunt eius",
      "isLink": false,
    },
    {
      "icon": Icons.people,
      "label": "Size",
      "value": "51,344 employees",
      "isLink": false,
    },
    {
      "icon": Icons.location_city,
      "label": "Company",
      "value": "Aute aute fugiat qui sunt eius",
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
            description,
            maxLines: 4,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Column(
            children: generalInfo.map((info) {
              return InfoTile(
                icon: info['icon'],
                label: info['label'],
                value: info['value'],
                isLink: info['isLink'],
                onTap: info['isLink']
                    ? () {
                        // Example action for clickable items
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${info['label']} clicked!"),
                          ),
                        );
                      }
                    : null,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLink;
  final VoidCallback? onTap;

  const InfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.isLink = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).iconTheme.color,
            size: Theme.of(context).iconTheme.size,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF4F4F4F),
                      ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: isLink
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).dialogBackgroundColor,
                      decoration: isLink ? TextDecoration.underline : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
