import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  final String _url = 'http://192.168.68.107:8000/api/v1';
  var token;

  final http.Client _client = http.Client();

  getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token') ?? '')['token'];
  }

  authData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
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
    var fullUrl = _url + apiUrl;
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
}
