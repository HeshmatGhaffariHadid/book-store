import 'package:flutter/material.dart';
import '../service/book_services.dart';
import '../constants/constants.dart';
import '../model/book.dart';
import 'details.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});
  static const routeName = '/categoryList';

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List<Book> categoryBooks = [];
  bool isLoading = true;
  String? categoryName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      categoryName = arguments['category'] as String?;
      _loadCategoryBooks();
    }
  }

  Future<void> _loadCategoryBooks() async {
    if (categoryName == null) return;

    setState(() => isLoading = true);
    try {
      final fetchedBooks = await BookService.getBooksByCategory(categoryName!);
      if (mounted) {
        setState(() {
          categoryBooks = fetchedBooks;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading books for category: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName != null ? '$categoryName Books' : 'Category Books'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: categoryBooks.isEmpty
            ? Center(
          child: Text(
            'No books found for ${categoryName ?? 'this category'}.',
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
        )
            : ListView.builder(
          itemCount: categoryBooks.length,
          itemBuilder: (context, index) {
            final book = categoryBooks[index];
            return _buildBookItem(context, book);
          },
        ),
      ),
    );
  }

  Widget _buildBookItem(BuildContext context, Book book) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey[200],
          ),
          child: const Icon(Icons.book, size: 40, color: primaryColor),
        ),
        title: Text(
          book.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(book.author, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
            Text('Price: \$${book.price}', style: const TextStyle(fontSize: 14, color: primaryColor)),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            DetailsPage.routeName,
            arguments: {
              'id': book.id,
              'title': book.title,
              'author': book.author,
              'description': book.description,
              'category': book.categoryName,
              'price': book.price,
            },
          );
        },
      ),
    );
  }
}
