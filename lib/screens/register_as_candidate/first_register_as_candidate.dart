import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../../network_utlis/api_constant.dart';
import '../../providers/registration_state.dart';
import '../../routes/route.dart';
import '../../widgets/dropdown_btn.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/top_bar.dart';
import 'step_icon.dart';

class RegisterCandidateFirst extends StatefulWidget {
  const RegisterCandidateFirst({super.key});

  @override
  State<RegisterCandidateFirst> createState() => _RegisterCandidateFirstState();
}

class _RegisterCandidateFirstState extends State<RegisterCandidateFirst> {
  String? selectedOption;
  String? selectedElectionId;
  List<String> electionOptions = [];
  Map<String, String> electionIds = {};

  @override
  void initState() {
    super.initState();
    fetchElectionTopics();
  }

  Future<void> fetchElectionTopics() async {
    try {
      final response =
          await http.get(Uri.parse('$serverApiUrl/all-elections/'));
      print('Raw API Response: ${response.body}'); // Print raw response

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Decoded data: $data');

        setState(() {
          electionOptions.clear();
          electionIds.clear();

          for (var election in data) {
            print(
                'Processing election: $election'); // Print each election object

            String topic = election['election_topic']?.toString() ?? '';
            String id = election['election_id']?.toString() ??
                election['id']?.toString() ??
                '';

            print(
                'Extracted - Topic: $topic, ID: $id'); // Print extracted values

            if (topic.isNotEmpty) {
              electionOptions.add(topic);
              electionIds[topic] = id;
            }
          }

          print('Final electionOptions: $electionOptions');
          print('Final electionIds: $electionIds');
        });
      }
    } catch (e) {
      print('Error in fetchElectionTopics: $e');
    }
  }

  void onElectionSelected(String electionId) {
    final registrationState =
        Provider.of<RegistrationState>(context, listen: false);
    registrationState.setSelectedElectionId(electionId);
    print('Selected Election ID: $electionId');
  }

  Future<void> saveElectionData() async {
    try {
      if (selectedOption == null || selectedElectionId == null) {
        throw Exception('Please select an election');
      }

      final registrationState =
          Provider.of<RegistrationState>(context, listen: false);
      await registrationState.saveStep1Data(selectedElectionId!);

      final response = await http.post(
        Uri.parse('$serverApiUrl/candidates'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'election_id': selectedElectionId,
          'position': selectedOption,
          'status': 'pending',
          'user_id': '2', // You should get this from user authentication
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Election data saved successfully!',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushNamed(context, RouteList.registerCandidateSecond);
      } else {
        throw Exception('Failed to save election data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error saving election data: $e',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          backgroundColor: Theme.of(context).hintColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TopBar(
      title: 'Register as Candidate',
      index: 3,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const StepIcon(activeIndex: 0),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Election Information',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 24),
            DropdownBtn(
              labelText: 'Election',
              value: selectedOption,
              items: electionOptions
                  .map((option) => DropdownMenuItem(
                        value: option,
                        child: Text(
                          option,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                print(
                    'Dropdown value changed to: $value'); // Debug selected value
                print(
                    'Current electionIds map: $electionIds'); // Debug map content

                setState(() {
                  selectedOption = value;
                  if (value != null) {
                    selectedElectionId = electionIds[value];
                    Provider.of<RegistrationState>(context, listen: false)
                        .setSelectedElectionId(selectedElectionId);
                  }
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Select an election";
                }
                return null;
              },
            ),
            const Spacer(),
            bottomBtn()
          ],
        ),
      ),
    );
  }

  Widget bottomBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedBtn(
            btnText: 'Next',
            hasSize: false,
            width: 160,
            onPressed: () async {
              try {
                if (selectedOption != null && selectedElectionId != null) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return const Center(child: CircularProgressIndicator());
                    },
                  );

                  final registrationState =
                      Provider.of<RegistrationState>(context, listen: false);

                  registrationState.setElectionId(selectedElectionId);
                  await registrationState.saveStep1Data(selectedElectionId!);

                  Navigator.of(context).pop();

                  Navigator.pushNamed(
                      context, RouteList.registerCandidateSecond);
                } else {
                  // Show error if no selection made
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select an election option'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } catch (e) {
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${e.toString()}'),
                    backgroundColor: Theme.of(context).hintColor,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
