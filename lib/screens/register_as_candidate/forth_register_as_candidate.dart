import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _formKey = GlobalKey<FormState>();
  final List<int> nominees = [1];
  Map<String, String> organizations = {};

  // Create maps to store controllers for each nominee
  final Map<int, TextEditingController> nameControllers = {};
  final Map<int, TextEditingController> emailControllers = {};
  final Map<int, TextEditingController> phoneControllers = {};
  final Map<int, TextEditingController> reasonControllers = {};
  final Map<int, String?> selectedOrgIds = {};

  @override
  void dispose() {
    nameControllers.values.forEach((controller) => controller.dispose());
    emailControllers.values.forEach((controller) => controller.dispose());
    phoneControllers.values.forEach((controller) => controller.dispose());
    reasonControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _initializeControllersForNominee(int index) {
    nameControllers[index] = TextEditingController();
    emailControllers[index] = TextEditingController();
    phoneControllers[index] = TextEditingController();
    reasonControllers[index] = TextEditingController();
    selectedOrgIds[index] = null;
    print('DEBUG: Initialized controllers for nominee $index');
  }

  void onAddNominee(int index) {
    final nominee = NomineeData(
      name: nameControllers[index]!.text,
      email: emailControllers[index]!.text,
      phone: phoneControllers[index]!.text,
      reason: reasonControllers[index]!.text,
      organization: selectedOrgIds[index] ?? '',
    );

    final registrationState =
        Provider.of<RegistrationState>(context, listen: false);
    registrationState.addNominee(nominee);
  }

  @override
  void initState() {
    super.initState();
    // Initialize controllers for the first nominee
    _initializeControllersForNominee(1);
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
          organizations = Map.fromEntries(data.map((org) =>
              MapEntry(org['org_id'].toString(), org['org_name'].toString())));
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
                                    onChanged: (value) {
                                      nameControllers[index]!.text =
                                          value ?? '';
                                    },
                                    controller: nameControllers[index],
                                  ),
                                  FormTextfield(
                                    keyboardType: TextInputType.emailAddress,
                                    labelText: 'Email',
                                    hintText: 'xxx@gmail.com',
                                    validator: (email) {
                                      if (email == null ||
                                          !email.contains('@')) {
                                        return "Enter a valid email address";
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      emailControllers[index]!.text =
                                          value ?? '';
                                    },
                                    controller: emailControllers[index],
                                  ),
                                  FormTextfield(
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(11),
                                    ],
                                    labelText: 'Phone Number',
                                    hintText:
                                        'Phone Number (11 digits, No space or dash-)',
                                    validator: (String? number) {
                                      if (number == null || number.isEmpty) {
                                        return "Enter a valid phone number";
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      phoneControllers[index]!.text =
                                          value ?? '';
                                    },
                                    controller: phoneControllers[index],
                                  ),
                                  DropdownBtn(
                                    labelText: 'Organization',
                                    value: selectedOrgIds[index],
                                    items: organizations.entries
                                        .map((org) => DropdownMenuItem(
                                            value: org.key,
                                            child: Text(org.value)))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedOrgIds[index] = value as String;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Select an organization";
                                      }
                                      return null;
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
                                    onChanged: (value) {
                                      reasonControllers[index]!.text =
                                          value ?? '';
                                    },
                                    controller: reasonControllers[index],
                                  ),
                                ],
                              ))
                          .toList(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              int newIndex = nominees.length + 1;
                              nominees.add(newIndex);
                              _initializeControllersForNominee(newIndex);
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedBtn(
            btnText: 'Back',
            hasSize: false,
            btnColorWhite: false,
            width: 160,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedBtn(
            btnText: 'Save',
            hasSize: false,
            width: 160,
            onPressed: () async {
              try {
                if (_formKey.currentState?.validate() ?? false) {
                  for (int index in nominees) {
                    onAddNominee(index);
                  }
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return const Center(child: CircularProgressIndicator());
                    },
                  );

                  final registrationState =
                      Provider.of<RegistrationState>(context, listen: false);
                  await registrationState.submitNominationData();

                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          const Text('Nominee information saved successfully!'),
                      backgroundColor: Theme.of(context).focusColor,
                    ),
                  );
                  Navigator.pushNamed(
                      context, RouteList.registerCandidateFifth);
                }
              } catch (e) {
                Navigator.of(context).pop();
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
