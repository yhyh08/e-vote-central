import 'package:flutter/material.dart';

import '../../routes/route.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/top_bar.dart';
import 'step_icon.dart';

class RegisterCandidateForth extends StatefulWidget {
  const RegisterCandidateForth({super.key});

  @override
  State<RegisterCandidateForth> createState() => _RegisterCandidateForthState();
}

class _RegisterCandidateForthState extends State<RegisterCandidateForth> {
  String? selectedOption;
  final _formKey = GlobalKey<FormState>();

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
              activeIndex: 3,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Submit Information',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Phone',
                      labelStyle: Theme.of(context).textTheme.labelLarge,
                      hintText: '+60xxxxxxxxx',
                      hintStyle: Theme.of(context).textTheme.labelSmall,
                    ),
                    // controller: ,
                    validator: (String? number) {
                      if (number == null || number.isEmpty) {
                        return "Enter a valid phone number";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {});
                    },
                  ),
                ],
              ),
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
                      // Navigator.of(context)
                      //     .pushNamed(RouteList.registerCandidateForth);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Please select ',
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
