import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/registration_state.dart';
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController manifestoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TopBar(
      title: 'Register as Candidate',
      index: 4,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const StepIcon(activeIndex: 2),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Submit Information',
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
                        controller: bioController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        labelText: 'Short Biography',
                        hintText: 'Enter your short bio',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Short biography is required";
                          }
                          return null;
                        },
                      ),
                      FormTextfield(
                        controller: manifestoController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        labelText: 'Election Manifesto',
                        hintText: 'Enter your manifesto',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Manifesto is required";
                          }
                          return null;
                        },
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
                  Navigator.of(context).pop();

                  final registrationState =
                      Provider.of<RegistrationState>(context, listen: false);
                  registrationState.setBio(bioController.text);
                  registrationState.setManifesto(manifestoController.text);

                  await registrationState.submitCandidateData();

                  Navigator.pushNamed(
                      context, RouteList.registerCandidateForth);
                }
              } catch (e) {
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop(); // Close loading dialog
                }
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     content: Text('Error: ${e.toString()}'),
                //     backgroundColor: Theme.of(context).hintColor,
                //   ),
                // );
              }
            },
          ),
        ],
      ),
    );
  }
}
