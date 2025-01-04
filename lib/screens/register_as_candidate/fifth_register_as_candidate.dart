import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/registration_state.dart';
import '../../routes/route.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/top_bar.dart';
import 'step_icon.dart';

class RegisterCandidateFifth extends StatefulWidget {
  const RegisterCandidateFifth({super.key});

  @override
  State<RegisterCandidateFifth> createState() => _RegisterCandidateFifthState();
}

class _RegisterCandidateFifthState extends State<RegisterCandidateFifth> {
  String? selectedOption;
  final _formKey = GlobalKey<FormState>();
  List<PlatformFile> selectedFiles = [];
  TextEditingController bioController = TextEditingController();
  TextEditingController manifestoController = TextEditingController();

  static const int maxFiles = 5;

  Future<void> uploadDocumentFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
        withData: true,
      );

      if (result != null) {
        final registrationState =
            Provider.of<RegistrationState>(context, listen: false);

        for (var file in result.files) {
          if (file.path != null) {
            print('DEBUG: Adding document to provider: ${file.name}');
            print('DEBUG: Document path: ${file.path}');
            print('DEBUG: Document size: ${file.size}');
            registrationState.addDocument(file);
          }
        }

        // Force UI update
        setState(() {});

        // Show feedback to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added ${result.files.length} document(s)')),
        );
      }
    } catch (e) {
      print("DEBUG: Error picking file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting files: $e')),
      );
    }
  }

  // Future<void> debugPrintAllStepData() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final step1Data = prefs.getString('step1_data');
  //     final step2Data = prefs.getString('step2_data');
  //     final step3Data = prefs.getString('short_biography');
  //     final step3Manifesto = prefs.getString('manifesto');
  //     final step4Data = prefs.getString('step4_data');

  //     print('DEBUG: Step 1 Data: $step1Data');
  //     print('DEBUG: Step 2 Data: $step2Data');
  //     print('DEBUG: Step 3 Biography: $step3Data');
  //     print('DEBUG: Step 3 Manifesto: $step3Manifesto');
  //     print('DEBUG: okStep 4 Data: $step4Data');
  //   } catch (e) {
  //     print('DEBUG: Error retrieving step data: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final registrationState = Provider.of<RegistrationState>(context);
    final hasDocuments = registrationState.documents.isNotEmpty;

    return TopBar(
      title: 'Register as Candidate',
      index: 4,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const StepIcon(activeIndex: 4),
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
                      ElevatedBtn(
                        btnText: 'Upload Document',
                        btnColorWhite: false,
                        onPressed: () async {
                          await uploadDocumentFile();
                        },
                      ),
                      const SizedBox(height: 20),
                      if (hasDocuments) ...[
                        const SizedBox(height: 16),
                        buildFileList(),
                      ],
                      bottomBtn(),
                      const SizedBox(height: 20),
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
              onPressed: () async {
                final registrationState =
                    Provider.of<RegistrationState>(context, listen: false);

                await registrationState.submitDocuments();

                Navigator.of(context).pop();

                Navigator.pushNamed(context, RouteList.registerStatus);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFileList() {
    final registrationState = Provider.of<RegistrationState>(context);
    final documents = registrationState.documents;

    if (documents.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selected Files (${documents.length}/$maxFiles):',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                onPressed: documents.isNotEmpty
                    ? () {
                        registrationState.clearDocuments();
                        setState(() {});
                      }
                    : null,
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...documents.map((file) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      _getFileIcon(file.extension ?? ''),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            file.name,
                            style: Theme.of(context).textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            _formatFileSize(file.size),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        registrationState.removeDocument(file);
                        setState(() {});
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      iconSize: 20,
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  IconData _getFileIcon(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.file_present;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
