import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../custom-widgets/text_form_field.dart';
import '../home_page.dart';
import 'SignUp_page.dart';

class SignInPage extends StatefulWidget {
  static const routeName = '/signIn';

  SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailNode = FocusNode();
  final passwordNode = FocusNode();

  bool obSecureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF5F5F5),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap:  () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey ,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 30,
                  children: [
                    Text(
                      'Welcome Back 😊',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomTextFormField(
                      node: emailNode,
                      controller: emailController,
                      label: 'Enter your email',
                      inputType: TextInputType.emailAddress,
                    ),
                    CustomTextFormField(
                      node: passwordNode,
                      controller: passwordController,
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
                                : Icon(Icons.visibility_outlined, color: Colors.indigo),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if(_formKey.currentState!.validate()){
                          if(emailController.text == "heshmat@gmail.com" && passwordController.text == "12344321"){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You logged in successfully into your account')));
                            Future.delayed(Duration(seconds: 1));
                            Navigator.pushReplacementNamed(context, HomePage.routName);
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User account not found!')));
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 4,
                      ),
                      child: Text('Login', style: TextStyle(fontSize: 20)),
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
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                        minimumSize: Size(double.infinity, 50),
                        elevation: 4,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, SignUpPage.routeName);
                      },
                      child: Text(
                        'Create an Account',
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
