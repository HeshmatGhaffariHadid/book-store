import 'package:flutter/material.dart';

import '../constants.dart';

class DetailsPage extends StatelessWidget {
  static const routeName = '/details';
  final String? title;
  final String? author;
  final String? description;
  final double? price;

  const DetailsPage({
    super.key,
     this.title,
     this.author,
     this.description,
     this.price,
  });

  @override
  Widget build(BuildContext context) {

    final routeArguments = ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    final bookTitle = routeArguments['title'];
    final bookAuthor = routeArguments['author'];
    final bookDescription = routeArguments['description'];
    final bookPrice = routeArguments['price'];

    return Scaffold(
      appBar: AppBar(title: const Text('Book Details')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 240,
                  width: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  child: const Icon(
                    Icons.book,
                    size: 100,
                    color: primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                bookTitle ?? 'No title provided',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                bookAuthor ?? 'No author found',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildStars(4.5),
                  const SizedBox(width: 8),
                  const Text('4.5 (1,234 reviews)'),
                ],
              ),
              const SizedBox(height: 16),
              Text('Price', style: TextStyle(color: Colors.grey[700])),
              Text(
                '\$$bookPrice',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              const Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(bookDescription ?? 'No description provided', style: TextStyle(height: 1.5)),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 5,
                    backgroundColor: Colors.indigo[400],
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add to Cart'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStars(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor() ? Icons.star : Icons.star_half,
          color: Colors.orangeAccent,
          size: 20,
        );
      }),
    );
  }
}
