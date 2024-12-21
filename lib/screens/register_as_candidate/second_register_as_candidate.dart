import 'package:flutter/material.dart';

import '../../routes/route.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/top_bar.dart';
import 'step_icon.dart';

class RegisterCandidateSecond extends StatefulWidget {
  const RegisterCandidateSecond({super.key});

  @override
  State<RegisterCandidateSecond> createState() =>
      _RegisterCandidateSecondState();
}

class _RegisterCandidateSecondState extends State<RegisterCandidateSecond> {
  String? selectedOption;
  final _formKey = GlobalKey<FormState>();
  final List<int> nominees = [1]; // Start with one nominee

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
              activeIndex: 1,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Nomination Infomation',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Generate nominee fields dynamically
                    ...nominees
                        .map((index) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nominee ${index}',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: 'Email',
                                    labelStyle:
                                        Theme.of(context).textTheme.labelSmall,
                                    hintText: 'xxx@gmail.com',
                                    hintStyle:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                  validator: (String? email) {
                                    if (email == null ||
                                        !email.contains('@') ||
                                        email.isEmpty) {
                                      return "Enter a valid email address";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    setState(() {});
                                  },
                                ),
                                const SizedBox(height: 30),
                                TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 5,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: 'Reason',
                                    labelStyle:
                                        Theme.of(context).textTheme.labelSmall,
                                    hintText: 'Enter your reason',
                                    hintStyle:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                  validator: (String? reason) {
                                    if (reason == null || reason.isEmpty) {
                                      return "Enter a valid reason";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    setState(() {});
                                  },
                                ),
                                const SizedBox(height: 20),
                              ],
                            ))
                        .toList(),

                    // Add nominee button
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            nominees.add(nominees.length + 1);
                          });
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Nominee'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomBtn(),
          ],
        ),
      ),
    );
  }

  Widget bottomBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedBtn(
              btnText: 'Back',
              hasSize: false,
              btnColorWhite: false,
              width: 160,
              onPressed: () {
                Navigator.of(context).pop(context);
              },
            ),
            ElevatedBtn(
              btnText: 'Next',
              hasSize: false,
              width: 160,
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
          ],
        ),
      ),
    );
  }
}
