import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../custom-widgets/text_form_field.dart';
import '../home.dart';

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
  bool loggingIn = false;

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
      appBar: AppBar(
        backgroundColor: const Color(0XFFF5F5F5),
        elevation: 0,
          title: Text('Back'),
      ),
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
                    SizedBox(
                      height: 20,
                      child: Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ElevatedButton(
                      focusNode: _registerNode,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            loggingIn = true;
                          });
                          try {
                            await auth
                                .createUserWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                )
                                .then((value) {
                                  setState(() {
                                    loggingIn = false;
                                  });
                                  Navigator.pushReplacementNamed(
                                    context,
                                    HomePage.routeName,
                                  );
                                });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Welcome back')),
                            );
                          } catch (e) {
                            setState(() {
                              loggingIn = false;
                              errorMessage = e.toString().split('] ')[1];
                            });
                          }
                        } else {
                          setState(() {
                            loggingIn = false;
                          });
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
                      child:
                          loggingIn
                              ? CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 1,
                              )
                              : Text(
                                'Register',
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
