import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../widgets/elevated_button.dart';
import '../../widgets/wc_form_title.dart';

class RegisterPin extends StatefulWidget {
  const RegisterPin({super.key});

  @override
  State<RegisterPin> createState() => _RegisterPinState();
}

class _RegisterPinState extends State<RegisterPin> {
  @override
  Widget build(BuildContext context) {
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
                        title: 'Welcome',
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
                        enableActiveFill: true,
                        onCompleted: (v) {},
                        onChanged: (value) {
                          setState(() {
                            // currentText = value;
                          });
                        },
                        beforeTextPaste: (text) {
                          return true;
                        },
                      ),
                      const SizedBox(height: 30),
                      ElevatedBtn(
                        onPressed: () {
                          // conditionRegister(context);
                        },
                        btnText: 'Sign up',
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
