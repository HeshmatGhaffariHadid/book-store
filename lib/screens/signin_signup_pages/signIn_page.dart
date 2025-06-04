import 'package:book_store/constants.dart';
import 'package:book_store/custom-widgets/text_form_field.dart';
import 'package:book_store/screens/signin_signup_pages/SignUp_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignInPage extends StatefulWidget {
  static const routeName = '/signIn';

  SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final usernameNode = FocusNode();
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
                      'Sign In 😊',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomTextFormField(
                      node: usernameNode,
                      controller: usernameController,
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
                                : Icon(Icons.visibility_outlined),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if(usernameController.text == 'heshmat' && passwordController.text == '0093h'){
                          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 4,
                      ),
                      child: Text('Sign In', style: TextStyle(fontSize: 20)),
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
