import 'package:flutter/material.dart';
import 'package:medileaf/app_state.dart';
import 'package:medileaf/models/plant.dart';
import 'package:medileaf/services/remote_service.dart';
import 'package:medileaf/widgets/plant_item.dart';
import 'package:provider/provider.dart';

class SpeciesScreen extends StatefulWidget {
  const SpeciesScreen({super.key});

  @override
  State<SpeciesScreen> createState() => _SpeciesScreenState();
}

class _SpeciesScreenState extends State<SpeciesScreen> {
  List<Plant>? _plants;
  bool loading = true;
  String? _error;
  String search = "";
  int limit = 10;
  int offset = 0;
  bool _isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  getPlantsList() async {
    try {
      List<Plant> plants =
          await RemoteService().getPlants(search, limit: limit, offset: offset);
      if (_plants != null) {
        setState(() {
          loading = false;
          _plants!.addAll(plants);
          offset += limit;
          _isLoadingMore = false;
        });
      } else {
        setState(() {
          loading = false;
          _plants = plants;
          offset += limit;
          _isLoadingMore = false;
        });
      }
    } catch (error) {
      setState(() {
        loading = false;
        _error = error.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPlantsList();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void onSearchTextChanged(String newText) {
    setState(() {
      search = newText;
    });

    setState(() {
      loading = true;
      _error = null;
      offset = 0;
      _plants = [];
    });

    getPlantsList();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!_isLoadingMore) {
        setState(() {
          _isLoadingMore = true;
        });
        getPlantsList();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        if (appState.connectivityStatus == ConnectivityStatus.connected) {
          return Align(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          onSearchTextChanged(_searchController.text);
                        },
                      ),
                    ),
                    onChanged: (value) {
                      onSearchTextChanged(value);
                    },
                  ),
                ),
                if (loading)
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Color.fromRGBO(30, 156, 93, 1),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              'Please wait...',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                if (_error != null)
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 70,
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              _error!,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                if (_plants != null && _plants!.isEmpty && !loading)
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 70,
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              'No plants found',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                if (_plants != null && _plants!.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _isLoadingMore
                          ? _plants!.length + 1
                          : _plants!.length,
                      itemBuilder: (context, index) {
                        if (index == _plants!.length) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color.fromRGBO(30, 156, 93, 1),
                            ),
                          );
                        }
                        return PlantItem(
                          scientificName: _plants?[index].species != null
                              ? '${_plants?[index].genus} ${_plants?[index].species}'
                              : _plants![index].genus,
                          commonNames: _plants![index].commonNames,
                          plantImages: _plants![index].images,
                          family: _plants![index].family,
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
