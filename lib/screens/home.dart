import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            ),
            onPressed: () {},
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star),
                SizedBox(width: 5.0),
                Text('Give us a star'),
                SizedBox(width: 5.0),
                Icon(Icons.arrow_forward),
              ],
            ),
          ),
          Text(
            "A Plant's Medicinal Properties Identifier",
            style: GoogleFonts.lato(
              color: const Color.fromARGB(255, 7, 7, 7),
              fontSize: 30,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 80,
          ),
          Text(
            "Medileaf is an application whose motive is to help the individual to identify medicinal plant with their properties by just scanning the leaf of any plant which might result creating curiosity about plant that lead to the preservation of the valuable plants as well as source of income.",
            style: GoogleFonts.lato(
              color: const Color.fromARGB(255, 5, 5, 5),
              fontSize: 15,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          OutlinedButton.icon(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            label: const Text('Start Quiz'),
            icon: const Icon(Icons.arrow_right_alt),
          ),
        ],
      ),
    );
  }
}
