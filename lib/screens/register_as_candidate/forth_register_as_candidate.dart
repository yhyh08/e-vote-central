import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../../network_utlis/api_constant.dart';
import '../../providers/registration_state.dart';
import '../../routes/route.dart';
import '../../widgets/dropdown_btn.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/form_textfield.dart';
import '../../widgets/top_bar.dart';
import 'step_icon.dart';

class RegisterCandidateForth extends StatefulWidget {
  const RegisterCandidateForth({super.key});

  @override
  State<RegisterCandidateForth> createState() => _RegisterCandidateForthState();
}

class _RegisterCandidateForthState extends State<RegisterCandidateForth> {
  String? selectedOption;
  List<String> organizationOptions = [];
  final _formKey = GlobalKey<FormState>();
  final List<int> nominees = [1];
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController reasonController = TextEditingController();

  void onAddNominee() {
    final nominee = NomineeData(
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      reason: reasonController.text,
      organization: selectedOption ?? '',
    );

    final registrationState =
        Provider.of<RegistrationState>(context, listen: false);
    registrationState.addNominee(nominee);
  }

  @override
  void initState() {
    super.initState();
    fetchOrganizations();
  }

  Future<void> fetchOrganizations() async {
    try {
      final response = await http.get(
        Uri.parse('$serverApiUrl/all-organizations'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          organizationOptions =
              data.map((org) => org['org_name'].toString()).toList();
        });
      } else {
        throw Exception('Failed to load organizations');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error loading organizations: $e',
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
            const StepIcon(
              activeIndex: 3,
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
                                    keyboardType: TextInputType.text,
                                    labelText: 'Name',
                                    hintText: 'Enter your name',
                                    validator: (String? name) {
                                      if (name == null || name.isEmpty) {
                                        return "Enter your name";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      setState(() {
                                        nameController.text = value ?? '';
                                      });
                                    },
                                    controller: nameController,
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
                                    onSaved: (value) {
                                      setState(() {
                                        emailController.text = value ?? '';
                                      });
                                    },
                                  ),
                                  FormTextfield(
                                    keyboardType: TextInputType.phone,
                                    labelText: 'Phone',
                                    hintText: '+60xxxxxxxxx',
                                    validator: (String? number) {
                                      if (number == null || number.isEmpty) {
                                        return "Enter a valid phone number";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      setState(() {
                                        phoneController.text = value ?? '';
                                      });
                                    },
                                    controller: phoneController,
                                  ),
                                  DropdownBtn(
                                    labelText: 'Organization',
                                    value: selectedOption,
                                    items: organizationOptions
                                        .map(
                                          (option) => DropdownMenuItem(
                                              value: option,
                                              child: Text(option)),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedOption = value as String;
                                      });
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
                                      setState(() {
                                        reasonController.text = value ?? '';
                                      });
                                    },
                                    controller: reasonController,
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
            ElevatedBtn(
              btnText: 'Back',
              hasSize: false,
              btnColorWhite: false,
              width: 160,
              onPressed: () => Navigator.of(context).pop(),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ElevatedBtn(
                btnText: 'Save',
                hasSize: false,
                btnColorWhite: false,
                width: 150,
                onPressed: () async {
                  try {
                    if (_formKey.currentState?.validate() ?? false) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      );

                      onAddNominee(); // Save to state first
                      final registrationState = Provider.of<RegistrationState>(
                          context,
                          listen: false);
                      await registrationState.saveStep4Data();

                      Navigator.of(context).pop(); // Close loading dialog

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Nominee information saved successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pushNamed(
                          context, RouteList.registerCandidateFifth);
                    }
                  } catch (e) {
                    Navigator.of(context).pop(); // Close loading dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${e.toString()}'),
                        backgroundColor: Theme.of(context).hintColor,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(width: 16),
              ElevatedBtn(
                btnText: 'Next',
                hasSize: false,
                width: 150,
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    onAddNominee();
                    Navigator.pushNamed(
                        context, RouteList.registerCandidateFifth);
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
        ],
      ),
    );
  }
}
