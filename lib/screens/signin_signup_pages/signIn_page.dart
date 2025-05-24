import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  static const routeName = '/signIn';

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final usernameNode = FocusNode();
  final passwordNode = FocusNode();

  SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 30,
            children: [
              Text(
                'Sign In 😊',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildTextField(
                label: 'Enter Your Name',
                controller: usernameController,
                focusNode: usernameNode,
              ),
              _buildTextField(
                label: 'Enter Your Password',
                controller: passwordController,
                focusNode: passwordNode,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  elevation: 4,
                ),
                child: Text('Sign In', style: TextStyle(fontSize: 18)),
              ),
              Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    child: Text('or', style: TextStyle(fontSize: 22)),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.grey[700],
                  minimumSize: Size(double.infinity, 50),
                  elevation: 1
                ),
                onPressed: () {},
                child: Text(
                  'Create an Account',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextField _buildTextField({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        enabled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black38, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
        ),
      ),
      focusNode: focusNode,
    );
  }
}
