import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../routes/route.dart';
// import '../providers/auth.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/wc_form_title.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  // bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).primaryColorLight,
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const WCFormTitle(
                      title: 'Register',
                      subtitle: 'Welcome',
                      descr: '',
                    ),
                    registerForm(),
                  ],
                ),
              ),
              bottomText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget registerForm() {
    String? lastname;
    String? firstname;
    String? email;
    String? phone;

    // register check validate form if correct show success else show show failed
    void conditionRegister(context) async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();

        Map<String, dynamic> formData = {
          'last_name': lastname,
          'first_name': firstname,
          'email': email,
          'phone_number': phone,
          'is_active': 1,
        };
        // String jsonData = json.encode(formData);
        // bool isRegister = await registerUser(jsonData);

        // if (isRegister) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       backgroundColor: Theme.of(context).secondaryHeaderColor,
        //       duration: const Duration(seconds: 2),
        //       content: Container(
        //         padding: const EdgeInsets.all(8),
        //         child: Text(
        //           'Register Successfully',
        //           style: Theme.of(context).textTheme.labelLarge,
        //         ),
        //       ),
        //     ),
        //   );
        //   Future.delayed(const Duration(seconds: 3), () {
        //     Navigator.of(context).pushReplacementNamed(RouteList.welcome);
        //   });
        // } else {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       backgroundColor: Theme.of(context).hintColor,
        //       duration: const Duration(seconds: 2),
        //       content: Container(
        //         padding: const EdgeInsets.all(8),
        //         child: Text(
        //           'Register Failed',
        //           style: Theme.of(context).textTheme.titleMedium,
        //         ),
        //       ),
        //     ),
        //   );
        // }
      }
    }

    return
        // Column(
        //   children: [
        //     Expanded(
        //       child:
        Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Last Name',
              labelStyle: Theme.of(context).textTheme.labelLarge,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter Last Name';
              }
              return null;
            },
            onSaved: (value) {
              setState(() {
                lastname = value;
              });
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'First Name',
              labelStyle: Theme.of(context).textTheme.labelLarge,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter First Name';
              }
              return null;
            },
            onSaved: (value) {
              setState(() {
                firstname = value;
              });
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Email',
              labelStyle: Theme.of(context).textTheme.labelLarge,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter Email';
              }
              // check is valid email or not
              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            onSaved: (value) {
              setState(() {
                email = value;
              });
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Phone',
              labelStyle: Theme.of(context).textTheme.labelLarge,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter Phone';
              }
              return null;
            },
            onSaved: (value) {
              setState(() {
                phone = value;
              });
            },
          ),
          const SizedBox(height: 20),
          Text(
            'An OTP will be sent to the mobile number',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          ElevatedBtn(
            onPressed: () {
              Navigator.of(context).pushNamed(RouteList.registerPin);
            },
            btnText: 'Continue',
          ),
        ],
      ),
    );
  }

  Widget bottomText() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Have an account',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(RouteList.login);
              },
              child: Text(
                " Sign in",
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: const Color(0xFFAD49E1)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
