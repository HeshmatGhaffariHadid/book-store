import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monograph/pages/category.dart';
import 'package:monograph/pages/signin_signup_pages/signIn_page.dart';
import '../service/book_services.dart';
import '../constants/constants.dart';
import '../model/book.dart';
import 'details.dart';
import 'favorites.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const routeName = '/homePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final titleNode = FocusNode();
  final authorNode = FocusNode();
  final descNode = FocusNode();
  final pricesNode = FocusNode();
  final auth = FirebaseAuth.instance;

  List<Book> books = [];
  List<String> categories = [];
  bool isLoading = true;
  String? selectedCategoryName;
  String? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    titleController.dispose();
    authorController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    titleNode.dispose();
    authorNode.dispose();
    descNode.dispose();
    pricesNode.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    try {
      final fetchedBooks = await BookService.getBooks();
      final fetchedCategoriesData = await BookService.getCategories();
      final fetchedCategoryNames = fetchedCategoriesData.map((c) => c['name'] as String).toList();

      if (mounted) {
        setState(() {
          books = fetchedBooks;
          categories = fetchedCategoryNames;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
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
        title: const Text('Book Store', style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black87),
            onPressed: () async {
              await auth.signOut();
              if (mounted) {
                Navigator.pushReplacementNamed(context, SignInPage.routeName);
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
                color: Colors.indigo,
              ),
              onPressed: () {
                Navigator.pushNamed(context, FavoritesPage.routeName);
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Featured Books',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: books.isEmpty
                  ? const Center(child: Text('No books available'))
                  : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return _buildFeaturedBook(context, books[index]);
                },
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Popular Categories',
              style:TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: categories.map((category) {
                  return _buildCategory(category, _getCategoryIcon(category));
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0XFFF5F5F5),
        onPressed: _showBottomSheet,
        child: const Icon(Icons.add, color: Colors.indigo, size: 30),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'science':
        return Icons.science;
      case 'programming':
        return Icons.computer;
      case 'art':
        return Icons.palette;
      case 'general':
        return Icons.category;
      case 'mathematical':
        return Icons.calculate;
      case 'medical':
        return Icons.medical_services;
      default:
        return Icons.book;
    }
  }

  Future<void> _showBottomSheet() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 420,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Add New Book',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: titleController,
                label: 'Book Title',
                node: titleNode,
                nextNode: authorNode,
              ),
              _buildTextField(
                controller: authorController,
                label: 'Author Name',
                node: authorNode,
                nextNode: descNode,
              ),
              _buildTextField(
                controller: descriptionController,
                label: 'Description',
                node: descNode,
                nextNode: pricesNode,
              ),
              _buildTextField(
                controller: priceController,
                label: 'Price',
                node: pricesNode,
              ),
              const SizedBox(height: 16),
              _buildCategoryDropdown(),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _addNewBook,
                    child: const Text('Add Book'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCategoryName,
      decoration: const InputDecoration(
        labelText: 'Category',
      ),
      items: categories
          .map((category) => DropdownMenuItem(
        value: category,
        child: Text(category),
      ))
          .toList(),
      onChanged: (String? value) async {
        setState(() {
          selectedCategoryName = value;
        });
        if (value != null) {
          final categoryData = await BookService.getCategories();
          final selectedCat = categoryData.firstWhere((cat) => cat['name'] == value);
          selectedCategoryId = selectedCat['id'];
        }
      },
      validator: (value) =>
      value == null ? 'Please select a category' : null,
    );
  }

  Future<void> _addNewBook() async {
    if (titleController.text.isEmpty ||
        authorController.text.isEmpty ||
        priceController.text.isEmpty ||
        selectedCategoryName == null ||
        selectedCategoryId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all required fields')),
        );
      }
      return;
    }

    try {
      final newBook = Book(
        id: '',
        title: titleController.text,
        author: authorController.text,
        description: descriptionController.text,
        price: priceController.text,
        categoryId: selectedCategoryId,
        categoryName: selectedCategoryName!,
      );

      await BookService.addNewBook(newBook.toFirestore());

      titleController.clear();
      authorController.clear();
      descriptionController.clear();
      priceController.clear();
      setState(() {
        selectedCategoryName = null;
        selectedCategoryId = null;
      });

      await _loadData();
      if (mounted) Navigator.pop(context);

    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding book: ${e.toString()}')),
        );
      }
    }
  }

  TextField _buildTextField({
    required TextEditingController controller,
    required String label,
    required FocusNode node,
    FocusNode? nextNode,
  }) {
    return TextField(
      focusNode: node,
      controller: controller,
      textInputAction: nextNode != null ? TextInputAction.next : TextInputAction.done,
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.indigo, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),
      onSubmitted: (_) => FocusScope.of(context).requestFocus(nextNode),
    );
  }

  Widget _buildFeaturedBook(BuildContext context, Book book) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
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
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: Card(
          elevation: 4,
          child: Container(
            width: 120,
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey[200],
                    ),
                    child: const Icon(Icons.book, size: 60, color: primaryColor),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  book.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  book.author,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${book.price}',
                  style: const TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategory(String name, IconData icon) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        CategoryList.routeName,
        arguments: {'category': name},
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Icon(icon, color: primaryColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
