import 'package:flutter/material.dart';
import 'package:monograph/model/book.dart';
import 'package:monograph/model/categories.dart';

class CategoryList extends StatefulWidget {
  static String routeName = '/category-list';
  final String? categoryName;

  CategoryList({this.categoryName});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {

  late List<Book> books = [];

  @override
  void initState() {
    insertBooks(widget.categoryName ?? '');
    super.initState();
  }

  void insertBooks (String name) {
    switch (name) {
      case 'Science' :
        books = Categories.science;
        break;
      case 'Art' :
        books = Categories.art;
        break;
      case 'Programming' :
        books = Categories.programming;
        break;
      case 'Literature' :
        books = Categories.literature;
        break;
      default :
        books = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Category name"),
      ),
    );
  }
}
