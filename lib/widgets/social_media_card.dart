import 'package:flutter/material.dart';

class SocialMediaCard extends StatelessWidget {
  final IconData icon;
  final String url;

  const SocialMediaCard({
    Key? key,
    required this.icon,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Open the social media URL
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
        child: Icon(
          icon,
          size: 40.0,
          color: Colors.blue,
        ),
      ),
    );
  }
}
