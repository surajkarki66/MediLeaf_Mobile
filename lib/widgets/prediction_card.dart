import 'package:flutter/material.dart';

class PredictionCard extends StatelessWidget {
  final String label;
  final double confidence;

  const PredictionCard({
    super.key,
    required this.label,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(label),
        subtitle: Text('Confidence: ${(confidence * 100).toStringAsFixed(2)}%'),
      ),
    );
  }
}
