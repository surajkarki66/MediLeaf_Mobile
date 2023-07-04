import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeScreen extends StatelessWidget {
  final Function selectPage;
  const HomeScreen({Key? key, required this.selectPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              maximumSize: const Size(250, 50),
            ),
            onPressed: () async {
              if (await canLaunchUrl(
                  Uri.https('github.com', '/surajkarki66/MediLeaf_AI'))) {
                await launchUrl(
                    Uri.https('github.com', '/surajkarki66/MediLeaf_AI'),
                    mode: LaunchMode.platformDefault);
              } else {
                throw 'Could not launch url';
              }
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Give us a star'),
                SizedBox(width: 5.0),
                Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
                Text('GitHub',
                    style: TextStyle(
                      color: Color.fromRGBO(30, 156, 93, 1),
                    )),
                Icon(Icons.arrow_forward),
              ],
            ),
          ),
          const SizedBox(
            height: 65,
          ),
          Text(
            "A Plant's Medicinal Properties Identifier",
            style: GoogleFonts.lato(
                color: const Color.fromARGB(255, 7, 7, 7),
                fontSize: 30,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "Medileaf is an application whose motive is to help the individual to identify medicinal plant with their properties by just scanning the leaf of any plant which might result creating curiosity about plant that lead to the preservation of the valuable plants as well as source of income.",
              style: GoogleFonts.lato(
                  color: const Color.fromARGB(255, 5, 5, 5),
                  fontSize: 15,
                  height: 1.5),
              textAlign: TextAlign.justify,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () {
                  selectPage(2);
                },
                style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromRGBO(30, 156, 93, 1)),
                child: const Text('Get Started'),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () {
                  selectPage(3);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Learn more'), Icon(Icons.arrow_right_alt)],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
