import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../../routes/route.dart';
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
  final _formKey = GlobalKey<FormState>();
  List<PlatformFile> selectedFiles = [];

  Future<void> uploadDocumentFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        setState(() {
          selectedFiles = result.files;
        });
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return TopBar(
      title: 'Register as Candidate',
      index: 4,
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
                'Submit Infomation',
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
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        labelText: 'Short Biography',
                        hintText: 'Enter your short bio',
                        validator: (String? reason) {
                          if (reason == null || reason.isEmpty) {
                            return "Enter a valid short bio";
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
                        labelText: 'Election Manifesto',
                        hintText: 'Enter your manifesto',
                        validator: (String? reason) {
                          if (reason == null || reason.isEmpty) {
                            return "Enter a valid manifesto";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {});
                        },
                      ),
                      ElevatedBtn(
                        btnText: 'Upload Document',
                        btnColorWhite: false,
                        onPressed:
                            //() {},
                            () async {
                          await uploadDocumentFile();
                        },
                      ),
                      const SizedBox(height: 20),
                      if (selectedFiles.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selected Files:',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              ...selectedFiles.map((file) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.file_present,
                                            size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          file.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
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
              btnText: 'Submit',
              hasSize: false,
              width: 160,
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  Navigator.of(context).pushNamed(RouteList.registerStatus);
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
