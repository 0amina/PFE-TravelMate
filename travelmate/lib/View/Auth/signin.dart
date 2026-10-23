import 'package:flutter/material.dart';
import 'package:travelmate/View/Auth/ForgotPassword.dart';
import 'package:travelmate/View/Auth/signup.dart';
import 'package:travelmate/View/Widgets/custom_bg.dart';
import 'package:travelmate/global.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formSignInKey = GlobalKey<FormState>();
  bool rememberPassword = true;
  bool isLoading = false; // New variable to track loading state

  bool isValidEmail(String email) {
    // Use regex for email validation
    final RegExp emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    // Use regex for password validation
    final RegExp passwordRegex = RegExp(
      r'^[a-zA-Z0-9]+$',
    );
    return passwordRegex.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return CustomBg(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 20,
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 100.0, 0, 0),
              padding: const EdgeInsets.fromLTRB(25.0, 40.0, 25.0, 10.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40.0,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Email';
                          }
                          if (!isValidEmail(value)) {
                            return 'Please enter a valid Email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: Text('Email'),
                          hintText: 'Enter Email',
                          hintStyle: TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Password';
                          }
                          if (!isValidPassword(value)) {
                            return 'Password can only contain letters and numbers';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: Text('Password'),
                          hintText: 'Enter Password',
                          hintStyle: TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: rememberPassword,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        rememberPassword = value!;
                                      });
                                    },
                                    activeColor:
                                        const Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  const Text(
                                    'Remember me',
                                    style: TextStyle(
                                      color: Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ForgotPassword(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Forget password?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 240, 124, 74),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      SizedBox(
                        width: 200.0,
                        height: 45.0,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  setState(() {
                                    isLoading =
                                        true; // Set loading state to true
                                  });
                                  if (_formSignInKey.currentState!.validate() &&
                                      rememberPassword) {
                                    await LoginViewModel.signIn(
                                      context,
                                      emailController.text.trim(),
                                      passwordController.text.trim(),
                                    );
                                  } else if (!rememberPassword) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please agree to the processing of personal data',
                                        ),
                                      ),
                                    );
                                  }
                                  setState(() {
                                    isLoading = false; // Reset loading state
                                  });
                                },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                const Color.fromARGB(255, 255, 146, 99),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: isLoading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : const Text(
                                  'Sign in',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account? ',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Sign up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 237, 129, 83),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}