import 'package:flutter/material.dart';

class IdentificationScreen extends StatefulWidget {
  @override
  State<IdentificationScreen> createState() => _IdentificationScreenState();
  const IdentificationScreen({super.key});
}

class _IdentificationScreenState extends State<IdentificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Text('Identification',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            )),
      ),
    );
  }
}
