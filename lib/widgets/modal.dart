import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medileaf/app_state.dart';

typedef ShowResult = void Function(ConnectivityStatus connectivityStatus);

class Modal extends StatelessWidget {
  final File image;
  final ConnectivityStatus connectivityStatus;
  final VoidCallback onClose;
  final ShowResult showResult;

  const Modal({
    super.key,
    required this.onClose,
    required this.image,
    required this.showResult,
    required this.connectivityStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.file(
                image,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showResult(connectivityStatus);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(30, 156, 93, 1),
                  ),
                  child: const Text('Confirm'),
                ),
                const SizedBox(width: 10.0),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: const Color.fromRGBO(30, 156, 93, 1),
                  ),
                  onPressed: onClose,
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
