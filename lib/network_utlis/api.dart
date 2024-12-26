import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'api_constant.dart';

class Network {
  var token;

  final http.Client _client = http.Client();

  getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token') ?? '')['token'];
  }

  authData(data, apiUrl) async {
    var fullUrl = serverApiUrl + apiUrl;
    try {
      print('Sending request to: $fullUrl');
      print('With data: ${jsonEncode(data)}');

      bool hasConnection = await _checkConnection(Uri.parse(fullUrl));
      if (!hasConnection) {
        throw Exception(
            'Cannot connect to server. Please check your connection.');
      }

      final response = await http.post(
        Uri.parse(fullUrl),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': token != null ? 'Bearer $token' : '',
        },
      ).timeout(
        const Duration(seconds: 30),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      return response;
    } catch (e) {
      print('Network error details: $e');
      throw Exception('Error connecting to server: $e');
    }
  }

  getData(apiUrl) async {
    var fullUrl = serverApiUrl + apiUrl;
    try {
      var uri = Uri.parse(fullUrl);

      print('Attempting to connect to: $fullUrl');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Cache-Control': 'no-cache',
          'Connection': 'keep-alive',
        },
      ).timeout(
        const Duration(seconds: 30),
      );

      print('Response received');
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      return response;
    } catch (e) {
      print('Network error details: $e');
      rethrow;
    }
  }

  Future<bool> _checkConnection(Uri uri) async {
    try {
      final result = await InternetAddress.lookup(uri.host);
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token != null ? 'Bearer $token' : ''
      };

  void dispose() {
    _client.close();
  }

  Future<Map<String, dynamic>> getUserInfo(String phoneNumber) async {
    try {
      if (!phoneNumber.startsWith('+')) {
        phoneNumber = '+$phoneNumber';
      }
      phoneNumber = phoneNumber.replaceAll(' ', '').replaceAll('-', '');

      final response =
          await http.get(Uri.parse('$serverApiUrl/user-info/$phoneNumber'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to load user info');
    } catch (e) {
      print('Error fetching user info: $e');
      throw Exception('Error fetching user info: $e');
    }
  }

  Future<Map<String, dynamic>> getLatestElection() async {
    try {
      final response = await http.get(
        Uri.parse('$serverApiUrl/latest-election'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Latest Election Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Latest Election ID: ${data['id']}');
        return data;
      }
      throw Exception('Status: ${response.statusCode}');
    } catch (e) {
      print('Latest Election Error: $e');
      rethrow;
    }
  }
}
