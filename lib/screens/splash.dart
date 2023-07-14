import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:medileaf/app_state.dart';
import 'package:medileaf/screens/tabs.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
  const SplashScreen({super.key});
}

class _SplashScreenState extends State<SplashScreen> {
  loadModel(AppState appState) async {
    final modelStatus = await Tflite.loadModel(
        model: "assets/model/model.tflite",
        labels: "assets/model/labels.txt",
        numThreads: 1,
        isAsset: true,
        useGpuDelegate: false);
    appState.modelStatus = modelStatus!;
  }

  @override
  void initState() {
    super.initState();
    // final appState = Provider.of<AppState>(context, listen: false);
    // loadModel(appState);
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const TabsScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 60,
              ),
              const Text('MediLeaf',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(30, 156, 93, 1),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
