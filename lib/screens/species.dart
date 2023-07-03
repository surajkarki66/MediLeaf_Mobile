import 'package:flutter/material.dart';

class SpeciesScreen extends StatefulWidget {
  @override
  State<SpeciesScreen> createState() => _SpeciesScreenState();
  const SpeciesScreen({super.key});
}

class _SpeciesScreenState extends State<SpeciesScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Text('Explore',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            )),
      ),
    );
  }
}
