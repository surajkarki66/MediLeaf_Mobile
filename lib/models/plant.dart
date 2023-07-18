import 'dart:convert';

Plant plantFromJson(String str) => Plant.fromJson(json.decode(str));
List<Plant> plantsFromJson(List data) =>
    List<Plant>.from(data.map((x) => Plant.fromJson(x)));

String plantToJson(Plant data) => json.encode(data.toJson());

class Plant {
  int id;
  List<String> commonNames;
  List<String> commonNamesNe;
  String? description;
  String? descriptionNe;
  String? medicinalProperties;
  String? medicinalPropertiesNe;
  String? duration;
  String? growthHabit;
  String? wikipediaLink;
  List<String>? otherResourcesLinks;
  int? noOfObservations;
  String family;
  String genus;
  String? species;
  List<PlantImage> images;
  DateTime createdAt;
  DateTime updatedAt;

  Plant({
    required this.id,
    required this.commonNames,
    required this.commonNamesNe,
    this.description,
    this.descriptionNe,
    this.medicinalProperties,
    this.medicinalPropertiesNe,
    this.duration,
    this.growthHabit,
    this.wikipediaLink,
    this.otherResourcesLinks,
    required this.noOfObservations,
    required this.family,
    required this.genus,
    this.species,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Plant.fromJson(Map<String, dynamic> json) => Plant(
        id: json["id"],
        commonNames: List<String>.from(json["common_names"].map((x) => x)),
        commonNamesNe: List<String>.from(json["common_names_ne"].map((x) => x)),
        description: json["description"],
        descriptionNe: json["description_ne"],
        medicinalProperties: json["medicinal_properties"],
        medicinalPropertiesNe: json["medicinal_properties_ne"],
        duration: json["duration"],
        growthHabit: json["growth_habit"],
        wikipediaLink: json["wikipedia_link"] as String?, // Allow null value
        otherResourcesLinks: json["other_resources_links"] != null
            ? List<String>.from(json["other_resources_links"].map((x) => x))
            : null,
        noOfObservations: json["no_of_observations"],
        family: json["family"],
        genus: json["genus"],
        species: json["species"],
        images: List<PlantImage>.from(
            json["images"].map((x) => PlantImage.fromJson(x))),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "common_names": List<dynamic>.from(commonNames.map((x) => x)),
        "common_names_ne": List<dynamic>.from(commonNamesNe.map((x) => x)),
        "description": description,
        "description_ne": descriptionNe,
        "medicinal_properties": medicinalProperties,
        "medicinal_properties_ne": medicinalPropertiesNe,
        "duration": duration,
        "growth_habit": growthHabit,
        "wikipedia_link": wikipediaLink!,
        "other_resources_links":
            List<dynamic>.from(otherResourcesLinks!.map((x) => x)),
        "no_of_observations": noOfObservations,
        "family": family,
        "genus": genus,
        "species": species!,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class PlantImage {
  int id;
  String plant;
  String imagePart;
  String image;
  bool imageDefault;
  DateTime createdAt;
  DateTime updatedAt;

  PlantImage({
    required this.id,
    required this.plant,
    required this.imagePart,
    required this.image,
    required this.imageDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PlantImage.fromJson(Map<String, dynamic> json) => PlantImage(
        id: json["id"],
        plant: json["plant"],
        imagePart: json["part"],
        image: json["image"],
        imageDefault: json["default"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "plant": plant,
        "part": imagePart,
        "image": image,
        "default": imageDefault,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
