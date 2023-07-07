import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:medileaf/app_state.dart';
import 'package:provider/provider.dart';

class SpeciesScreen extends StatefulWidget {
  @override
  State<SpeciesScreen> createState() => _SpeciesScreenState();
  const SpeciesScreen({super.key});
}

class _SpeciesScreenState extends State<SpeciesScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        if (appState.connectivityStatus == ConnectivityStatus.connected) {
          return const Center(
            child: Text("Explore"),
          );
        } else {
          return const Center(
            child: Text("No Internet connection"),
          );
        }
      },
    );
  }
}
