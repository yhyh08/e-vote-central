import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/candidate_registration.dart';
import '../../network_utlis/api_constant.dart';
import '../../routes/route.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/top_bar.dart';

class RegisterStatus extends StatefulWidget {
  const RegisterStatus({super.key});

  @override
  RegisterStatusState createState() => RegisterStatusState();
}

class RegisterStatusState extends State<RegisterStatus> {
  bool isLoading = true;
  List<CandidateRegistration> registrations = [];

  @override
  void initState() {
    super.initState();
    fetchCandidatesByStatus('pending');
  }

  Future<void> fetchCandidatesByStatus(String status) async {
    setState(() => isLoading = true);
    try {
      String statusNumber = _getStatusNumber(status);

      final response = await http.get(
        Uri.parse('$serverApiUrl/candidate/status/$statusNumber'),
        headers: {
          'Authorization': 'Bearer ${await getToken()}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        List<CandidateRegistration> allCandidates = [];

        if (data['elections'] != null) {
          for (var election in data['elections']) {
            String electionTopic = election['election_topic'];
            if (election['candidates'] != null) {
              for (var candidate in election['candidates']) {
                allCandidates.add(CandidateRegistration(
                  id: candidate['id'],
                  electionTopic: electionTopic,
                  candName: candidate['name'] ?? 'Unknown Candidate',
                  status: candidate['status'] ?? 'Unknown Status',
                  createdAt: DateTime.parse(candidate['created_at']),
                ));
              }
            }
          }
        }

        setState(() {
          registrations = allCandidates;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load candidates');
      }
    } catch (e) {
      print('Error details: $e');
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  String _getStatusNumber(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return '1';
      case 'approved':
        return '2';
      case 'rejected':
        return '3';
      default:
        return '1';
    }
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return TopBar(
      title: 'Candidate Registrations',
      index: 3,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatusFilterButton('Pending', 'pending'),
                _buildStatusFilterButton('Approved', 'approved'),
                _buildStatusFilterButton('Rejected', 'rejected'),
              ],
            ),
          ),

          // Candidates List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : registrations.isEmpty
                    ? const Center(child: Text('No candidates found'))
                    : ListView.builder(
                        itemCount: registrations.length,
                        itemBuilder: (context, index) {
                          final registration = registrations[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: ListTile(
                              title: Text(
                                registration.electionTopic,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    registration.candName,
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                  Text(
                                    registration.formattedDate,
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                  const SizedBox(height: 8),
                                  StatusButton(status: registration.status),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          );
                        },
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

  Widget _buildStatusFilterButton(String label, String status) {
    return SizedBox(
      width: 105,
      child: ElevatedButton(
        onPressed: () => fetchCandidatesByStatus(status),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).secondaryHeaderColor,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}

class StatusButton extends StatelessWidget {
  final String status;

  const StatusButton({required this.status, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getStatusColor(status)),
      ),
      child: Text(
        status.toUpperCase(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _getStatusColor(status),
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
