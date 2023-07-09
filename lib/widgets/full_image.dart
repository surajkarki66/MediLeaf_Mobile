import 'package:flutter/material.dart';

class FullImageScreen extends StatelessWidget {
  final String imageUrl;
  final String plant;
  final String imagePart;

  const FullImageScreen(
      {super.key,
      required this.imageUrl,
      required this.plant,
      required this.imagePart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$plant - $imagePart'),
        backgroundColor: const Color.fromRGBO(30, 156, 93, 1),
        titleSpacing: 5,
      ),
      body: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
