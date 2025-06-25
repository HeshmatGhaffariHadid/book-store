import 'package:flutter/material.dart';
import 'package:monograph/screens/details_page.dart';
import 'package:monograph/screens/favorite_page.dart';
import 'package:monograph/screens/home_page.dart';
import 'package:monograph/screens/signin_signup_pages/SignUp_page.dart';
import 'package:monograph/screens/signin_signup_pages/signIn_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SignInPage.routeName,
      routes: {
        HomePage.routName : (context) => HomePage(),
        FavoritesPage.routeName : (context) => FavoritesPage(),
        DetailsPage.routeName : (context) => DetailsPage(),
        SignInPage.routeName : (context) => SignInPage(),
        SignUpPage.routeName : (context) => SignUpPage()
      },
    );
  }
}
