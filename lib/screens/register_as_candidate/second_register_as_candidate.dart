import 'package:flutter/material.dart';

import '../../routes/route.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/form_textfield.dart';
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      ...nominees
                          .map((index) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nominee $index',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 10),
                                  FormTextfield(
                                    keyboardType: TextInputType.emailAddress,
                                    labelText: 'Email',
                                    hintText: 'xxx@gmail.com',
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
                                  FormTextfield(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    labelText: 'Reason',
                                    hintText: 'Enter your reason',
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
                                ],
                              ))
                          .toList(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              nominees.add(nominees.length + 1);
                            });
                          },
                          icon: const Icon(Icons.add),
                          label: Text(
                            'Add Nominee',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor:
                                Theme.of(context).primaryColorLight,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                if (_formKey.currentState?.validate() ?? false) {
                  Navigator.of(context)
                      .pushNamed(RouteList.registerCandidateThird);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please fill out all fields before proceeding.',
                        style: Theme.of(context).textTheme.bodyLarge,
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
