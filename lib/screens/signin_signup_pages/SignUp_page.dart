import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../custom-widgets/text_form_field.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});
  static const routeName = '/signUp';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _usernameNode = FocusNode();
  final _emailNode = FocusNode();
  final _passwordNode = FocusNode();
  final _submitNode = FocusNode();

  bool obSecureText = true;

  void dispose() {
    _usernameController.dispose();
    _usernameNode.dispose();
    _emailController.dispose();
    _emailNode.dispose();
    _passwordController.dispose();
    _passwordNode.dispose();
    _submitNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Back')),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 30,
                  children: [
                    Text(
                      'Create an Account 😊',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    CustomTextFormField(
                      node: _usernameNode,
                      controller: _usernameController,
                      label: 'Enter your name',
                      inputType: TextInputType.text,
                    ),
                    CustomTextFormField(
                      node: _emailNode,
                      controller: _emailController,
                      label: 'Enter your email',
                      inputType: TextInputType.emailAddress,
                      validator: (value) {
                        if(value == null || value.isEmpty) {
                          return 'email can not be empty!';
                        }else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)){
                          return 'invalid email!';
                        }
                        return null;
                      },
                    ),
                    CustomTextFormField(
                      node: _passwordNode,
                      controller: _passwordController,
                      label: 'Enter your password',
                      hideText: obSecureText,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obSecureText = !obSecureText;
                          });
                        },
                        icon:
                            obSecureText
                                ? Icon(Icons.visibility_off_outlined)
                                : Icon(Icons.visibility_outlined),
                      ),
                      validator: (value) {
                        if(value == null || value.isEmpty) {
                          return 'password can not be empty!';
                        }  else if (value.length < 8) {
                          return 'password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      focusNode: _submitNode,
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 4,
                      ),
                      child: Text(
                        'Submit Date',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

TextFormField _buildTextField({
  required BuildContext context,
  required String label,
  required TextEditingController controller,
  required FocusNode focusNode,
  required FocusNode nextNode,
  required Function validate,
}) {
  return TextFormField(
    controller: controller,
    obscureText: label.split(' ').contains('Password') ? true : false,
    enabled: true,
    decoration: InputDecoration(
      labelText: label,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black38, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
      ),
    ),
    // forceErrorText: label.split(' ').contains('Password') ? 'hello' : null,
    focusNode: focusNode,
    onSaved: (value) {
      FocusScope.of(context).requestFocus(nextNode);
    },
  );
}
