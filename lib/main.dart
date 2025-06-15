import 'package:book_store/screens/details_page.dart';
import 'package:book_store/screens/favorite_page.dart';
import 'package:book_store/screens/home_page.dart';
import 'package:book_store/screens/signin_signup_pages/SignUp_page.dart';
import 'package:book_store/screens/signin_signup_pages/signIn_page.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
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
        '/' : (context) => HomePage(),
        FavoritesPage.routeName : (context) => FavoritesPage(),
        DetailsPage.routeName : (context) => DetailsPage(),
        SignInPage.routeName : (context) => SignInPage(),
        SignUpPage.routeName : (context) => SignUpPage()
      },
    );
  }
}
