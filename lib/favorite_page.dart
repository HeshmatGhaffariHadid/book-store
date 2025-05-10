import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});
  static const routName = '/favorite';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Favorites')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: ListView(
          children: [
            _buildFavoriteItem(
              context,
              'The Silent Patient',
              'Alex Michael ides',
              'assets/book1.jpg',
              '\$12.99',
            ),
            _buildFavoriteItem(
              context,
              'Educated',
              'Tara Westover',
              'assets/book2.jpg',
              '\$14.99',
            ),
            _buildFavoriteItem(
              context,
              'Atomic Habits',
              'James Clear',
              'assets/book3.jpg',
              '\$10.99',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteItem(
    BuildContext context,
    String title,
    String author,
    String image,
    String price,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          leading: Container(
            width: 50,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey[400],
            ),
            child: const Icon(Icons.book, color: Colors.indigo, size: 38,),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(author, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 4),
              Text(
                price,
                style: const TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {},
          ),
          onTap: () {
            Navigator.pushNamed(context, '/details');
          },
        ),
      ),
    );
  }
}
