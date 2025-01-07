import 'package:flutter/material.dart';
import '../../models/organization_data.dart';
import 'organization_detail.dart';

class OrganizationCard extends StatelessWidget {
  final OrganizationData organization;

  const OrganizationCard({
    super.key,
    required this.organization,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrganizationDetail(
              organization: organization,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Theme.of(context).primaryColor,
                child: organization.imageUrl.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          organization.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.apartment_outlined,
                              color: Theme.of(context).secondaryHeaderColor,
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.apartment_outlined,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
              ),
              const Spacer(),
              Text(
                organization.name,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                organization.category,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Container(
                margin: const EdgeInsets.only(top: 8.0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  organization.isActive ? 'Active' : 'Inactive',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: organization.isActive
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.error,
                      ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
