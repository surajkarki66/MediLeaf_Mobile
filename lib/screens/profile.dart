import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medileaf/app_state.dart';
import 'package:medileaf/screens/login.dart';
import 'package:medileaf/services/remote_service.dart';
import 'package:medileaf/widgets/social_media_card.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool loading = true;
  bool imageLoading = false;
  dynamic user;
  String? _error;
  bool? isAuthenticated;
  dynamic avatar;
  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  void checkAuth() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString("sessionId");
      if (sessionId == null) {
        setState(() {
          loading = false;
          isAuthenticated = false;
        });
      } else {
        getProfile();
        setState(() {
          isAuthenticated = true;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        loading = false;
      });
    }
  }

  getProfile() async {
    try {
      final result = await RemoteService().getProfile();
      final isVerified = result["is_verified"];
      final userId = result["id"];
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isVerified", isVerified);
      prefs.setInt("userId", userId);

      setState(() {
        user = result;
        loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        loading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a picture'),
              onTap: () {
                Navigator.of(context).pop();
                _getImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.of(context).pop();
                _getImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? image = (await picker.pickImage(source: source));
      if (image != null) {
        setState(() {
          imageLoading = true;
        });
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final sessionId = prefs.getString("sessionId");

        if (user != null) {
          Response response = user["profile"] != null
              ? await _updateUserAvatar(
                  sessionId, image, user["profile"]["slug"])
              : await _updateUserAvatar(sessionId, image, null);

          if (response.statusCode == 201) {
            final result = jsonDecode(response.body);

            if (result != null) {
              setState(() {
                avatar = result["avatar"];
                imageLoading = false;
              });
            }

            showMessage("Successfully! avatar changed", false);
          }
          if (response.statusCode == 403) {
            final result = jsonDecode(response.body);
            setState(() {
              imageLoading = false;
            });
            final errorMessage = result["message"];
            showMessage(errorMessage, true);
          }
          if (response.statusCode == 400) {
            final result = jsonDecode(response.body);

            setState(() {
              imageLoading = false;
            });
            final errorMessage = result["message"]["avatar"][0];
            showMessage(errorMessage, true);
          }
        }
      }
    } catch (e) {
      setState(() {
        imageLoading = false;
      });
      showMessage(e.toString(), true);
    }
  }

  Future<Response> _updateUserAvatar(
      dynamic sessionId, XFile? avatarImage, String? profileSlug) async {
    late final Uri apiUrl;
    late final http.MultipartRequest request;
    if (profileSlug != null) {
      apiUrl = Uri.parse(
          'https://medi-leaf-backend.vercel.app/api/v1/profile/$profileSlug/');
      request = http.MultipartRequest('PATCH', apiUrl);
    } else {
      apiUrl =
          Uri.parse('https://medi-leaf-backend.vercel.app/api/v1/profile/');
      request = http.MultipartRequest('POST', apiUrl);
    }

    try {
      final headers = {'Cookie': 'sessionid=$sessionId'};

      final image =
          await http.MultipartFile.fromPath('avatar', avatarImage!.path);

      request.headers.addAll(headers);
      request.files.add(image);

      final myRequest = await request.send();
      http.Response res = await http.Response.fromStream(myRequest);
      return res;
    } catch (e) {
      rethrow;
    }
  }

  void showMessage(String message, bool isError) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
      backgroundColor: isError ? Colors.red : Colors.green,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        if (appState.connectivityStatus == ConnectivityStatus.connected) {
          if (isAuthenticated != null) {
            if (isAuthenticated!) {
              if (_error != null) {
                return Align(
                  alignment: Alignment.center,
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
                );
              }
              if (user != null) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      user["profile"] != null
                          ? Stack(
                              alignment: Alignment.center,
                              children: [
                                GestureDetector(
                                  onTap: _pickImage,
                                  child: CircleAvatar(
                                    radius: 60.0,
                                    backgroundImage: avatar == null
                                        ? NetworkImage(
                                            user!["profile"]!["avatar"])
                                        : NetworkImage(avatar),
                                  ),
                                ),
                                if (imageLoading)
                                  const CircularProgressIndicator(
                                    color: Color.fromRGBO(30, 156, 93, 1),
                                  ),
                              ],
                            )
                          : Stack(
                              alignment: Alignment.center,
                              children: [
                                GestureDetector(
                                  onTap: _pickImage,
                                  child: CircleAvatar(
                                    radius: 60.0,
                                    backgroundImage: avatar == null
                                        ? const NetworkImage(
                                            "https://res.cloudinary.com/deek0shwx/image/upload/f_auto,q_auto/v1/media/avatars/toufvunmplvpjmoak8it")
                                        : NetworkImage(avatar),
                                  ),
                                ),
                                if (imageLoading)
                                  const CircularProgressIndicator(
                                    color: Color.fromRGBO(30, 156, 93, 1),
                                  ),
                              ],
                            ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${user?["first_name"]} ${user?["last_name"]}',
                            style: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 5.0),
                          user?["is_verified"]
                              ? const Icon(
                                  Icons.verified,
                                  color: Colors.blue,
                                )
                              : const Text("")
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      if (user?["profile"] != null)
                        Text(
                          user!["profile"]!["slug"],
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                      const SizedBox(height: 16.0),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: Text(user!["email"]),
                      ),
                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: Text(user!["contact"]),
                      ),
                      ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(user!["country"]["name"]),
                      ),
                      const SizedBox(height: 25.0),
                      const Text(
                        'Social Media Links',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      user!["profile"] != null &&
                              user!["profile"]!["facebook"] != null &&
                              user!["profile"]!["twitter"] != null &&
                              user!["profile"]!["instagram"] != null &&
                              user!["profile"]!["linkedin"] != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (user!["profile"]!["facebook"])
                                  SocialMediaCard(
                                    icon: FontAwesomeIcons.facebook,
                                    url: user!["profile"]!["facebook"],
                                  ),
                                if (user!["profile"]!["instagram"])
                                  SocialMediaCard(
                                    icon: FontAwesomeIcons.instagram,
                                    url: user!["profile"]!["instagram"],
                                  ),
                                if (user!["profile"]!["twitter"])
                                  SocialMediaCard(
                                    icon: FontAwesomeIcons.twitter,
                                    url: user!["profile"]!["twitter"],
                                  ),
                                if (user!["profile"]!["linkedIn"])
                                  SocialMediaCard(
                                    icon: FontAwesomeIcons.linkedin,
                                    url: user!["profile"]!["linkedIn"],
                                  ),
                              ],
                            )
                          : const Text("No social media links")
                    ],
                  ),
                );
              } else {
                return const Align(
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
                );
              }
            } else {
              return Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.do_not_disturb_alt_outlined,
                      size: 70,
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      "Please log in",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10.0),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(30, 156, 93, 1),
                        ),
                        child: const Text("Login")),
                  ],
                ),
              );
            }
          } else {
            return const Align(
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
            );
          }
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
