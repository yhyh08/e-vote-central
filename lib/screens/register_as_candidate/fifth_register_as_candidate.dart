import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../../network_utlis/api_constant.dart';
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
      if (selectedFiles.length >= maxFiles) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Maximum $maxFiles files allowed',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            backgroundColor: Theme.of(context).hintColor,
          ),
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
        int remainingSlots = maxFiles - selectedFiles.length;
        List<PlatformFile> filesToAdd =
            result.files.take(remainingSlots).toList();

        List<PlatformFile> validFiles = [];
        for (var file in filesToAdd) {
          if (file.size > 5 * 1024 * 1024) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'File ${file.name} is too large. Maximum size is 5MB.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                backgroundColor: Theme.of(context).hintColor,
              ),
            );
            continue;
          }

          if (selectedFiles.any((existing) => existing.name == file.name)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'File ${file.name} already selected.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                backgroundColor: Theme.of(context).hintColor,
              ),
            );
            continue;
          }

          validFiles.add(file);
        }

        setState(() {
          selectedFiles.addAll(validFiles);
        });

        if (selectedFiles.length == maxFiles) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Maximum number of files reached',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${maxFiles - selectedFiles.length} more files can be added',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          );
        }
      }
    } catch (e) {
      print("Error picking file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error selecting files: $e',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          backgroundColor: Theme.of(context).hintColor,
        ),
      );
    }
  }

  Future<void> uploadDocuments(String candidateId) async {
    try {
      for (PlatformFile file in selectedFiles) {
        final fileName = file.name;
        final bytes = await File(file.path!).readAsBytes();
        final multipartFile = http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: fileName,
        );

        final request = http.MultipartRequest(
          'POST',
          Uri.parse('$serverApiUrl/candidates/$candidateId/documents'),
        );

        request.files.add(multipartFile);
        request.fields['candidate_id'] = candidateId;
        request.fields['document_type'] = 'supporting_document';

        final response = await request.send();
        if (response.statusCode != 201) {
          throw Exception('Failed to upload document: $fileName');
        }
      }
    } catch (e) {
      throw Exception('Error uploading documents: $e');
    }
  }

  Future<void> saveBioAndManifesto(String candidateId) async {
    try {
      final response = await http.post(
        Uri.parse('$serverApiUrl/candidate-additional-info/$candidateId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'bio': bioController.text,
          'manifesto': manifestoController.text,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to save bio and manifesto');
      }
    } catch (e) {
      print('Error saving bio and manifesto: $e');
      rethrow;
    }
  }

  Future<void> _saveAllData() async {
    try {
      final registrationState =
          Provider.of<RegistrationState>(context, listen: false);

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      // Prepare the complete candidate data
      final Map<String, dynamic> candidateData = {
        'election_id': registrationState.selectedElectionId,
        'first_name': registrationState.candidateProfile?.firstName,
        'last_name': registrationState.candidateProfile?.lastName,
        'gender': registrationState.candidateProfile?.gender,
        'email': registrationState.candidateProfile?.email,
        'phone': registrationState.candidateProfile?.phone,
        'identification_no':
            registrationState.candidateProfile?.identificationNo,
        'date_of_birth': registrationState.candidateProfile?.dateOfBirth,
        'address': {
          'line1': registrationState.candidateProfile?.address.line1,
          'line2': registrationState.candidateProfile?.address.line2,
          'city': registrationState.candidateProfile?.address.city,
          'state': registrationState.candidateProfile?.address.state,
          'country': registrationState.candidateProfile?.address.country,
          'postcode': registrationState.candidateProfile?.address.postcode,
        },
        'nationality': registrationState.candidateProfile?.nationality,
        'job_status': registrationState.candidateProfile?.jobStatus,
        'income': registrationState.candidateProfile?.income,
        'marital_status': registrationState.candidateProfile?.maritalStatus,
        'religion': registrationState.candidateProfile?.religion,
        'status': 'pending',
      };

      // Send data to API
      final response = await http.post(
        Uri.parse('$serverApiUrl/candidates'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(candidateData),
      );

      // Close loading indicator
      Navigator.of(context).pop();

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final candidateId = responseData['id'];

        // Upload documents if any are selected
        if (selectedFiles.isNotEmpty) {
          await uploadDocuments(candidateId);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration completed successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to success screen or home
        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteList.dashboard,
          (route) => false,
        );
      } else {
        throw Exception('Failed to save candidate data: ${response.body}');
      }
    } catch (e) {
      // Close loading indicator if still showing
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving registration: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
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
              activeIndex: 4,
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
                        buildFileList(),
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
              btnColorWhite: false,
              width: 150,
              onPressed: _saveAllData,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFileList() {
    if (selectedFiles.isEmpty) {
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
                'Selected Files (${selectedFiles.length}/$maxFiles):',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                onPressed: selectedFiles.isNotEmpty
                    ? () {
                        setState(() {
                          selectedFiles.clear();
                        });
                      }
                    : null,
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...selectedFiles.map((file) => Padding(
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
                        setState(() {
                          selectedFiles.remove(file);
                        });
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
