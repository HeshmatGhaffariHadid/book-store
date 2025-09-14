import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:monograph/model/book.dart';

class BookService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static void _logPerformance(String operationName, int elapsedMs, {bool isError = false}) {
    final message = 'FIREBASE_PERFORMANCE - $operationName: $elapsedMs ms ${isError ? '(ERROR)' : ''}';
    debugPrint('🟡 $message');
  }

  static Future<List<Book>> getBooks() async {
    final stopwatch = Stopwatch()..start();
    try {
      final snapshot = await _db.collection('books').orderBy('title').get();
      stopwatch.stop();
      _logPerformance('getBooks', stopwatch.elapsedMilliseconds);
      return snapshot.docs.map((doc) => Book.fromFirestore(doc)).toList();
    } catch (e) {
      stopwatch.stop();
      _logPerformance('getBooks', stopwatch.elapsedMilliseconds, isError: true);
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getCategories() async {
    final stopwatch = Stopwatch()..start();
    try {
      final snapshot = await _db.collection('categories').orderBy('name').get();
      stopwatch.stop();
      _logPerformance('getCategories', stopwatch.elapsedMilliseconds);
      return snapshot.docs.map((doc) => {
        'id': doc.id,
        'name': doc['name'] as String,
      }).toList();
    } catch (e) {
      stopwatch.stop();
      _logPerformance('getCategories', stopwatch.elapsedMilliseconds, isError: true);
      rethrow;
    }
  }

  static Future<void> addNewBook(Map<String, dynamic> newBookData) async {
    final stopwatch = Stopwatch()..start();
    try {
      await _db.collection('books').add(newBookData);
      stopwatch.stop();
      _logPerformance('addNewBook', stopwatch.elapsedMilliseconds);
    } catch (e) {
      stopwatch.stop();
      _logPerformance('addNewBook', stopwatch.elapsedMilliseconds, isError: true);
      rethrow;
    }
  }

  static Future<void> addToFavorites(String bookId) async {
    final stopwatch = Stopwatch()..start();
    try {
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
      stopwatch.stop();
      _logPerformance('addToFavorites', stopwatch.elapsedMilliseconds);
    } catch (e) {
      stopwatch.stop();
      _logPerformance('addToFavorites', stopwatch.elapsedMilliseconds, isError: true);
      rethrow;
    }
  }

  static Future<List<Book>> getFavorites() async {
    final stopwatch = Stopwatch()..start();
    try {
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
      stopwatch.stop();
      _logPerformance('getFavorites', stopwatch.elapsedMilliseconds);
      return favoriteBooks;
    } catch (e) {
      stopwatch.stop();
      _logPerformance('getFavorites', stopwatch.elapsedMilliseconds, isError: true);
      rethrow;
    }
  }

  static Future<void> deleteFavorite(String bookId) async {
    final stopwatch = Stopwatch()..start();
    try {
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
      stopwatch.stop();
      _logPerformance('deleteFavorite', stopwatch.elapsedMilliseconds);
    } catch (e) {
      stopwatch.stop();
      _logPerformance('deleteFavorite', stopwatch.elapsedMilliseconds, isError: true);
      rethrow;
    }
  }

  static Future<List<Book>> getBooksByCategory(String categoryName) async {
    final stopwatch = Stopwatch()..start();
    try {
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

      stopwatch.stop();
      _logPerformance('getBooksByCategory', stopwatch.elapsedMilliseconds);
      return booksSnapshot.docs.map((doc) => Book.fromFirestore(doc)).toList();
    } catch (e) {
      stopwatch.stop();
      _logPerformance('getBooksByCategory', stopwatch.elapsedMilliseconds, isError: true);
      rethrow;
    }
  }
}