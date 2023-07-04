import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:medileaf/screens/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((fn) {
    runApp(const App());
  });
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "MediLeaf",
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
