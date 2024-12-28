import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../network_utlis/api.dart';
import '../../routes/route.dart';

class AuthController extends ChangeNotifier {
  TextEditingController authController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final Network _network = Network();
  bool isCodeSent = false;

  Future<bool> validatePhoneNumber() async {
    try {
      String phoneNumber = authController.text.trim();
      if (!phoneNumber.startsWith('+')) {
        phoneNumber = '+$phoneNumber';
      }

      final response = await _network.getData('/check-user/$phoneNumber');

      final data = json.decode(response.body);

      if (response.statusCode == 404) {
        Fluttertoast.showToast(
          msg: data['message'] ?? "Phone number not registered",
          backgroundColor: Colors.red,
        );
        return false;
      }

      if (response.statusCode == 200 && data['exists'] == true) {
        isCodeSent = false;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error validating phone number: $e');
      Fluttertoast.showToast(
        msg: "Error checking phone number",
        backgroundColor: Colors.red,
      );
      return false;
    }
  }

  Future<bool> sendOTP() async {
    try {
      String phoneNumber = authController.text.trim();
      if (!phoneNumber.startsWith('+')) {
        phoneNumber = '+$phoneNumber';
      }

      print('Sending OTP to: $phoneNumber');

      final response = await _network.authData({
        'phone': phoneNumber,
      }, '/send-otp');

      print('OTP request response status: ${response.statusCode}');
      print('OTP request response body: ${response.body}');

      final data = json.decode(response.body);

      if (response.statusCode == 404) {
        Fluttertoast.showToast(
          msg: data['message'] ?? "Phone number not registered",
          backgroundColor: Colors.red,
        );
        return false;
      }

      if (response.statusCode == 200 && data['status'] == true) {
        // Store the debug OTP if provided
        if (data['debug_otp'] != 'Wait') {
          print('Debug OTP received: ${data['debug_otp']}');
          otpController.text = data['debug_otp'].toString();
        }

        isCodeSent = true;
        notifyListeners();

        Fluttertoast.showToast(
          msg: "OTP sent successfully. Debug OTP: ${data['debug_otp']}",
          backgroundColor: Colors.green,
          timeInSecForIosWeb: 4,
        );
        return true;
      }

      Fluttertoast.showToast(
        msg: data['message'] ?? "Failed to send OTP",
        backgroundColor: Colors.red,
      );
      return false;
    } catch (e) {
      print('Error sending OTP: $e');
      Fluttertoast.showToast(
        msg: "Failed to send OTP: ${e.toString()}",
        backgroundColor: Colors.red,
      );
      return false;
    }
  }

  Future<bool> verifyOTP(BuildContext context) async {
    try {
      print('Starting OTP verification...');

      String phoneNumber = authController.text.trim();
      if (!phoneNumber.startsWith('+')) {
        phoneNumber = '+$phoneNumber';
      }

      print('Verifying OTP for phone: $phoneNumber');
      print('Entered OTP: ${otpController.text}');

      final response = await _network.authData({
        'phone': phoneNumber,
        'otp': otpController.text,
      }, '/verify-otp');

      print('Verification response received');
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        await localStorage.setString('token', json.encode(data));

        // Store the phone number
        await localStorage.setString('user_phone', phoneNumber);

        Fluttertoast.showToast(
          msg: "Login successful!",
          backgroundColor: Theme.of(context).focusColor,
        );

        Navigator.of(context).pushReplacementNamed(RouteList.dashboard);
        return true;
      }

      Fluttertoast.showToast(
        msg: data['message'] ?? "Verification failed",
        backgroundColor: Theme.of(context).hintColor,
      );
      return false;
    } catch (e) {
      print('Error during verification: $e');
      Fluttertoast.showToast(
        msg: "Verification failed: ${e.toString()}",
        backgroundColor: Theme.of(context).hintColor,
      );
      return false;
    }
  }
}
