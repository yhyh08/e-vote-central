import 'package:flutter/material.dart';

import '../../routes/route.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/wc_form_title.dart';
import 'auth_controller.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String? phoneNumber;
    AuthController controller = AuthController();

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
                                hintStyle:
                                    Theme.of(context).textTheme.labelSmall,
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
                                  phoneNumber = value;
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
                            controller.sendSMS();
                            Navigator.of(context).pushNamed(RouteList.loginPin);
                          }
                        },
                        btnText: 'Continue',
                      ),
                    ]),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an Account? ",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed(RouteList.register);
                        },
                        child: Text(
                          " Sign up",
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: const Color(0xFFAD49E1)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
