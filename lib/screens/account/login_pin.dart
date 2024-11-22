import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../routes/route.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/wc_form_title.dart';
import 'auth_controller.dart';

class LoginPin extends StatefulWidget {
  const LoginPin({
    required this.phoneNum,
    super.key,
  });

  final String phoneNum;

  @override
  State<LoginPin> createState() => _LoginPinState();
}

class _LoginPinState extends State<LoginPin> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AuthController controller = AuthController();

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).primaryColorLight,
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Theme.of(context).highlightColor,
                    size: 25,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const WCFormTitle(
                      title: 'Hello.',
                      subtitle: ' Enter 6-digit OTP',
                      descr:
                          'An OTP will sent to this mobile number for verification',
                    ),
                    const SizedBox(height: 20),
                    PinCodeTextField(
                      appContext: context,
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      keyboardType: TextInputType.number,
                      enableActiveFill: true,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(3),
                        fieldHeight: 45,
                        fieldWidth: 45,
                        activeFillColor: Theme.of(context).splashColor,
                        activeColor: Theme.of(context).splashColor,
                        inactiveColor: Theme.of(context).dividerColor,
                        inactiveFillColor: Theme.of(context).dividerColor,
                        selectedColor: Theme.of(context).primaryColor,
                        selectedFillColor: Theme.of(context).shadowColor,
                      ),
                      animationDuration: const Duration(milliseconds: 300),
                      controller: controller.otpController,
                      validator: (String? number) {
                        if (number!.isEmpty) {
                          return "Enter Phone Number";
                        }
                        return null;
                      },
                      onCompleted: (v) {
                        print("Completed");
                      },
                      onChanged: (value) {
                        controller.otpController.text = value;
                      },
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        return true;
                      },
                    ),
                    const SizedBox(height: 30),
                    ElevatedBtn(
                      onPressed: () async {
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          controller.verifyOTP(context);
                        }
                        Navigator.of(context)
                            .pushReplacementNamed(RouteList.dashboard);
                      },
                      btnText: 'Sign in',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
