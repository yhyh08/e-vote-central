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
  bool isLoading = false;

  static const int maxFiles = 10;

  Future<void> uploadDocumentFile() async {
    setState(() {
      isLoading = true;
    });

    try {
      final registrationState =
          Provider.of<RegistrationState>(context, listen: false);
      final currentFiles = registrationState.documents;

      if (currentFiles.length >= 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Theme.of(context).hintColor,
              content: Text(
                'You can only upload up to 10 documents.',
                style: Theme.of(context).textTheme.bodyMedium,
              )),
        );
        return;
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
        withData: true,
      );

      if (result != null) {
        int addedFilesCount = 0;

        for (var file in result.files) {
          if (file.path != null) {
            // Check for duplicate file names
            bool isDuplicate = currentFiles
                .any((existingFile) => existingFile.name == file.name);
            if (isDuplicate) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    backgroundColor: Theme.of(context).hintColor,
                    content: Text(
                      'File "${file.name}" already exists. Please choose a different file.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    )),
              );
              continue;
            }

            print('DEBUG: Adding document to provider: ${file.name}');
            registrationState.addDocument(file);
            addedFilesCount++;
          }
        }

        setState(() {});

        if (addedFilesCount > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Added $addedFilesCount document(s)',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              backgroundColor: Theme.of(context).focusColor,
            ),
          );
        }
      }
    } catch (e) {
      print("DEBUG: Error picking file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Theme.of(context).hintColor,
            content: Text(
              'Error selecting files: $e',
              style: Theme.of(context).textTheme.bodyMedium,
            )),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final registrationState = Provider.of<RegistrationState>(context);
    final hasDocuments = registrationState.documents.isNotEmpty;

    return TopBar(
      title: 'Register as Candidate',
      index: 4,
      body: Stack(
        children: [
          Padding(
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
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Text(
                            'Only PDF, DOC, DOCX, JPG, JPEG, PNG files are allowed and maximum 10 files',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          const SizedBox(height: 10),
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
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
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
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const Center(child: CircularProgressIndicator());
                  },
                );

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
        border: Border.all(color: Theme.of(context).dialogBackgroundColor),
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
                child: Text(
                  'Clear All',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
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
}
