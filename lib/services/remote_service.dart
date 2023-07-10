import 'dart:convert';

import 'package:medileaf/utils/base_client.dart';
import 'package:medileaf/models/plant.dart';

class RemoteService {
  Future<Plant> getPlantDetailsByScientificName(
      String genus, String? species) async {
    try {
      final client = BaseClient();
      var url = "";
      if (species == null) {
        url =
            'https://medi-leaf-backend.vercel.app/api/v1/plant/details/?genus=$genus';
      } else {
        url =
            'https://medi-leaf-backend.vercel.app/api/v1/plant/details/?genus=$genus&species=$species';
      }

      final responseJson = await client.get(url);

      return plantFromJson(responseJson);
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Plant>> getPlants(String searchQuery,
      {required limit, required offset}) async {
    try {
      final client = BaseClient();
      var url =
          'https://medi-leaf-backend.vercel.app/api/v1/plants/?search=$searchQuery&limit=$limit&offset=$offset';

      final responseJson = await client.get(url);
      final plants = json.decode(responseJson)["results"];
      return plantsFromJson(plants);
    } catch (error) {
      rethrow;
    }
  }
}
