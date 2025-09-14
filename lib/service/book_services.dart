import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:monograph/model/book.dart';

class BookService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<List<Book>> getBooks() async {
    final snapshot = await _db.collection('books').orderBy('title').get();
    return snapshot.docs.map((doc) => Book.fromFirestore(doc)).toList();
  }

  static Future<List<Map<String, dynamic>>> getCategories() async {
    final snapshot = await _db.collection('categories').orderBy('name').get();
    return snapshot.docs.map((doc) => {
      'id': doc.id,
      'name': doc['name'] as String,
    }).toList();
  }

  static Future<void> addNewBook(Map<String, dynamic> newBookData) async {
    await _db.collection('books').add(newBookData);
  }

  static Future<void> addToFavorites(String bookId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final existingFavorite = await _db.collection('favorites')
        .where('user_id', isEqualTo: userId)
        .where('book_id', isEqualTo: bookId)
        .limit(1)
        .get();

    if (existingFavorite.docs.isEmpty) {
      await _db.collection('favorites').add({
        'book_id': bookId,
        'user_id': userId,
        'created_at': Timestamp.now(),
      });
    }
  }

  static Future<List<Book>> getFavorites() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return [];

    final favoriteDocs = await _db.collection('favorites')
        .where('user_id', isEqualTo: userId)
        .get();

    if (favoriteDocs.docs.isEmpty) return [];

    final List<String> bookIds = favoriteDocs.docs.map((doc) => doc['book_id'] as String).toList();

    final List<Book> favoriteBooks = [];
    if (bookIds.isNotEmpty) {
      for (int i = 0; i < bookIds.length; i += 10) {
        final batchIds = bookIds.sublist(i, (i + 10 > bookIds.length) ? bookIds.length : i + 10);
        final booksSnapshot = await _db.collection('books').where(FieldPath.documentId, whereIn: batchIds).get();
        for (var doc in booksSnapshot.docs) {
          favoriteBooks.add(Book.fromFirestore(doc));
        }
      }
    }
    return favoriteBooks;
  }

  static Future<void> deleteFavorite(String bookId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final favoriteToDelete = await _db.collection('favorites')
        .where('user_id', isEqualTo: userId)
        .where('book_id', isEqualTo: bookId)
        .limit(1)
        .get();

    if (favoriteToDelete.docs.isNotEmpty) {
      await _db.collection('favorites').doc(favoriteToDelete.docs.first.id).delete();
    }
  }

  static Future<List<Book>> getBooksByCategory(String categoryName) async {
    final categorySnapshot = await _db.collection('categories')
        .where('name', isEqualTo: categoryName)
        .limit(1)
        .get();

    if (categorySnapshot.docs.isEmpty) {
      return [];
    }

    final categoryId = categorySnapshot.docs.first.id;

    final booksSnapshot = await _db.collection('books')
        .where('category_id', isEqualTo: categoryId)
        .orderBy('title')
        .get();

    return booksSnapshot.docs.map((doc) => Book.fromFirestore(doc)).toList();
  }
}