import 'package:flutter/material.dart';

class PlantItem extends StatelessWidget {
  final String scientificName;
  final List<String> commonNames;

  const PlantItem({
    super.key,
    required this.scientificName,
    required this.commonNames,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Image.network(
                      'https://s1.picswalls.com/wallpapers/2017/12/11/nature-desktop-background_123026895_313.jpg')),
              Expanded(
                  child: Image.network(
                      'https://s1.picswalls.com/wallpapers/2017/12/11/nature-desktop-background_123026895_313.jpg')),
              Expanded(
                  child: Image.network(
                      'https://s1.picswalls.com/wallpapers/2017/12/11/nature-desktop-background_123026895_313.jpg')),
              Expanded(
                  child: Image.network(
                      'https://s1.picswalls.com/wallpapers/2017/12/11/nature-desktop-background_123026895_313.jpg')),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              scientificName,
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              commonNames.join(', '),
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
