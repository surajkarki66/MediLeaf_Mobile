import 'package:flutter/material.dart';
import 'package:medileaf/screens/plant_details.dart';

class PlantCard extends StatelessWidget {
  final String label;
  final double confidence;

  const PlantCard({
    super.key,
    required this.label,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => PlantDetailsScreen(
              title: label,
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(
            label,
          ),
          subtitle:
              Text('Confidence: ${(confidence * 100).toStringAsFixed(2)}%'),
        ),
      ),
    );
  }
}
