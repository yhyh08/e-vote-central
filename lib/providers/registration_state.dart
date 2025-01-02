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
  List<NomineeData> nominees = [];

  // Step 3: Candidate Profile
  CandidateProfile? _candidateProfile;

  // Step 4: Documents and Additional Info
  final List<PlatformFile> _documents = <PlatformFile>[];
  List<PlatformFile> get documents => List<PlatformFile>.from(_documents);
  String? _bio;
  String? _manifesto;

  // Getters
  String? get electionId => _electionId;
  String? get electionTopic => _electionTopic;
  List<NomineeData> get nominee => nominees;
  CandidateProfile? get candidateProfile => _candidateProfile;

  String? _selectedElectionId;
  String? get selectedElectionId => _selectedElectionId;

  void setSelectedElectionId(String? electionId) {
    _selectedElectionId = electionId;
    print('Setting election ID in provider: $electionId');

    // Save to SharedPreferences immediately when selected
    _saveElectionIdToPrefs(electionId);

    notifyListeners();
  }

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

  void addNominee(NomineeData nominee) {
    nominees.add(nominee);
    print('DEBUG: Added nominee: ${nominee.toJson()}');
    notifyListeners();
  }

  void removeNominee(int index) {
    nominees.removeAt(index);
    notifyListeners();
  }

  // Step 3: Update Candidate Profile
  void setCandidateProfile(CandidateProfile profile) {
    _candidateProfile = profile;
    notifyListeners();
  }

  // Save bio and manifesto
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

  Future<bool> submitAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tokenString = prefs.getString('token');
      if (tokenString == null) {
        throw Exception('Authentication token not found');
      }

      // Retrieve step data
      final step1DataString = prefs.getString('step1_data');
      final step2DataString = prefs.getString('step2_data');
      final step3Bio = prefs.getString('short_biography');
      final step3Manifesto = prefs.getString('manifesto');
      final step4DataString = prefs.getString('step4_data');

      if (step1DataString == null ||
          step2DataString == null ||
          step3Bio == null ||
          step3Manifesto == null) {
        throw Exception('Missing step data');
      }

      // Parse the data
      final step1Data = json.decode(step1DataString);
      final step2Data = json.decode(step2DataString);
      final step4Data = json.decode(step4DataString!);

      // Prepare candidate data
      final candidateData = {
        'election_id': step1Data['election_id'],
        'candidate_name': step2Data['candidate_name'],
        'candidate_phone': step2Data['candidate_phone'],
        'candidate_email': step2Data['candidate_email'],
        'candidate_gender': step2Data['candidate_gender'],
        'candidate_ic': step2Data['candidate_ic'],
        'candidate_dob': step2Data['candidate_dob'],
        'candidate_address': step2Data['candidate_address'],
        'nationality': step2Data['nationality'],
        'job': step2Data['job'],
        'income': step2Data['income'],
        'marriage_status': step2Data['marriage_status'],
        'position': step2Data['position'],
        'religion': step2Data['religion'],
        'short_biography': step3Bio,
        'manifesto': step3Manifesto,
        'status': 'Pending',
        'votes_count': 0,
        'reason': 'a',
        'candidate_image': 'default.jpg',
        'sign': 'sign.jpg',
      };

      // POST to save-candidate-info
      final responseInfo = await http.post(
        Uri.parse('$serverApiUrl/save-candidate-info'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${json.decode(tokenString)['token']}',
        },
        body: json.encode(candidateData),
      );

      if (responseInfo.statusCode != 200) {
        throw Exception('Failed to save candidate info');
      }

      // Prepare nomination data
      final nominationData = {
        'nominee_name': step4Data['nominee_name'],
        'nominee_phone': step4Data['nominee_phone'],
        'nominee_email': step4Data['nominee_email'],
        'election_id': step4Data['election_id'],
        'org_id': step4Data['org_id'],
      };

      // POST to save-nominations
      final responseNominations = await http.post(
        Uri.parse('$serverApiUrl/save-nominations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${json.decode(tokenString)['token']}',
        },
        body: json.encode(nominationData),
      );

      if (responseNominations.statusCode != 200) {
        throw Exception('Failed to save nominations');
      }

      return true;
    } catch (e) {
      print('DEBUG: Error in submitAllData: $e');
      throw Exception('Failed to submit registration: $e');
    }
  }

  // Clear all stored data
  Future<void> clearStoredData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('step1_data');
      await prefs.remove('step2_data');
      await prefs.remove('step3_data');
      await prefs.remove('step4_nominees');
      await prefs.remove('step5_documents');
      _documents.clear();
      notifyListeners();
    } catch (e) {
      print('DEBUG: Error clearing stored data: $e');
    }
  }

  void addDocument(PlatformFile file) {
    try {
      if (file.path != null) {
        _documents.add(file);
        print('DEBUG: Added document: ${file.name}');
        notifyListeners();
      } else {
        print('DEBUG: Document path is null');
      }
    } catch (e) {
      print('DEBUG: Error adding document: $e');
    }
  }

  void removeDocument(PlatformFile file) {
    try {
      _documents.removeWhere((doc) => doc.path == file.path);
      print('DEBUG: Removed document: ${file.name}');
      notifyListeners();
    } catch (e) {
      print('DEBUG: Error removing document: $e');
    }
  }

  void clearDocuments() {
    try {
      _documents.clear();
      print('DEBUG: Cleared all documents');
      notifyListeners();
    } catch (e) {
      print('DEBUG: Error clearing documents: $e');
    }
  }

  // Get document count
  int get documentCount => _documents.length;

  // Check if document exists
  bool hasDocument(String path) {
    return _documents.any((doc) => doc.path == path);
  }

  Future<void> saveStep1Data(String electionId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'step1_data', json.encode({'election_id': electionId}));
      print('DEBUG: Step 1 data saved successfully: election_id = $electionId');
    } catch (e) {
      print('DEBUG: Error saving step 1 data: $e');
      throw Exception('Error saving step 1: $e');
    }
  }

  // Method to save Step 2 data to SharedPreferences
  Future<bool> saveStep2Data() async {
    try {
      if (_candidateProfile == null) {
        print('DEBUG: Candidate profile is null. Cannot save Step 2 data.');
        return false;
      }

      final prefs = await SharedPreferences.getInstance();

      // Save candidate profile data
      final step2Data = {
        'candidate_name':
            '${_candidateProfile!.firstName} ${_candidateProfile!.lastName}',
        'candidate_phone': _candidateProfile!.phone,
        'candidate_email': _candidateProfile!.email,
        'candidate_gender': _candidateProfile!.gender,
        'candidate_ic': _candidateProfile!.identificationNo,
        'candidate_dob': _candidateProfile!.dateOfBirth,
        'candidate_address':
            '${_candidateProfile!.address.line1}, ${_candidateProfile!.address.line2}, ${_candidateProfile!.address.city}, ${_candidateProfile!.address.state}, ${_candidateProfile!.address.country}, ${_candidateProfile!.address.postcode}',
        'nationality': _candidateProfile!.nationality,
        'job': _candidateProfile!.jobStatus,
        'income': _candidateProfile!.income,
        'marriage_status': _candidateProfile!.maritalStatus,
        'position': _candidateProfile!.position,
        'religion': _candidateProfile!.religion,
        'reason': 'a',
        'sign': 'sign.jpg',
        'candidate_image': 'candidate.jpg',
        'status': 'Pending',
        'nominee_id': 5,
        'user_id': 2,
      };

      await prefs.setString('step2_data', json.encode(step2Data));

      // Save additional data
      await prefs.setString('short_biography', _bio ?? '');
      await prefs.setString('manifesto', _manifesto ?? '');

      print('DEBUG: Step 2 data saved successfully: ${json.encode(step2Data)}');
      return true;
    } catch (e) {
      print('DEBUG: Error saving step 2 data: $e');
      throw Exception('Error saving step 2: $e');
    }
  }

  // Method to save Step 3 data to SharedPreferences
  Future<void> saveStep3Data() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save biography and manifesto
      await prefs.setString('short_biography', _bio ?? '');
      await prefs.setString('manifesto', _manifesto ?? '');

      print(
          'DEBUG: Step 3 data saved successfully: biography = ${_bio ?? ''}, manifesto = ${_manifesto ?? ''}');
    } catch (e) {
      print('DEBUG: Error saving step 3 data: $e');
      throw Exception('Error saving step 3: $e');
    }
  }

  // Method to save Step 4 data to SharedPreferences
  Future<void> saveStep4Data() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Assuming you want to save the first nominee's data
      if (nominees.isNotEmpty) {
        final nominee = nominees.first;
        final step4Data = {
          'nominee_name': nominee.name,
          'nominee_phone': nominee.phone,
          'nominee_email': nominee.email,
          'election_id': _selectedElectionId,
          'reason': nominee.reason,
          'org_id': nominee.organization, // Assuming organization is the org_id
        };

        await prefs.setString('step4_data', json.encode(step4Data));

        print(
            'DEBUG: Step 4 data saved successfully: ${json.encode(step4Data)}');
      } else {
        print('DEBUG: No nominee data to save for Step 4');
      }
    } catch (e) {
      print('DEBUG: Error saving step 4 data: $e');
      throw Exception('Error saving step 4: $e');
    }
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

  factory NomineeData.fromJson(Map<String, dynamic> json) => NomineeData(
        name: json['nominee_name'],
        email: json['nominee_email'],
        phone: json['nominee_phone'],
        reason: json['reason'],
        organization: json['organization'],
      );
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
