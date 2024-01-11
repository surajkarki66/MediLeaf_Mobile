import 'dart:async';

import 'package:flutter/material.dart';
import 'package:medileaf/screens/tabs.dart';
import 'package:medileaf/services/remote_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
  const SplashScreen({super.key});
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    fetchCsrfToken();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const TabsScreen(),
        ),
      );
    });
  }

  Future<void> fetchCsrfToken() async {
    try {
      final result = await RemoteService().getCSRF();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("csrfToken1", result);
    } catch (e) {
      rethrow;
    }
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
