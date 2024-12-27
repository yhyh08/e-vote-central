import 'package:flutter/material.dart';

import '../../../models/election_organization.dart';

class ElectionOrganization extends StatelessWidget {
  ElectionOrganization({super.key});

  final List<Experience> experiences = [
    Experience(
      icon: Icons.flash_on,
      companyName: 'Marslab',
      position: 'Founder and CEO',
      duration: 'Oct 2022 - Present (7 mos)',
      skills: ['Managing', 'Strategic', 'Human Resource'],
    ),
    Experience(
      companyName: 'AOT',
      position: 'Founder',
      duration: 'Jun 2019 - Present (3 yrs 11 mos)',
      skills: ['Customer Relationship Management (CRM)'],
    ),
    Experience(
      companyName: 'Marslab',
      position: 'Founder',
      duration: 'Jun 2019 - Present (3 yrs 11 mos)',
      skills: ['Customer Relationship Management (CRM)'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Theme.of(context).secondaryHeaderColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '3+ Years of experience',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 20),
              Column(
                children: experiences.map((experience) {
                  return Column(
                    children: [
                      ExperienceTile(experience: experience),
                      Divider(thickness: 1, color: Colors.grey[300]),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExperienceTile extends StatelessWidget {
  final Experience experience;

  const ExperienceTile({super.key, required this.experience});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: experience.icon != null
              ? [
                  Icon(experience.icon, color: Colors.blue, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    experience.companyName,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ]
              : [
                  const SizedBox(width: 8),
                  Text(
                    experience.companyName,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
        ),
        const SizedBox(height: 8),
        Text(
          experience.position,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          experience.duration,
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: experience.skills
              .map((skill) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      skill,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
