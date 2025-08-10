import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monograph/pages/Category_list.dart';
import 'package:monograph/pages/signin_signup_pages/signIn_page.dart';
import '../constants.dart';
import '../model/book.dart';
import 'details_page.dart';
import 'favorite_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const routName = '/homePage';

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

  final List<Book> books = [
    Book(
      title: 'Wild Life',
      author: 'James Ghosling',
      description:
          'Learning JAVA is quite simple if you choose this book as your main reference in the your coding world',
      category: 'science',
      price: '20.3',
    ),
    Book(
      title: 'Singing',
      author: 'Ada Lunsalan',
      description:
          'Learning singing is quite simple if you choose this book as your main reference in the your coding world',
      category: 'art',
      price: '17.9',
    ),
    Book(
      title: 'Learn Algorithm',
      author: 'Gang of Four',
      description:
          'The most popular and efficient algorithms are described in this valuable book',
      category: 'programming',
      price: '49.9',
    ),
    Book(
      title: 'Arabic',
      author: 'Musa Mashal',
      description:
          'Arabic is the most historical and powerful language of the world, about all significant science books are written in Arabic, it is the early Islam language and the holy Quran is written in Arabic',
      category: 'drama',
      price: '49.9',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Store'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.black87),
            onPressed: () async {
              await auth.signOut();
              Navigator.pop(context);
              Navigator.pushNamed(context, SignInPage.routeName);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(
                Icons.add_shopping_cart_outlined,
                color: Colors.indigo,
              ),
              onPressed: () {
                Navigator.pushNamed(context, FavoritesPage.routeName);
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Featured Books',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color:Colors.grey[800]),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildFeaturedBook(
                      context,
                      books[index].title,
                      books[index].author,
                      books[index].description,
                      books[index].category,
                      books[index].price,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
             Text(
              'Popular Categories',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.grey[800]),
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
                _buildCategory('Science', Icons.science_outlined),
                _buildCategory('Programming', Icons.computer),
                _buildCategory('Art', Icons.live_tv),
                _buildCategory('Literature', Icons.language),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showBottomSheet();
          });
        },
        child: Icon(Icons.add, color: Colors.indigo, size: 30),
      ),
    );
  }

  Future _showBottomSheet() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: 320,
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    'Add New Book',
                    style: TextStyle(color: Colors.indigo, fontSize: 22),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          spacing: 20,
                          children: [
                            _buildTextField(
                              controller: titleController,
                              label: 'book title',
                              node: titleNode,
                              nextNode: authorNode,
                            ),
                            _buildTextField(
                              controller: authorController,
                              label: 'author name',
                              node: authorNode,
                              nextNode: descNode,
                            ),
                            _buildTextField(
                              controller: descriptionController,
                              label: 'book description',
                              node: descNode,
                              nextNode: pricesNode,
                            ),
                            _buildTextField(
                              controller: priceController,
                              label: 'book price',
                              node: pricesNode,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      books.insert(
                                        0,
                                        Book(
                                          title: titleController.text,
                                          author: authorController.text,
                                          description:
                                              descriptionController.text,
                                          price: priceController.text,
                                          category: '',
                                        ),
                                      );
                                    });
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('New book added')),
                                    );
                                    titleController.clear();
                                    authorController.clear();
                                    descriptionController.clear();
                                    priceController.clear();
                                  },
                                  child: Text(
                                    'Add Book',
                                    style: TextStyle(color: Colors.indigo),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
      textInputAction: TextInputAction.next,
      enabled: true,
      decoration: InputDecoration(
        labelText: label,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.indigo, width: 1.5),
        ),
      ),
      onSubmitted: (_) {
        FocusScope.of(context).requestFocus(nextNode);
      },
    );
  }

  Widget _buildFeaturedBook(
    BuildContext context,
    String title,
    String author,
    String description,
    String category,
    String price,
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
            'category': category,
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
Navigator.pushNamed(context, CategoryList.routeName);
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
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }
}
