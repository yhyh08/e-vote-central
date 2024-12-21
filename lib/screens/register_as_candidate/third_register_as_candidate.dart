import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:flutter/material.dart';

import '../../routes/route.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/form_textfield.dart';
import '../../widgets/top_bar.dart';
import 'step_icon.dart';

class RegisterCandidateThird extends StatefulWidget {
  const RegisterCandidateThird({super.key});

  @override
  State<RegisterCandidateThird> createState() => _RegisterCandidateThirdState();
}

class _RegisterCandidateThirdState extends State<RegisterCandidateThird> {
  String? selectedOption;
  final _formKey = GlobalKey<FormState>();
  TextEditingController state = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController city = TextEditingController();

  final List<String> electionOptions = [
    'State 1',
    'State 2',
    'State 3',
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
              activeIndex: 1,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Profile Infomation',
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
                      FormTextfield(
                        keyboardType: TextInputType.text,
                        labelText: 'First Name',
                        hintText: 'First Name',
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Enter a valid first name";
                          }
                          return null;
                        },
                        onSaved: (value) {},
                      ),
                      FormTextfield(
                        keyboardType: TextInputType.text,
                        labelText: 'Last Name',
                        hintText: 'Last Name',
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Enter a valid last name";
                          }
                          return null;
                        },
                        onSaved: (value) {},
                      ),
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
                        onSaved: (value) {},
                      ),
                      FormTextfield(
                        keyboardType: TextInputType.number,
                        labelText: 'Identification No',
                        hintText: 'I/C No',
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Enter a valid identification number";
                          }
                          return null;
                        },
                        onSaved: (value) {},
                      ),
                      FormTextfield(
                        keyboardType: TextInputType.phone,
                        labelText: 'Phone',
                        hintText: 'Phone',
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Enter a valid phone number";
                          }
                          return null;
                        },
                        onSaved: (value) {},
                      ),
                      FormTextfield(
                        keyboardType: TextInputType.text,
                        labelText: 'Address Line 1',
                        hintText: 'Address Line 1',
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Enter a valid address";
                          }
                          return null;
                        },
                        onSaved: (value) {},
                      ),
                      CountryStateCityPicker(
                        country: country,
                        state: state,
                        city: city,
                        dialogColor: Theme.of(context).shadowColor,
                        textFieldDecoration: InputDecoration(
                          fillColor: Theme.of(context).secondaryHeaderColor,
                          labelStyle: Theme.of(context).textTheme.displaySmall,
                          filled: true,
                          suffixIcon: const Icon(Icons.arrow_downward_rounded),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(width: 5),
                          ),
                        ),
                      ),
                      bottomBtn(),
                    ],
                  ),
                ),
              ),
            ),
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
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context)
                      .pushNamed(RouteList.registerCandidateForth);
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
