import 'package:flutter/material.dart';

import '../../widgets/elevated_button.dart';
import '../../widgets/wc_form_title.dart';
import 'auth_controller.dart';
import 'login_pin.dart';

class Login extends StatefulWidget {
  const Login({
    super.key,
  });

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  AuthController controller = AuthController();

  @override
  Widget build(BuildContext context) {
    String phoneNum;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).primaryColorLight,
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const WCFormTitle(
                      title: 'Hello.',
                      subtitle: 'Welcome Back',
                      descr: 'An OTP will sent to this mobile number',
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Phone',
                              labelStyle:
                                  Theme.of(context).textTheme.labelLarge,
                              hintText: '+60xxxxxxxxx',
                              hintStyle: Theme.of(context).textTheme.labelSmall,
                            ),
                            controller: controller.authController,
                            validator: (String? number) {
                              if (number == null || number.isEmpty) {
                                return "Enter a valid phone number";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                var phoneNum = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedBtn(
                      onPressed: () {
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          phoneNum = controller.authController.text;
                          controller.sendSMS();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  LoginPin(phoneNum: phoneNum),
                            ),
                          );
                        }
                      },
                      btnText: 'Continue',
                    ),
                  ],
                ),
              ),
              // Column(
              //   children: [
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Text(
              //           "Don't have an Account? ",
              //           style: Theme.of(context).textTheme.labelSmall,
              //         ),
              //         GestureDetector(
              //           onTap: () {
              //             Navigator.of(context)
              //                 .pushReplacementNamed(RouteList.register);
              //           },
              //           child: Text(
              //             " Sign up",
              //             style: Theme.of(context)
              //                 .textTheme
              //                 .labelSmall
              //                 ?.copyWith(color: Theme.of(context).primaryColor),
              //           ),
              //         ),
              //       ],
              //     ),
              //     const SizedBox(height: 10),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
