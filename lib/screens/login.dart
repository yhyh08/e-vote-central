import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../routes/route.dart';
import '../gen/assets.gen.dart';
// import '../providers/auth.dart';
import '../widgets/elevated_button.dart';
import '../widgets/wc_form_title.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    String? phoneNumber;
    String? passwords;

    // login check user identity if correct show success on bottom else show invalid
    void conditionLogin(context) async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();

        // bool isLoggined = await fetchUserData(phoneNumber, passwords);

        // if (isLoggined) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       backgroundColor: Theme.of(context).secondaryHeaderColor,
        //       duration: const Duration(seconds: 2),
        //       content: Container(
        //         padding: const EdgeInsets.all(8),
        //         child: Text(
        //           'Login Successfully',
        //           style: Theme.of(context).textTheme.labelLarge,
        //         ),
        //       ),
        //     ),
        //   );
        //   Future.delayed(const Duration(seconds: 3), () {
        //     Navigator.of(context).pushReplacementNamed(RouteList.dashboard);
        //   });
        // } else {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       backgroundColor: Theme.of(context).hintColor,
        //       duration: const Duration(seconds: 2),
        //       content: Container(
        //         padding: const EdgeInsets.all(8),
        //         child: Text(
        //           'Invalid Phone Num or Password',
        //           style: Theme.of(context).textTheme.titleMedium,
        //         ),
        //       ),
        //     ),
        //   );
        // }
      }
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height / 4,
        ),
        child: const WCFormTitle(
          title: 'Signin',
          descr: 'Welcome Back',
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Phone',
                              labelStyle:
                                  Theme.of(context).textTheme.labelLarge,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter Phone';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                phoneNumber = value;
                              });
                            },
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                              labelText: 'Password',
                              labelStyle:
                                  Theme.of(context).textTheme.labelLarge,
                              // show and hide password
                              suffixIcon: IconButton(
                                icon: _isObscure
                                    ? SvgPicture.asset(Assets.svg.eyeOpen)
                                    : SvgPicture.asset(Assets.svg.eyeClose),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              ),
                            ),
                            obscureText: _isObscure,
                            onSaved: (value) {
                              setState(() {
                                passwords = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter Password';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedBtn(
                      onPressed: () {
                        conditionLogin(context);
                      },
                      btnText: 'Signin',
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      // onTap: () {
                      //   Navigator.of(context)
                      //       .pushReplacementNamed(RouteList.register);
                      // },
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'No an Account',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Icon(
                                Icons.arrow_right_alt,
                                color: Theme.of(context).highlightColor,
                                size: 30,
                              ),
                            ),
                          )
                        ],
                      ),
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
