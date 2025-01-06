import 'package:country_state_city_pro/country_state_city_pro.dart';
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

class RegisterCandidateSecond extends StatefulWidget {
  const RegisterCandidateSecond({super.key});

  @override
  State<RegisterCandidateSecond> createState() =>
      _RegisterCandidateSecondState();
}

class _RegisterCandidateSecondState extends State<RegisterCandidateSecond> {
  final _formKey = GlobalKey<FormState>();
  String? selectedGender;
  String? selectedJobs;
  String? selectedReligion;
  String? selectedPosition;
  String? selectedIncome;
  String? selectedMaritalStatus;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController identificationNoController =
      TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController postcodeController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController country = TextEditingController();
  final TextEditingController city = TextEditingController();

  String? selectedElectionId;
  String? organizationId;

  final List<String> genderOptions = ['Male', 'Female'];
  List<String> positionOptions = [];
  final List<String> jobsOptions = [
    'Employee',
    'Self-Employed',
    'Student',
    'Unemployed',
  ];

  final List<String> religionOptions = [
    'Buddhism',
    'Islam',
    'Christianity',
    'Hinduism',
  ];

  final List<String> incomeOptions = [
    'Less than RM 1000',
    'RM 1000 - RM 2000',
    'RM 2000 - RM 3000',
    'RM 3000 - RM 4000',
    'RM 4000 - RM 5000',
    'Over RM 5000',
  ];
  final List<String> maritalStatusOptions = [
    'Single',
    'Married',
    'Divorced',
    'Widowed',
  ];

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final registrationState =
          Provider.of<RegistrationState>(context, listen: false);
      selectedElectionId = registrationState.selectedElectionId;
      print(
          'Selected Election ID from provider in Step 3: $selectedElectionId');
      fetchPositions();
      _isInitialized = true;
    }
  }

  Future<void> fetchPositions() async {
    try {
      if (selectedElectionId == null) {
        print('No election ID available for fetching positions');
        return;
      }

      print('Fetching positions for election ID: $selectedElectionId');
      final response = await http.get(
        Uri.parse('$serverApiUrl/all-elections/'),
      );

      print('Position API Response Status: ${response.statusCode}');
      print('Position API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> elections = json.decode(response.body);
        print('All elections: $elections');
        print('Looking for election with ID: $selectedElectionId');

        if (mounted) {
          setState(() {
            positionOptions.clear();

            final selectedElection = elections.firstWhere(
              (election) {
                final electionId = election['election_id']?.toString() ??
                    election['id']?.toString();
                return electionId == selectedElectionId;
              },
              orElse: () {
                return null;
              },
            );

            print('Selected election data: $selectedElection');

            if (selectedElection != null) {
              final position = selectedElection['position'];
              print('Position from election: $position');

              if (position != null) {
                if (position is String) {
                  positionOptions.add(position);
                } else if (position is List) {
                  positionOptions.addAll(position.map((p) => p.toString()));
                }
                print('Updated position options: $positionOptions');
              } else {
                print('Position is null in the election data');
              }
            }
          });
        }
      }
    } catch (e) {
      print('Error fetching positions: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading position: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    identificationNoController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    postcodeController.dispose();
    nationalityController.dispose();
    state.dispose();
    country.dispose();
    city.dispose();
    super.dispose();
  }

  void onSaveProfile() {
    if (selectedPosition == null || selectedPosition!.isEmpty) {
      throw Exception('Please select a position');
    }

    final profile = CandidateProfile(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      gender: selectedGender ?? '',
      email: emailController.text,
      identificationNo: identificationNoController.text,
      phone: phoneController.text,
      religion: selectedReligion ?? '',
      position: selectedPosition!,
      address: Address(
        line1: addressLine1Controller.text,
        line2: addressLine2Controller.text,
        city: city.text,
        state: state.text,
        country: country.text,
        postcode: postcodeController.text,
      ),
      nationality: nationalityController.text,
      jobStatus: selectedJobs ?? '',
      income: selectedIncome ?? '',
      maritalStatus: selectedMaritalStatus ?? '',
    );

    Provider.of<RegistrationState>(context, listen: false)
        .setCandidateProfile(profile);
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
            const StepIcon(activeIndex: 1),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Profile Information',
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
                      _buildFormFields(),
                      const SizedBox(height: 20),
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

  Widget _buildFormFields() {
    return Column(
      children: [
        FormTextfield(
          controller: firstNameController,
          keyboardType: TextInputType.text,
          labelText: 'First Name',
          hintText: 'First Name',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter a valid first name";
            }
            return null;
          },
        ),
        FormTextfield(
          controller: lastNameController,
          keyboardType: TextInputType.text,
          labelText: 'Last Name',
          hintText: 'Last Name',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter a valid last name";
            }
            return null;
          },
        ),
        DropdownBtn(
          labelText: 'Gender',
          value: selectedGender,
          items: genderOptions
              .map(
                (option) =>
                    DropdownMenuItem(value: option, child: Text(option)),
              )
              .toList(),
          onChanged: (value) => setState(() => selectedGender = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Select a gender";
            }
            return null;
          },
        ),
        FormTextfield(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          labelText: 'Email',
          hintText: 'xxx@gmail.com',
          validator: (email) {
            if (email == null || !email.contains('@') || email.isEmpty) {
              return "Enter a valid email address";
            }
            return null;
          },
        ),
        FormTextfield(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
          ],
          labelText: 'Phone Number',
          hintText: 'Phone Number (11 digits, No space or dash-)',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter a valid phone number";
            }

            return null;
          },
        ),
        FormTextfield(
          controller: identificationNoController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            LengthLimitingTextInputFormatter(12),
          ],
          labelText: 'Identification No',
          hintText: 'I/C No (12 digits, No space or dash-)',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter a valid identification number";
            }
            if (value.length != 12) {
              return "Identification number must be 12 digits";
            }
            return null;
          },
        ),
        CountryStateCityPicker(
          country: country,
          state: state,
          city: city,
          dialogColor: Theme.of(context).primaryColorLight,
          textFieldDecoration: InputDecoration(
            hintStyle: Theme.of(context).textTheme.bodyMedium,
            labelStyle: Theme.of(context).textTheme.bodyMedium,
            filled: true,
            suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
            border: const OutlineInputBorder(
              borderSide: BorderSide(width: 5),
            ),
          ),
        ),
        const SizedBox(height: 20),
        FormTextfield(
          controller: addressLine1Controller,
          keyboardType: TextInputType.text,
          labelText: 'Address Line 1',
          hintText: 'Address Line 1',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter a valid address";
            }
            return null;
          },
        ),
        FormTextfield(
          controller: addressLine2Controller,
          keyboardType: TextInputType.text,
          labelText: 'Address Line 2',
          hintText: 'Address Line 2',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter a valid address";
            }
            return null;
          },
        ),
        FormTextfield(
          controller: nationalityController,
          keyboardType: TextInputType.text,
          labelText: 'Nationality',
          hintText: 'Nationality',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter a valid nationality";
            }
            return null;
          },
        ),
        _buildDropdowns(),
        ElevatedBtn(
          btnText: 'Sign the form',
          btnColorWhite: false,
          onPressed: () {
            Navigator.of(context).pushNamed(RouteList.signatureCandidate);
          },
        ),
      ],
    );
  }

  Widget _buildDropdowns() {
    return Column(
      children: [
        DropdownBtn(
          labelText: 'Religion',
          value: selectedReligion,
          items: religionOptions
              .map(
                (option) =>
                    DropdownMenuItem(value: option, child: Text(option)),
              )
              .toList(),
          onChanged: (value) => setState(() => selectedReligion = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Select a religion";
            }
            return null;
          },
        ),
        DropdownBtn(
          labelText: 'Position',
          value: selectedPosition,
          items: positionOptions.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (String? newValue) {
            print('Selected position: $newValue');
            setState(() {
              selectedPosition = newValue;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Select a position";
            }
            return null;
          },
        ),
        DropdownBtn(
          labelText: 'Jobs',
          value: selectedJobs,
          items: jobsOptions
              .map(
                (option) =>
                    DropdownMenuItem(value: option, child: Text(option)),
              )
              .toList(),
          onChanged: (value) => setState(() => selectedJobs = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Select a job";
            }
            return null;
          },
        ),
        DropdownBtn(
          labelText: 'Income',
          value: selectedIncome,
          items: incomeOptions
              .map(
                (option) =>
                    DropdownMenuItem(value: option, child: Text(option)),
              )
              .toList(),
          onChanged: (value) => setState(() => selectedIncome = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Select an income";
            }
            return null;
          },
        ),
        DropdownBtn(
          labelText: 'Marital Status',
          value: selectedMaritalStatus,
          items: maritalStatusOptions
              .map(
                (option) =>
                    DropdownMenuItem(value: option, child: Text(option)),
              )
              .toList(),
          onChanged: (value) => setState(() => selectedMaritalStatus = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Select a marital status";
            }
            return null;
          },
        ),
      ],
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
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedBtn(
            btnText: 'Next',
            hasSize: false,
            width: 160,
            onPressed: () async {
              try {
                if (_formKey.currentState?.validate() ?? false) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return const Center(child: CircularProgressIndicator());
                    },
                  );

                  final registrationState =
                      Provider.of<RegistrationState>(context, listen: false);

                  onSaveProfile();

                  await registrationState.saveStep2Data();

                  Navigator.of(context).pop();

                  Navigator.pushNamed(
                      context, RouteList.registerCandidateThird);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all the fields'),
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
