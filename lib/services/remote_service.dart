import 'package:medileaf/utils/base_client.dart';
import 'package:medileaf/models/plant.dart';

class RemoteService {
  Future<Plant> getPlantDetails(String genus, String? species) async {
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

  // Future<List<Plant>> getPlants(String searchQuery, dynamic pageParams) async {
  //   try {
  //     final client = BaseClient();
  //     var url =
  //         'https://medi-leaf-backend.vercel.app/api/v1/plants/?search=$searchQuery&limit=${pageParams.limit}&offset=${pageParams.offset}';

  //     final responseJson = await client.get(url);

  //     return plantFromJson(responseJson);
  //   } catch (error) {
  //     rethrow;
  //   }
  // }
}
