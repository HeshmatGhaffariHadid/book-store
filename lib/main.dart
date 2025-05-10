import 'package:book_store/details_page.dart';
import 'package:book_store/favorite_page.dart';
import 'package:book_store/home_page.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/' : (context) => HomePage(),
        FavoritesPage.routName : (context) => FavoritesPage(),
        DetailsPage.routName : (context) => DetailsPage(),
      },
    );
  }
}
