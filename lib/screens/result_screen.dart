import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  @override
  State<ResultScreen> createState() => _ResultScreenState();
  const ResultScreen({super.key});
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("result"),
    );
  }
}
