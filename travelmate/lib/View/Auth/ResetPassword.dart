import 'package:flutter/material.dart';
import 'package:travelmate/ViewModel/Auth/ResetPwd_view_model.dart';

class NewPassword extends StatefulWidget {
  final String email;
  final String resetCode;

  const NewPassword({
    Key? key,
    required this.email,
    required this.resetCode,
  }) : super(key: key);

  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final TextEditingController _passwordController = TextEditingController();
  late ResetPwdViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ResetPwdViewModel(widget.resetCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/bg2.png', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          // Main content with AppBar
          Column(
            children: [
              // Custom AppBar
              PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: const Text(
                    'Reset Password',
                    style: TextStyle(color: Colors.white), // Change text color to white
                  ),
                  iconTheme: const IconThemeData(color: Colors.white), // Change back arrow color to white
                ),
              ),
              // Main content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 140.0),
                      Text(
                        'Enter your new password for ${widget.email}.',
                        style: const TextStyle(fontSize: 16.0, color: Color.fromARGB(255, 0, 0, 0),fontWeight: FontWeight.bold), // Change text color to white
                      ),
                      const SizedBox(height: 30.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white), // Change text color to white
                        decoration: const InputDecoration(
                          labelText: 'New Password',
                          labelStyle: TextStyle(color: Color.fromARGB(255, 63, 61, 61), fontWeight: FontWeight.normal), // Change label color to white
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(10.0)), // Add border radius
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(10.0)), // Add border radius
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Center( // Centering the button horizontally
                        child: ElevatedButton(
                          onPressed: () {
                            _viewModel.resetPassword(context, _passwordController.text);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: const Color.fromARGB(255, 255, 146, 99),
                            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0), // Smaller border radius
                            ),
                          ),
                          child: const Text('Reset Password'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
