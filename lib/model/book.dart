import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String? description;
  final String price;
  final String? categoryId;
  final String categoryName;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.description,
    required this.price,
    this.categoryId,
    required this.categoryName,
  });

  factory Book.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Book(
      id: doc.id,
      title: data['title'] as String,
      author: data['author'] as String,
      description: data['description'] as String?,
      price: data['price'] as String,
      categoryId: data['category_id'] as String?,
      categoryName: data['category_name'] as String? ?? 'Unknown',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'price': price,
      'category_id': categoryId,
      'category_name': categoryName,
      'created_at': DateTime.now(),
    };
  }
}
