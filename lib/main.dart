import 'package:flutter/material.dart';
import 'package:monograph/pages/category.dart';
import 'package:monograph/pages/details.dart';
import 'package:monograph/pages/favorites.dart';
import 'package:monograph/pages/home.dart';
import 'package:monograph/pages/signin_signup_pages/SignUp_page.dart';
import 'package:monograph/pages/signin_signup_pages/signIn_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:monograph/service/auth/auth_wrapper.dart';
import 'firebase_options.dart';

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
      theme: ThemeData(appBarTheme: AppBarTheme(elevation: 1)
      ),
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
      routes: {
        HomePage.routeName: (context) => HomePage(),
        FavoritesPage.routeName: (context) => FavoritesPage(),
        DetailsPage.routeName: (context) => DetailsPage(),
        SignInPage.routeName: (context) => SignInPage(),
        SignUpPage.routeName: (context) => SignUpPage(),
        CategoryList.routeName: (context) => CategoryList()
      },
    );
  }
}