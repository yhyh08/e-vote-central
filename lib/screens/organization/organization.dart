import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/organization.dart';
import '../../network_utlis/api_constant.dart';
import '../../widgets/top_bar.dart';
import 'organization_add.dart';
import 'organization_card.dart';

class Organization extends StatefulWidget {
  const Organization({super.key});

  @override
  State<Organization> createState() => _OrganizationState();
}

class _OrganizationState extends State<Organization> {
  List<OrganizationData> organizations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrganizations();
  }

  Future<void> fetchOrganizations() async {
    try {
      final response = await http.get(
        Uri.parse('$serverApiUrl/all-organizations'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          organizations =
              data.map((json) => OrganizationData.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load organizations');
      }
    } catch (e) {
      print('Error fetching organizations: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TopBar(
      title: 'Organization',
      index: 4,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Organization',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 9 / 10,
                      ),
                      itemCount: organizations.length + 1,
                      itemBuilder: (context, index) {
                        if (index < organizations.length) {
                          return OrganizationCard(
                            organization: organizations[index],
                          );
                        } else {
                          return AddOrganizationCard(
                            onTap: () {
                              // Handle add organization logic
                            },
                          );
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
