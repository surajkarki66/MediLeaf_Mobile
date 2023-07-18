import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  int id;
  Profile? profile;
  Country country;
  DateTime lastLogin;
  bool isSuperuser;
  DateTime createdAt;
  DateTime updatedAt;
  String firstName;
  String lastName;
  String email;
  String contact;
  DateTime verificationLinkExpiration;
  bool isVerified;
  List<int> groups;
  List<dynamic> userPermissions;

  User({
    required this.id,
    required this.profile,
    required this.country,
    required this.lastLogin,
    required this.isSuperuser,
    required this.createdAt,
    required this.updatedAt,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.contact,
    required this.verificationLinkExpiration,
    required this.isVerified,
    required this.groups,
    required this.userPermissions,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        profile: Profile.fromJson(json["profile"]),
        country: Country.fromJson(json["country"]),
        lastLogin: DateTime.parse(json["last_login"]),
        isSuperuser: json["is_superuser"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        contact: json["contact"],
        verificationLinkExpiration:
            DateTime.parse(json["verification_link_expiration"]),
        isVerified: json["is_verified"],
        groups: List<int>.from(json["groups"].map((x) => x)),
        userPermissions:
            List<dynamic>.from(json["user_permissions"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile": profile!.toJson(),
        "country": country.toJson(),
        "last_login": lastLogin.toIso8601String(),
        "is_superuser": isSuperuser,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "contact": contact,
        "verification_link_expiration":
            verificationLinkExpiration.toIso8601String(),
        "is_verified": isVerified,
        "groups": List<dynamic>.from(groups.map((x) => x)),
        "user_permissions": List<dynamic>.from(userPermissions.map((x) => x)),
      };
}

class Country {
  String code;
  String name;

  Country({
    required this.code,
    required this.name,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        code: json["code"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
      };
}

class Profile {
  int id;
  String user;
  DateTime createdAt;
  DateTime updatedAt;
  String slug;
  String avatar;
  dynamic facebook;
  dynamic instagram;
  dynamic linkedIn;
  dynamic twitter;

  Profile({
    required this.id,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
    required this.slug,
    required this.avatar,
    this.facebook,
    this.instagram,
    this.linkedIn,
    this.twitter,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"],
        user: json["user"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        slug: json["slug"],
        avatar: json["avatar"],
        facebook: json["facebook"],
        instagram: json["instagram"],
        linkedIn: json["linkedIn"],
        twitter: json["twitter"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "slug": slug,
        "avatar": avatar,
        "facebook": facebook,
        "instagram": instagram,
        "linkedIn": linkedIn,
        "twitter": twitter,
      };
}
