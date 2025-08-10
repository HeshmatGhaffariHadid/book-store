import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../custom-widgets/text_form_field.dart';
import '../home_page.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});
  static const routeName = '/signUp';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailNode = FocusNode();
  final _passwordNode = FocusNode();
  final _registerNode = FocusNode();

  bool obSecureText = true;
  String errorMessage = '';
  final auth = FirebaseAuth.instance;

  void dispose() {
    _emailController.dispose();
    _emailNode.dispose();
    _passwordController.dispose();
    _passwordNode.dispose();
    _registerNode.dispose();
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
                      node: _emailNode,
                      controller: _emailController,
                      label: 'Enter your email',
                      inputType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'email can not be empty!';
                        } else if (!RegExp(
                          r'^[^@]+@[^@]+\.[^@]+',
                        ).hasMatch(value)) {
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
                                : Icon(
                                  Icons.visibility_outlined,
                                  color: Colors.indigo,
                                ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'password can not be empty!';
                        } else if (value.length < 8) {
                          return 'password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20, child: Text(errorMessage, style: TextStyle(
                      color: Colors.red
                    ),textAlign: TextAlign.center,),),
                    ElevatedButton(
                      focusNode: _registerNode,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            print('🟡 user is signing up...');
                            await auth
                                .createUserWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                )
                                .then((value) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    HomePage.routName,
                                  );
                                });
                            print('🟢 user signed up successfully');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Welcome back')),
                            );
                          } catch (e) {
                            print('🔴 Failed to sign-up, error: $e');
                            setState(() {
                              errorMessage = e.toString().split('] ')[1];
                            });
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to sign-up!')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 4,
                      ),
                      child: Text('Register', style: TextStyle(fontSize: 20)),
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
    focusNode: focusNode,
    onSaved: (value) {
      FocusScope.of(context).requestFocus(nextNode);
    },
  );
}
