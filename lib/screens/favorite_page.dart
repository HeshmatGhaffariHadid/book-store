import 'package:flutter/material.dart';
import '../constants.dart';
import '../fav_storage.dart';
import '../model/book.dart';

class FavoritesPage extends StatefulWidget {
  static const routeName = '/favorite';

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}
class _FavoritesPageState extends State<FavoritesPage> {
late List<Book> books;
bool? _isEmpty;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    books = FavStorage.favorites;
  }
  void deleteBook(Book book){
  setState(() {
    FavStorage.removeBook(book);
    books = FavStorage.favorites;
    _isEmpty = FavStorage.favorites.isEmpty;
  });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Favorites')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: _isEmpty ?? false ? Center(
          child: Text('There is no books in favorite list!', style: TextStyle(
            color: Colors.indigo,
            fontSize: 20
          ),),
        ) : ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildFavoriteItem(
                context,
                books[index].title,
                books[index].author,
                books[index].price,
                book
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFavoriteItem(
    BuildContext context,
    String title,
    String author,
    String price,
      Book book
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
            child: const Icon(Icons.book, color: primaryColor, size: 38),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(author, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 4),
              Text(
                price,
                style: const TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              deleteBook(book);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Book deleted')));
            },
          ),
          onTap: () {
            Navigator.pushNamed(context, '/details');
          },
        ),
      ),
    );
  }
}
