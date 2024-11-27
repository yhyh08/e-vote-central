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
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'First Nominee',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Email',
                      labelStyle: Theme.of(context).textTheme.labelLarge,
                      hintText: 'xxx@gmail.com',
                      hintStyle: Theme.of(context).textTheme.labelSmall,
                    ),
                    // controller: ,
                    validator: (String? number) {
                      if (number == null || number.isEmpty) {
                        return "Enter a valid email address";
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
                if (selectedOption != null) {
                  Navigator.of(context).pop(context);
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
