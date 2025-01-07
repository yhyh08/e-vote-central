import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/organization_data.dart';
import '../../network_utlis/api_constant.dart';
import '../../widgets/top_bar.dart';
import 'organization_add.dart';
import 'organization_card.dart';
import 'organization_form.dart';

class Organization extends StatefulWidget {
  const Organization({super.key});

  @override
  State<Organization> createState() => _OrganizationState();
}

class _OrganizationState extends State<Organization> {
  List<OrganizationData> organizationData = [];
  bool isLoading = true;
  List<String> organizationNames = [];

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

      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Raw data from API: $data'); // Debug print

        setState(() {
          organizationData = data
              .map((json) {
                try {
                  return OrganizationData.fromJson(json);
                } catch (e) {
                  print('Error parsing organization: $e');
                  print('Problematic JSON: $json');
                  return null;
                }
              })
              .whereType<OrganizationData>()
              .toList();

          isLoading = false;
        });
      } else {
        throw Exception('Failed to load organizations');
      }
    } catch (e) {
      print('Error fetching organizations: $e');
      print('Stack trace: ${StackTrace.current}');
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
                      itemCount: organizationData.length + 1,
                      itemBuilder: (context, index) {
                        if (index < organizationData.length) {
                          return OrganizationCard(
                            organization: organizationData[index],
                          );
                        } else {
                          return AddOrganizationCard(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const OrganizationForm(),
                                ),
                              );
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
