
import 'model/book.dart';

class FavStorage {
  static final List<Book> favorites = [
    Book(
      title: 'Learn JAVA',
      author: 'James Ghosling',
      description:
      'Learning JAVA is quite simple if you this book as your main reference in the your coding world',
      price: '20.3',
    ),
  ];

  static void addFavorite(Book book) {
    favorites.add(book);
  }

  static void removeBook(Book book) {
    favorites.remove(book);
  }
}
