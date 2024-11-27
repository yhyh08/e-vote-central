import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class AuthController extends ChangeNotifier {
  TextEditingController authController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isCodeSent = false;

  late TwilioFlutter twilioFlutter;

  var sentOTP = 0;

  // showInvisibleWidgets() {
  //   isCodeSent = true;
  //   update();
  // }

  sendSMS() {
    twilioFlutter = TwilioFlutter(
        accountSid: 'ACd71d933d211fe37d288c1878567def95',
        authToken: '49d14fe845f93a4d3395f37fbac18de2',
        twilioNumber: '+15103300932');

    var rnd = Random();

    var digits = rnd.nextInt(900000) + 100000;

    sentOTP = digits;

    print(sentOTP);

    twilioFlutter.sendSMS(
        toNumber: authController.text,
        messageBody: 'Hello This is 6 digit otp code to verify phone $digits');
  }

  verifyOTP(BuildContext context) {
    if (sentOTP.toString() == otpController.text) {
      Fluttertoast.showToast(
        msg: "OTP Verified SuccessFully!",
        backgroundColor: Theme.of(context).focusColor,
      );
    } else {
      Fluttertoast.showToast(
        msg: "OTP didn't match!",
        backgroundColor: Theme.of(context).hintColor,
      );
    }
  }
}
