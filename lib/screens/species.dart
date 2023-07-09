import 'package:flutter/material.dart';
import 'package:medileaf/app_state.dart';
import 'package:medileaf/models/plant.dart';
import 'package:medileaf/widgets/plant_item.dart';
import 'package:provider/provider.dart';

class SpeciesScreen extends StatefulWidget {
  @override
  State<SpeciesScreen> createState() => _SpeciesScreenState();
  const SpeciesScreen({super.key});
}

class _SpeciesScreenState extends State<SpeciesScreen> {
  List<Plant>? plants;
  bool loading = true;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        if (appState.connectivityStatus == ConnectivityStatus.connected) {
          return Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    // controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {},
                      ),
                    ),
                    onChanged: (value) {},
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: plants?.length,
                    itemBuilder: (context, index) {
                      return PlantItem(
                        scientificName: 'Scientific Name ${index + 1}',
                        commonNames: ['Common Name 1', 'Common Name 2'],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.signal_wifi_connected_no_internet_4_rounded,
                  size: 70,
                ),
                SizedBox(height: 10.0),
                Text(
                  "No internet connection",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
