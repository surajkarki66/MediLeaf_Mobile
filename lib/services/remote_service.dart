import 'dart:convert';
import 'package:medileaf/models/contact_us.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

      final responseJson = await client.get(url, null);

      return plantFromJson(responseJson["body"]);
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

      final responseJson = await client.get(url, null);
      final plants = json.decode(responseJson["body"])["results"];
      return plantsFromJson(plants);
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> login(String email, String password) async {
    try {
      final client = BaseClient();
      var url = 'https://medi-leaf-backend.vercel.app/api/v1/login/';

      Map<String, dynamic> payLoad = {"email": email, "password": password};

      final response = await client.post(url, payLoad);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final regex = RegExp(r'(csrftoken|sessionid)=([^;]+)');
      final matches = regex.allMatches(response["headers"]["set-cookie"]!);

      String? csrfToken;
      String? sessionId;

      for (final match in matches) {
        final key = match.group(1);
        final value = match.group(2);

        if (key == 'csrftoken') {
          csrfToken = value!;
        } else if (key == 'sessionid') {
          sessionId = value!;
        }
      }
      prefs.setString("sessionId", sessionId!);
      prefs.setString("csrfToken", csrfToken!);

      return jsonDecode(response["body"]);
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> register(String firstName, String lastName, String email,
      String password, String country, String phoneNumber) async {
    try {
      final client = BaseClient();
      var url = 'https://medi-leaf-backend.vercel.app/api/v1/signup/';

      Map<String, dynamic> payLoad = {
        "email": email,
        "password": password,
        "confirm_password": password,
        "first_name": firstName,
        "last_name": lastName,
        "country": country,
        "contact": phoneNumber,
      };

      final response = await client.post(url, payLoad);

      return jsonDecode(response["body"]);
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> getProfile() async {
    try {
      final client = BaseClient();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final headers = {'Cookie': 'sessionid=${prefs.get("sessionId")}'};

      var url = "https://medi-leaf-backend.vercel.app/api/v1/user-profile/";

      final response = await client.get(url, headers);

      final result = jsonDecode(response["body"])["results"];
      return result;
    } catch (error) {
      rethrow;
    }
  }

  Future<ContactUs> sendMessage(String firstName, String lastName, String email,
      String subject, String message) async {
    try {
      final client = BaseClient();
      var url = 'https://medi-leaf-backend.vercel.app/api/v1/contact_us/';

      Map<String, dynamic> payLoad = {
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "subject": subject,
        "message": message,
      };

      final response = await client.post(url, payLoad);

      return contactUsFromJson(response["body"]);
    } catch (error) {
      rethrow;
    }
  }
}
