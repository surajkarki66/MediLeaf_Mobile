import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:medileaf/models/plant.dart';
import 'package:medileaf/screens/plant_details.dart';
import 'package:medileaf/widgets/full_image.dart';

class PlantItem extends StatelessWidget {
  final String scientificName;
  final List<String> commonNames;
  final List<PlantImage> plantImages;
  final String family;

  const PlantItem(
      {super.key,
      required this.scientificName,
      required this.commonNames,
      required this.plantImages,
      required this.family});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var i = 0; i < plantImages.length - 1; i++)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullImageScreen(
                          imageUrl: plantImages[i].image,
                          plant: plantImages[i].plant,
                          imagePart: plantImages[i].imagePart,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.22,
                    height: MediaQuery.of(context).size.width * 0.22,
                    margin:
                        const EdgeInsets.only(left: 2.5, right: 2.5, top: 7.0),
                    child: Image.network(
                      plantImages[i].image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 10.0, bottom: 5.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlantDetailsScreen(
                      title: scientificName,
                    ),
                  ),
                );
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  scientificName,
                  style: const TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline),
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 10.0, bottom: 10.0, right: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    commonNames[0],
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Color.fromRGBO(30, 156, 93, 1),
                    ),
                  ),
                ),
                Text(
                  family,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
