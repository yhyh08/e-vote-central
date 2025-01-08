import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../../network_utlis/api_constant.dart';
import '../../routes/route.dart';
import '../../widgets/dropdown_btn.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/form_textfield.dart';
import '../../widgets/top_bar.dart';

class OrganizationForm extends StatefulWidget {
  const OrganizationForm({super.key});

  @override
  State<OrganizationForm> createState() => _OrganizationFormState();
}

class _OrganizationFormState extends State<OrganizationForm> {
  final _formKey = GlobalKey<FormState>();
  String? selectedCategory;
  String? selectedSize;

  final TextEditingController orgNameController = TextEditingController();
  final TextEditingController orgDescriptionController =
      TextEditingController();
  final TextEditingController orgAddressLine1Controller =
      TextEditingController();
  final TextEditingController orgAddressLine2Controller =
      TextEditingController();
  final TextEditingController orgPostcodeController = TextEditingController();
  final TextEditingController orgStateController = TextEditingController();
  final TextEditingController orgCountryController = TextEditingController();
  final TextEditingController orgCityController = TextEditingController();
  final TextEditingController orgWebsiteController = TextEditingController();
  final TextEditingController orgEmailController = TextEditingController();
  final TextEditingController orgPicNameController = TextEditingController();
  final TextEditingController orgPicPhoneController = TextEditingController();
  final TextEditingController orgPicEmailController = TextEditingController();

  final List<String> orgCategoryOptions = ['Technology', 'Others'];
  final List<String> orgSizeOptions = [
    '1-50',
    '51-200',
    '201-500',
    '501-1000',
    '1000+'
  ];

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1000,
        maxHeight: 1000,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to pick image'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    orgNameController.dispose();
    orgDescriptionController.dispose();
    orgAddressLine1Controller.dispose();
    orgAddressLine2Controller.dispose();
    orgPostcodeController.dispose();
    orgStateController.dispose();
    orgCountryController.dispose();
    orgCityController.dispose();
    orgWebsiteController.dispose();
    orgEmailController.dispose();
    orgPicNameController.dispose();
    orgPicPhoneController.dispose();
    orgPicEmailController.dispose();
    super.dispose();
  }

  Future<void> saveOrganization() async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$serverApiUrl/save-organizations'),
    );

    if (_imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'org_img',
        _imageFile!.path,
        filename: path.basename(_imageFile!.path),
      ));
    }

    final address = [
      orgAddressLine1Controller.text,
      orgAddressLine2Controller.text,
      orgCityController.text,
      orgStateController.text,
      orgCountryController.text,
      orgPostcodeController.text,
    ].where((part) => part.isNotEmpty).join(', ');

    request.fields.addAll({
      'org_name': orgNameController.text,
      'org_desc': orgDescriptionController.text,
      'org_address': address,
      'org_website': orgWebsiteController.text,
      'org_email': orgEmailController.text,
      'pic_name': orgPicNameController.text,
      'pic_phone': orgPicPhoneController.text,
      'pic_email': orgPicEmailController.text,
      'org_cat': selectedCategory ?? '',
      'org_size': selectedSize ?? '',
    });

    try {
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);

      if (jsonResponse['success'] == true) {
        print('Organization saved successfully: ${jsonResponse['message']}');
      } else {
        print('Failed to save organization');
        throw Exception(
            jsonResponse['message'] ?? 'Failed to save organization');
      }
    } catch (e) {
      print('Error saving organization: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TopBar(
      title: 'Add Organization',
      index: 4,
      isBack: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Organization Information',
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
                      buildFormFields(),
                      const SizedBox(height: 10),
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

  Widget buildFormFields() {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Stack(
              children: [
                if (_imageFile != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _imageFile!,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                if (_imageFile == null)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 40,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add Logo',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_imageFile != null)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor:
                                Theme.of(context).secondaryHeaderColor,
                            title: const Text('Image Options'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: const Text('Change Image'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _pickImage();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.delete),
                                  title: const Text('Remove Image'),
                                  onTap: () {
                                    setState(() => _imageFile = null);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: Icon(
                          Icons.edit,
                          size: 16,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        FormTextfield(
          controller: orgNameController,
          labelText: 'Organization Name',
          hintText: 'Enter organization name',
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the organization name';
            }
            return null;
          },
        ),
        FormTextfield(
          controller: orgDescriptionController,
          labelText: 'Description',
          hintText: 'Enter description',
          maxLines: 3,
          keyboardType: TextInputType.multiline,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a description';
            }
            return null;
          },
        ),
        DropdownBtn(
          labelText: 'Category',
          value: selectedCategory,
          items: orgCategoryOptions
              .map(
                (option) =>
                    DropdownMenuItem(value: option, child: Text(option)),
              )
              .toList(),
          onChanged: (value) => setState(() => selectedCategory = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Select a category";
            }
            return null;
          },
        ),
        CountryStateCityPicker(
          country: orgCountryController,
          state: orgStateController,
          city: orgCityController,
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
          controller: orgAddressLine1Controller,
          labelText: 'Address Line 1',
          hintText: 'Enter address line 1',
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter address line 1';
            }
            return null;
          },
        ),
        FormTextfield(
          controller: orgAddressLine2Controller,
          labelText: 'Address Line 2',
          hintText: 'Enter address line 2',
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter address line 2';
            }
            return null;
          },
        ),
        FormTextfield(
          controller: orgWebsiteController,
          labelText: 'Website',
          hintText: 'Enter website',
          keyboardType: TextInputType.url,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a website';
            }
            return null;
          },
        ),
        FormTextfield(
          controller: orgEmailController,
          labelText: 'Email',
          hintText: 'Enter email',
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an email';
            }
            return null;
          },
        ),
        DropdownBtn(
          labelText: 'Size',
          value: selectedSize,
          items: orgSizeOptions
              .map(
                (option) =>
                    DropdownMenuItem(value: option, child: Text(option)),
              )
              .toList(),
          onChanged: (value) => setState(() => selectedSize = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Select a size";
            }
            return null;
          },
        ),
        FormTextfield(
          controller: orgPicNameController,
          labelText: 'Person in Charge Name',
          hintText: 'Enter name',
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the person in charge name';
            }
            return null;
          },
        ),
        FormTextfield(
          controller: orgPicPhoneController,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
          ],
          labelText: 'Person in Charge Phone',
          hintText: 'Enter phone number',
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the person in charge phone';
            }
            return null;
          },
        ),
        FormTextfield(
          controller: orgPicEmailController,
          labelText: 'Person in Charge Email',
          hintText: 'Enter email',
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the person in charge email';
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
            btnText: 'Cancel',
            hasSize: false,
            btnColorWhite: false,
            width: 160,
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedBtn(
            btnText: 'Save',
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

                  await saveOrganization();
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Organization saved successfully!'),
                      backgroundColor: Theme.of(context).focusColor,
                      duration: const Duration(seconds: 2),
                    ),
                  );

                  // Navigate back to organization list after short delay
                  await Future.delayed(const Duration(seconds: 2));
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RouteList.organization,
                      (route) => false,
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all the required fields'),
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
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
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
