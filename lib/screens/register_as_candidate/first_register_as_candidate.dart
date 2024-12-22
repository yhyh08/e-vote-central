import 'package:flutter/material.dart';

import '../../routes/route.dart';
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

  final List<String> electionOptions = [
    'Election 1',
    'Election 2',
    'Election 3',
  ];

  @override
  Widget build(BuildContext context) {
    return TopBar(
      title: 'Register as Candidate',
      index: 3,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const StepIcon(
              activeIndex: 0,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Election Information',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Election',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              value: selectedOption,
              items: electionOptions
                  .map(
                    (option) => DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                });
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Align(
                alignment: Alignment.bottomRight,
                child: ElevatedBtn(
                  btnText: 'Next',
                  hasSize: false,
                  width: 180,
                  onPressed: () {
                    if (selectedOption != null) {
                      Navigator.of(context)
                          .pushNamed(RouteList.registerCandidateThird);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Please select an election.',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
