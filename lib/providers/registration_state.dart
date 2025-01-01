import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../network_utlis/api_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationState extends ChangeNotifier {
  // Step 1: Election Data
  String? _electionId;
  String? _electionTopic;

  // Step 2: Nominee Data
  List<NomineeData> _nominees = [];

  // Step 3: Candidate Profile
  CandidateProfile? _candidateProfile;

  // Step 4: Documents and Additional Info
  List<PlatformFile>? _documents;
  String? _bio;
  String? _manifesto;

  // Getters
  String? get electionId => _electionId;
  String? get electionTopic => _electionTopic;
  List<NomineeData> get nominees => _nominees;
  CandidateProfile? get candidateProfile => _candidateProfile;
  List<PlatformFile>? get documents => _documents;

  String? _selectedElectionId;

  String? get selectedElectionId => _selectedElectionId;

  void setSelectedElectionId(String? electionId) {
    _selectedElectionId = electionId;
    print('Setting election ID in provider: $electionId');

    // Save to SharedPreferences immediately when selected
    _saveElectionIdToPrefs(electionId);

    notifyListeners();
  }

  // Add a new method to save to SharedPreferences
  Future<void> _saveElectionIdToPrefs(String? electionId) async {
    if (electionId != null && electionId.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('election_id', electionId);
      print('DEBUG: Saved election_id to SharedPreferences: $electionId');
    }
  }

  // Step 1: Update Election Data
  void setElectionData(String electionId, String electionTopic) {
    _electionId = electionId;
    _electionTopic = electionTopic;
    notifyListeners();
  }

  // Step 2: Update Nominee Data
  void addNominee(NomineeData nominee) {
    _nominees.add(nominee);
    notifyListeners();
  }

  void removeNominee(int index) {
    _nominees.removeAt(index);
    notifyListeners();
  }

  // Step 3: Update Candidate Profile
  void setCandidateProfile(CandidateProfile profile) {
    _candidateProfile = profile;
    notifyListeners();
  }

  // Step 4: Update Documents and Additional Info
  void setDocuments(List<PlatformFile> docs) {
    _documents = docs;
    notifyListeners();
  }

  // Save Step 1 to SharedPreferences
  Future<bool> saveStep1() async {
    try {
      if (_selectedElectionId == null || _selectedElectionId!.isEmpty) {
        throw Exception('No election ID selected');
      }

      final prefs = await SharedPreferences.getInstance();

      // Save election_id in Step 1
      await prefs.setString('election_id', _selectedElectionId!);

      // Verify the save
      final savedId = prefs.getString('election_id');
      print('DEBUG: Verified saved election_id in Step 1: $savedId');

      if (savedId == null || savedId.isEmpty) {
        throw Exception('Failed to save election ID');
      }

      return true;
    } catch (e) {
      print('DEBUG: Error in saveStep1: $e');
      throw Exception('Error saving step 1: $e');
    }
  }

  // Save Step 2 to SharedPreferences
  Future<bool> saveStep2() async {
    try {
      if (candidateProfile == null) {
        throw Exception('No candidate profile data available');
      }

      final prefs = await SharedPreferences.getInstance();

      // Save first and last name separately
      await prefs.setString('first_name', candidateProfile!.firstName);
      await prefs.setString('last_name', candidateProfile!.lastName);

      // Save other fields
      await prefs.setString('candidate_phone', candidateProfile!.phone);
      await prefs.setString('candidate_email', candidateProfile!.email);
      await prefs.setString('candidate_gender', candidateProfile!.gender);
      await prefs.setString('candidate_ic', candidateProfile!.identificationNo);
      await prefs.setString('candidate_dob', candidateProfile!.dateOfBirth);
      await prefs.setString('candidate_address',
          '${candidateProfile!.address.line1}, ${candidateProfile!.address.line2}, ${candidateProfile!.address.city}, ${candidateProfile!.address.state}, ${candidateProfile!.address.country}, ${candidateProfile!.address.postcode}');
      await prefs.setString('nationality', candidateProfile!.nationality);
      await prefs.setString('job', candidateProfile!.jobStatus);
      await prefs.setString('income', candidateProfile!.income);
      await prefs.setString('marriage_status', candidateProfile!.maritalStatus);
      await prefs.setString('position', candidateProfile!.position);
      await prefs.setString('religion', candidateProfile!.religion);

      return true;
    } catch (e) {
      throw Exception('Error saving step 2: $e');
    }
  }

  Future<bool> saveStep3AndSubmit() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get and parse the token
      final tokenString = prefs.getString('token');
      final tokenData = json.decode(tokenString ?? '');
      final userId = tokenData['user']['id'].toString();
      final actualToken = tokenData['token'];

      // Get required data
      final firstName = prefs.getString('first_name') ?? '';
      final lastName = prefs.getString('last_name') ?? '';
      final candidateName = '$firstName $lastName'.trim();
      final electionId = prefs.getString('election_id');

      // Validate essential data
      if (candidateName.isEmpty) {
        throw Exception('Candidate name is required');
      }
      if (electionId == null || electionId.isEmpty) {
        throw Exception('Election ID is required');
      }

      // Create base request data
      final baseData = {
        'user_id': userId,
        'candidate_name': candidateName,
        'election_id': int.parse(electionId),
        'candidate_phone': prefs.getString('candidate_phone') ?? '',
        'candidate_email': prefs.getString('candidate_email') ?? '',
        'candidate_gender': prefs.getString('candidate_gender') ?? '',
        'candidate_ic': prefs.getString('candidate_ic') ?? '',
        'candidate_dob': prefs.getString('candidate_dob') ?? '',
        'candidate_address':
            prefs.getString('candidate_address')?.replaceAll(', , ', ', ') ??
                '',
        'nationality': prefs.getString('nationality') ?? '',
        'job': prefs.getString('job') ?? '',
        'income': prefs.getString('income') ?? '',
        'marriage_status': prefs.getString('marriage_status') ?? '',
        'position': prefs.getString('position') ?? '',
        'religion': prefs.getString('religion') ?? '',
        'short_biography': _bio ?? '',
        'manifesto': _manifesto ?? '',
        'status': 'Pending',
        'votes_count': 0,
        'reason': 'a'
      };

      // Add required fields with default values and empty IDs for later update
      final requestData = {
        ...baseData,
        'candidate_image': 'default.jpg',
        'sign': 'sign.jpg',
        'nominee_id': '', // Will be updated in step 4
        'cand_doc_id': '', // Will be updated in step 5
      };

      print('DEBUG: Final Request Data:');
      print(json.encode(requestData));

      final response = await http.post(
        Uri.parse('$serverApiUrl/save-candidate-info'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $actualToken',
        },
        body: json.encode(requestData),
      );

      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          // Don't clear all data yet, as we need to complete steps 4-5
          // await _clearStoredData(prefs);
          return true;
        } else {
          throw Exception(responseData['message'] ?? 'Failed to save data');
        }
      }

      final errorBody = json.decode(response.body);
      throw Exception(
          errorBody['error'] ?? 'Failed to save candidate information');
    } catch (e) {
      print('DEBUG: Error in saveStep3AndSubmit: $e');
      throw Exception('$e');
    }
  }

  // Note: We'll need separate methods to update nominee_id and cand_doc_id later
  Future<bool> updateNomineeId(String candidateId, String nomineeId) async {
    // This will be implemented for step 4
    return true;
  }

  Future<bool> updateCandDocId(String candidateId, String docId) async {
    // This will be implemented for step 5
    return true;
  }

  // Separate method to clear stored data
  Future<void> _clearStoredData(SharedPreferences prefs) async {
    try {
      // Keep the token but clear everything else
      final token = prefs.getString('token');
      await prefs.clear();
      if (token != null) {
        await prefs.setString('token', token);
      }

      // Clear the provider state
      _bio = null;
      _manifesto = null;
      _selectedElectionId = null;
      _candidateProfile = null;
      notifyListeners();

      print('DEBUG: Successfully cleared stored data');
    } catch (e) {
      print('DEBUG: Error clearing stored data: $e');
      throw Exception('Failed to clear stored data: $e');
    }
  }

  Future<bool> saveStep4() async {
    try {
      return true;
    } catch (e) {
      throw Exception('Error saving step 4: $e');
    }
  }

  // Save Step 5 (Documents)
  Future<String> saveStep5() async {
    try {
      // This method is now handled directly in the UI component
      // but we can keep it for future use if needed
      return '';
    } catch (e) {
      print('Error in saveStep5: $e');
      throw e;
    }
  }

  void setBio(String value) {
    _bio = value;
    notifyListeners();
  }

  void setManifesto(String value) {
    _manifesto = value;
    notifyListeners();
  }

  String? get getElectionId => _selectedElectionId;

  void setElectionId(String? id) {
    _selectedElectionId = id;
    notifyListeners();
  }

  // Add a method to check if Step 1 is complete
  Future<bool> isStep1Complete() async {
    final prefs = await SharedPreferences.getInstance();
    final electionId = prefs.getString('election_id');
    print('DEBUG: Checking Step 1 completion - election_id: $electionId');
    return electionId != null && electionId.isNotEmpty;
  }
}

// Data Classes
class NomineeData {
  final String name;
  final String email;
  final String phone;
  final String reason;
  final String organization;

  NomineeData({
    required this.name,
    required this.email,
    required this.phone,
    required this.reason,
    required this.organization,
  });

  Map<String, dynamic> toJson() => {
        'nominee_name': name,
        'nominee_email': email,
        'nominee_phone': phone,
        'reason': reason,
        'organization': organization,
      };
}

class CandidateProfile {
  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final String phone;
  final String identificationNo;
  final Address address;
  final String religion;
  final String nationality;
  final String jobStatus;
  final String income;
  final String maritalStatus;
  final String dateOfBirth;
  final String position;
  // final String shortBiography;
  // final String manifesto;

  CandidateProfile({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.email,
    required this.phone,
    required this.identificationNo,
    required this.address,
    required this.nationality,
    required this.religion,
    required this.jobStatus,
    required this.income,
    required this.maritalStatus,
    required this.dateOfBirth,
    required this.position,
    // required this.shortBiography,
    // required this.manifesto,
  });

  Map<String, dynamic> toJson() => {
        'name': '$firstName $lastName',
        'gender': gender,
        'email': email,
        'phone': phone,
        'identification_no': identificationNo,
        'address': address.toJson(),
        'nationality': nationality,
        'job_status': jobStatus,
        'religion': religion,
        'income': income,
        'marital_status': maritalStatus,
        'position': position,
        'date_of_birth': dateOfBirth,
        // 'short_biography': shortBiography,
        // 'manifesto': manifesto,
      };
}

class Address {
  final String line1;
  final String line2;
  final String city;
  final String state;
  final String country;
  final String postcode;

  Address({
    required this.line1,
    required this.line2,
    required this.city,
    required this.state,
    required this.country,
    required this.postcode,
  });

  Map<String, dynamic> toJson() => {
        'line1': line1,
        'line2': line2,
        'city': city,
        'state': state,
        'country': country,
        'postcode': postcode,
      };
}
