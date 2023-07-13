import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(PoemApp());

class PoemApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Poem App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PoemScreen(),
    );
  }
}

class PoemScreen extends StatefulWidget {
  @override
  _PoemScreenState createState() => _PoemScreenState();
}

class _PoemScreenState extends State<PoemScreen> {
  List<dynamic> poems = [];

  @override
  void initState() {
    super.initState();
    fetchPoems();
  }

  Future<void> fetchPoems() async {
    final response =
    await http.get(Uri.parse('https://poetrydb.org/random/10'));

    if (response.statusCode == 200) {
      setState(() {
        poems = jsonDecode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Poem App'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final poem in poems)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PoemDetailScreen(poem: poem),
                    ),
                  );
                },
                child: Container(
                  width: 200.0,
                  height: 200,
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        poem['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        poem['author'],
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PoemDetailScreen extends StatelessWidget {
  final dynamic poem;

  PoemDetailScreen({required this.poem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(poem['title']),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          poem['lines'].join('\n'),
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
