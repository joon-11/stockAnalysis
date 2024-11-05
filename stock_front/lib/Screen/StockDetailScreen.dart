import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String title; // Title of the report
  final String content; // Content of the report

  const DetailScreen({Key? key, required this.title, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
