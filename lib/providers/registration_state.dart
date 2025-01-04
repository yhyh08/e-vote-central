import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../network_utlis/api_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationState extends ChangeNotifier {
  String? _electionId;
  String? _electionTopic;
  List<NomineeData> nominees = [];
  CandidateProfile? _candidateProfile;
  final List<PlatformFile> _documents = <PlatformFile>[];
  List<PlatformFile> get documents => List<PlatformFile>.from(_documents);
  String? _bio;
  String? _manifesto;
  String? get electionId => _electionId;
  String? get electionTopic => _electionTopic;
  List<NomineeData> get nominee => nominees;
  CandidateProfile? get candidateProfile => _candidateProfile;
  String? _selectedElectionId;
  String? get getElectionId => _selectedElectionId;
  String? get selectedElectionId => _selectedElectionId;
  bool get hasDocuments => _documents.isNotEmpty;

  void setSelectedElectionId(String? electionId) {
    _selectedElectionId = electionId;
    print('Setting election ID in provider: $electionId');

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

  void setElectionData(String electionId, String electionTopic) {
    _electionId = electionId;
    _electionTopic = electionTopic;
    notifyListeners();
  }

  void addNominee(NomineeData nominee) {
    nominees.add(nominee);
    print('DEBUG: Added nominee: ${nominee.toJson()}');
    print(
        'DEBUG: All nominees data: ${nominees.map((n) => n.toJson()).toList()}');
    notifyListeners();
  }

  void removeNominee(int index) {
    nominees.removeAt(index);
    notifyListeners();
  }

  void setCandidateProfile(CandidateProfile profile) {
    _candidateProfile = profile;
    notifyListeners();
  }

  void setBio(String value) {
    _bio = value;
    notifyListeners();
  }

  void setManifesto(String value) {
    _manifesto = value;
    notifyListeners();
  }

  void setNominee(List<int> nominees) {
    nominees = nominees;
    notifyListeners();
  }

  void setElectionId(String? id) {
    _selectedElectionId = id;
    notifyListeners();
  }

  Future<bool> isStep1Complete() async {
    final prefs = await SharedPreferences.getInstance();
    final electionId = prefs.getString('election_id');
    return electionId != null && electionId.isNotEmpty;
  }

  Future<void> clearStoredData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('step1_data');
      await prefs.remove('step2_data');
      await prefs.remove('step3_data');
      await prefs.remove('step4_data');
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
    _documents.remove(file);
    notifyListeners();
  }

  void clearDocuments() {
    _documents.clear();
    notifyListeners();
  }

  int get documentCount => _documents.length;

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

  Future<bool> saveStep2Data() async {
    try {
      if (_candidateProfile == null) {
        print('DEBUG: Candidate profile is null. Cannot save Step 2 data.');
        return false;
      }

      final prefs = await SharedPreferences.getInstance();
      final tokenString = prefs.getString('token');
      if (tokenString == null) {
        throw Exception('Authentication token not found');
      }

      final tokenData = json.decode(tokenString);
      final actualToken = tokenData['token'];
      final userId = tokenData['user']['id'];

      // Save candidate profile data
      final step2Data = {
        'candidate_name':
            '${_candidateProfile!.firstName} ${_candidateProfile!.lastName}',
        'candidate_phone': _candidateProfile!.phone,
        'candidate_email': _candidateProfile!.email,
        'candidate_gender': _candidateProfile!.gender,
        'candidate_ic': _candidateProfile!.identificationNo,
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
        'user_id': int.parse(userId.toString()),
        'votes_count': 0,
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

  Future<void> saveStep3Data() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('short_biography', _bio ?? '');
      await prefs.setString('manifesto', _manifesto ?? '');

      print(
          'DEBUG: Step 3 data saved successfully: biography = ${_bio ?? ''}, manifesto = ${_manifesto ?? ''}');
    } catch (e) {
      throw Exception('Error saving step 3: $e');
    }
  }

  Future<bool> submitDocuments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tokenString = prefs.getString('token');

      if (tokenString == null) {
        throw Exception('Token not found');
      }

      final tokenData = json.decode(tokenString);

      final candidateResponse = await http.get(
        Uri.parse('$serverApiUrl/get-candidateid'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${tokenData['token']}',
        },
      );

      final candidateData = json.decode(candidateResponse.body);
      final candidateId = candidateData['data']['candidate_id'];
      print('DEBUG: Using candidate_id: $candidateId');

      var uri = Uri.parse('$serverApiUrl/save-candidate-documents');

      for (var document in _documents) {
        if (document.path != null) {
          print('DEBUG: Processing document: ${document.name}');

          var request = http.MultipartRequest('POST', uri);

          request.headers.addAll({
            'Accept': 'application/json',
            'Authorization': 'Bearer ${tokenData['token']}',
          });

          request.fields['candidate_id'] = candidateId.toString();
          request.fields['document_name'] = document.name;

          final file = await http.MultipartFile.fromPath(
            'document',
            document.path!,
            filename: document.name,
          );
          request.files.add(file);

          var response = await request.send();
          var responseData = await response.stream.bytesToString();

          print('DEBUG: Upload response status: ${response.statusCode}');
          print('DEBUG: Upload response: $responseData');

          if (response.statusCode >= 400) {
            throw Exception('Failed to upload ${document.name}: $responseData');
          }
        }
      }

      return true;
    } catch (e) {
      print('DEBUG: Error in submitDocuments: $e');
      throw Exception('Failed to upload documents: $e');
    }
  }

  Future<bool> submitCandidateData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tokenString = prefs.getString('token');

      if (tokenString == null) {
        throw Exception('Authentication token not found');
      }

      final step1DataString = prefs.getString('step1_data');
      final step2DataString = prefs.getString('step2_data');
      final step3Bio = prefs.getString('short_biography');
      final step3Manifesto = prefs.getString('manifesto');

      print('DEBUG: Raw Step 1 data string: $step1DataString');
      print('DEBUG: Raw Step 2 data string: $step2DataString');
      print('DEBUG: Raw Step 3 bio: $step3Bio');
      print('DEBUG: Raw Step 3 manifesto: $step3Manifesto');

      if (step1DataString == null ||
          step2DataString == null ||
          step3Bio == null ||
          step3Manifesto == null) {
        throw Exception('Missing step data');
      }

      final tokenData = json.decode(tokenString);
      final userId = tokenData['user']['id'];
      print('DEBUG: Extracted user_id: $userId');

      final step1Data = json.decode(step1DataString);
      final step2Data = json.decode(step2DataString);

      Map<String, dynamic> candidateData = {
        'user_id': int.parse(userId.toString()), // Ensure it's an integer
        'election_id': int.tryParse(step1Data['election_id'].toString()) ?? 0,
        'candidate_name': step2Data['candidate_name']?.trim() ?? '',
        'candidate_phone': step2Data['candidate_phone']?.trim() ?? '',
        'candidate_email':
            step2Data['candidate_email']?.trim().toLowerCase() ?? '',
        'candidate_gender': step2Data['candidate_gender']?.trim() ?? '',
        'candidate_ic': step2Data['candidate_ic']?.trim() ?? '',
        'candidate_address':
            step2Data['candidate_address']?.toString().trim() ?? '',
        'nationality': step2Data['nationality']?.trim() ?? '',
        'job': step2Data['job']?.trim() ?? '',
        'income': step2Data['income']?.trim() ?? '',
        'marriage_status': step2Data['marriage_status']?.trim() ?? '',
        'position': step2Data['position']?.trim() ?? '',
        'religion': step2Data['religion']?.trim() ?? '',
        'short_biography': step3Bio.trim(),
        'manifesto': step3Manifesto.trim(),
        'status': 'pending',
        'votes_count': 0,
        'reason': 'pending review',
        'candidate_image': 'default.jpg',
        'sign': 'sign.jpg',
        'user_id': userId,
        'nominee_id': [1, 2],
        'cand_doc_id': [1, 2],
      };

      print('DEBUG: User ID in data: ${candidateData['user_id']}');
      print('DEBUG: Full request payload: ${json.encode(candidateData)}');

      if (candidateData['user_id'] == null) {
        throw Exception('user_id is null');
      }

      final response = await http.post(
        Uri.parse('$serverApiUrl/save-candidate-info'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${tokenData['token']}',
        },
        body: json.encode(candidateData),
      );

      print('DEBUG: Request URL: $serverApiUrl/save-candidate-info');
      print('DEBUG: Request headers: ${json.encode({
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${tokenData['token']}'
          })}');
      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response body: ${response.body}');

      if (response.statusCode >= 400) {
        final errorBody = json.decode(response.body);
        throw Exception(
            'Server error (${response.statusCode}): ${errorBody['message'] ?? 'Unknown error'}');
      }
      return true;
    } catch (e) {
      throw Exception('Failed to submit candidate data: $e');
    }
  }

  Future<bool> submitNominationData() async {
    print('DEBUG: submitNominationData() called');
    try {
      final prefs = await SharedPreferences.getInstance();
      final tokenString = prefs.getString('token');

      if (tokenString == null) {
        throw Exception('Token not found');
      }

      final tokenData = json.decode(tokenString);

      final candidateResponse = await http.get(
        Uri.parse('$serverApiUrl/get-candidateid'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${tokenData['token']}',
        },
      );

      print('DEBUG: Candidate response: ${candidateResponse.body}');

      if (candidateResponse.statusCode != 200) {
        throw Exception('Failed to get candidate information');
      }

      final candidateData = json.decode(candidateResponse.body);
      final candidateId = candidateData['data']['candidate_id'];
      print('DEBUG: Extracted candidate ID: $candidateId');
      print('DEBUG: Number of nominees: ${nominees.length}');

      for (NomineeData nominee in nominees) {
        print('DEBUG: Processing nominee data:');
        print('DEBUG: Name: ${nominee.name}');
        print('DEBUG: Email: ${nominee.email}');
        print('DEBUG: Phone: ${nominee.phone}');
        print('DEBUG: Reason: ${nominee.reason}');
        print('DEBUG: Organization ID: ${nominee.organization}');

        final nominationData = {
          'candidate_id': candidateId,
          'nominee_name': nominee.name,
          'nominee_phone': nominee.phone,
          'nominee_email': nominee.email,
          'org_id': int.parse(nominee.organization),
          'reason': nominee.reason,
        };

        final response = await http.post(
          Uri.parse('$serverApiUrl/save-nominations'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${tokenData['token']}',
          },
          body: json.encode(nominationData),
        );

        print('DEBUG: Nomination response body: ${response.body}');

        if (response.statusCode >= 400) {
          throw Exception('Failed to save nomination: ${response.body}');
        }
      }

      return true;
    } catch (e) {
      print('DEBUG: Error in submitNominationData: $e');
      throw Exception('Failed to submit nominations: $e');
    }
  }
}

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
  final String position;

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
    required this.position,
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

Future<int?> getUserIdFromToken() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final tokenString = prefs.getString('token');
    if (tokenString != null) {
      final tokenData = json.decode(tokenString);
      return tokenData['user']['id'];
    }
    return null;
  } catch (e) {
    print('DEBUG: Error getting user ID from token: $e');
    return null;
  }
}
