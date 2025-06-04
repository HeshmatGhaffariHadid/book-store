import 'package:book_store/screens/details_page.dart';
import 'package:book_store/screens/favorite_page.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Store'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.red[500]),
            onPressed: () {
              Navigator.pushNamed(context, FavoritesPage.routeName);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Featured Books',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildFeaturedBook(
                    context,
                    'The Silent Patient',
                    'Alex Michael ides',
                    'description',
                    12.99,
                  ),
                  const SizedBox(width: 16),
                  _buildFeaturedBook(
                    context,
                    'Educated',
                    'Tara West over',
                    'description',
                    14.99,
                  ),
                  const SizedBox(width: 16),
                  _buildFeaturedBook(
                    context,
                    'Atomic Habits',
                    'James Clear',
                    'description',
                    10.99,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Popular Categories',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap:
                  true, //  grid should take as much space as its children
              physics:
                  const NeverScrollableScrollPhysics(), // Controls scroll behavior
              crossAxisCount: 2, // number of columns
              childAspectRatio: 3, // width to height ratio of each tile
              crossAxisSpacing: 16, // Spacing between rows
              mainAxisSpacing: 16, // Spacing between rows
              children: [
                _buildCategory('Fiction', Icons.menu_book),
                _buildCategory('Science', Icons.science),
                _buildCategory('History', Icons.history),
                _buildCategory('Biography', Icons.person),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedBook(
    BuildContext context,
    String title,
    String author,
    String description,
    double price,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          DetailsPage.routeName,
          arguments: <String, String>{
            'title': title,
            'author': author,
            'description': description,
            'price': price.toString(),
          },
        );
      },
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
              FittedBox(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              FittedBox(
                child: Text(
                  author,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$price',
                style: const TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategory(String name, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height: 80,
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Hello',
                    style: TextStyle(fontSize: 24, color: primaryColor),
                  ),
                ),
              );
            },
          );
        });
      },
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(icon, color: primaryColor),
              const SizedBox(width: 8),
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
