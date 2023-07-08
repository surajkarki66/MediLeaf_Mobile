import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medileaf/widgets/prediction_card.dart';

class Modal extends StatelessWidget {
  final File image;
  final List cardDataList;
  final VoidCallback onClose;

  const Modal({
    super.key,
    required this.cardDataList,
    required this.onClose,
    required this.image,
  });
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(
              image,
              width: 240,
              height: 240,
            ),
            const SizedBox(height: 16.0),
            for (var cardData in cardDataList)
              PredictionCard(
                label: cardData['scientific_name'],
                confidence: cardData['probability'],
              ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: onClose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(30, 156, 93, 1),
                  ),
                  child: const Text('Close'),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: const Color.fromRGBO(30, 156, 93, 1),
                  ),
                  onPressed: () {},
                  child: const Text('Show More'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
