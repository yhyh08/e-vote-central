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

  Future<void> uploadDocumentFile() async {
    try {
      // Open the file picker to select a document file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
          'txt'
        ], // Specify allowed file types
      );

      if (result != null) {
        // Get the file path
        String? filePath = result.files.single.path;

        if (filePath != null) {
          // File picked successfully, you can use `filePath`
          print("File picked: $filePath");
          // TODO: Upload the file to your server or process it further
        } else {
          print("No file path found!");
        }
      } else {
        // User canceled the picker
        print("File selection canceled.");
      }
    } catch (e) {
      // Handle errors
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
