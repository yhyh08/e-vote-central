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

  // Check if phone exists in users table
  Future<bool> validatePhoneNumber() async {
    try {
      String phoneNumber = authController.text.trim();
      if (!phoneNumber.startsWith('+')) {
        phoneNumber = '+$phoneNumber';
      }
      phoneNumber = phoneNumber.replaceAll(' ', '').replaceAll('-', '');

      print('Checking phone number: $phoneNumber');

      final response = await _network.getData('/check-user/$phoneNumber');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['exists'] == true) {
          isCodeSent = false; // Reset code sent status
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error validating phone number: $e');
      return false;
    }
  }

  Future<bool> sendOTP() async {
    try {
      String phoneNumber = authController.text.trim();
      if (!phoneNumber.startsWith('+')) {
        phoneNumber = '+$phoneNumber';
      }
      phoneNumber = phoneNumber.replaceAll(' ', '').replaceAll('-', '');

      print('Sending OTP to: $phoneNumber');

      final response = await _network.authData({
        'phone': phoneNumber,
      }, '/send-otp');

      print('OTP request response status: ${response.statusCode}');
      print('OTP request response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          // Store the debug OTP if provided
          if (data['debug_otp'] != null) {
            print('Debug OTP received: ${data['debug_otp']}');
            // Auto-fill OTP in development
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
      }

      Fluttertoast.showToast(
        msg: "Failed to send OTP",
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
      phoneNumber = phoneNumber.replaceAll(' ', '').replaceAll('-', '');

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
