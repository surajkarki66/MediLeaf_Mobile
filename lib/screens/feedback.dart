import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key, required this.image}) : super(key: key);
  final File image;
  @override
  State<FeedbackScreen> createState() => _FeedbackStateScreen();
}

class _FeedbackStateScreen extends State<FeedbackScreen> {
  TextEditingController commonName = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController medicinalProperties = TextEditingController();
  String? duration;
  String? growthHabit;
  TextEditingController family = TextEditingController();
  TextEditingController genus = TextEditingController();
  TextEditingController species = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  Future<dynamic> sendFeedback(
      Map<String, dynamic> data, dynamic sessionId, dynamic csrfToken) async {
    try {
      var url = 'http://localhost:8000/api/v1/contact/feedback/';
      final headers = {
        'Cookie': 'sessionid=$sessionId;csrftoken=$csrfToken',
        'X-CSRFToken': '$csrfToken'
      };
      final request = http.MultipartRequest('POST', Uri.parse(url));

      final image =
          await http.MultipartFile.fromPath('image', widget.image.path);

      request.headers.addAll(headers);
      request.files.add(image);

      request.fields['common_name'] = data["common_name"];
      request.fields['description'] = data["description"];
      request.fields['medicinal_properties'] = data["medicinal_properties"];
      request.fields['duration'] = data["duration"];
      request.fields['growth_habit'] = data["growth_habit"];
      request.fields['family'] = data["family"];
      request.fields['genus'] = data["genus"];
      request.fields['species'] = data["species"];

      final myRequest = await request.send();
      http.Response res = await http.Response.fromStream(myRequest);

      return jsonDecode(res.body);
    } catch (error) {
      rethrow;
    }
  }

  giveFeedback() async {
    setState(() {
      loading = true;
    });
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString("sessionId");
      final csrfToken = prefs.getString("csrfToken");
      Map<String, dynamic> payLoad = {
        "common_name": commonName.text,
        "description": description.text,
        "medicinal_properties": medicinalProperties.text,
        "duration": duration!,
        "growth_habit": growthHabit!,
        "family": family.text,
        "genus": genus.text,
        "species": species.text,
      };
      await sendFeedback(payLoad, sessionId, csrfToken);

      setState(() {
        loading = false;
      });
      showMessage(
          "Thank you! for your suggestion. Admin will evaluate your feedback soon.",
          false);
      goBack();
    } catch (e) {
      setState(() {
        loading = false;
      });
      showMessage(e.toString(), true);
    }
  }

  goBack() {
    Navigator.of(context).pop(context);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suggestion'),
        backgroundColor: const Color.fromRGBO(30, 156, 93, 1),
        titleSpacing: 5,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Image.asset('assets/images/suggestion.png', scale: 4.0),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text(
                          'Suggestion',
                          style: TextStyle(fontSize: 30),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: commonName,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.title),
                            labelText: 'Common name',
                          ),
                          validator: Validators.compose([
                            Validators.required('Common name is required'),
                          ]),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: description,
                              maxLines: 5,
                              keyboardType: TextInputType.multiline,
                              textAlignVertical: TextAlignVertical.top,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Description about plant"),
                              validator: Validators.compose([
                                Validators.required('Description is required'),
                              ]),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Medicinal Properties',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: medicinalProperties,
                              maxLines: 5,
                              keyboardType: TextInputType.multiline,
                              textAlignVertical: TextAlignVertical.top,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Medicinal Properties of plant"),
                              validator: Validators.compose([
                                Validators.required(
                                    'Medicinal Properties is required'),
                              ]),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DropdownButtonFormField<String>(
                          value: duration,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Duration',
                          ),
                          validator: Validators.compose([
                            Validators.required('Duration is required'),
                          ]),
                          onChanged: (value) {
                            setState(() {
                              duration = value!;
                            });
                          },
                          items: const [
                            DropdownMenuItem(
                              value: 'annual',
                              child: Text('Annual'),
                            ),
                            DropdownMenuItem(
                              value: 'biennial',
                              child: Text('Biennial'),
                            ),
                            DropdownMenuItem(
                              value: 'perennial',
                              child: Text('Perennial'),
                            ),
                            DropdownMenuItem(
                              value: 'ephemeral',
                              child: Text('Ephemeral'),
                            ),
                            DropdownMenuItem(
                              value: 'deciduous',
                              child: Text('Deciduous'),
                            ),
                            DropdownMenuItem(
                              value: 'evergreen',
                              child: Text('Evergreen'),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DropdownButtonFormField<String>(
                          value: growthHabit,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Growth Habit',
                          ),
                          validator: Validators.compose([
                            Validators.required('Growth habit is required'),
                          ]),
                          onChanged: (value) {
                            setState(() {
                              growthHabit = value!;
                            });
                          },
                          items: const [
                            DropdownMenuItem(
                              value: 'herb',
                              child: Text('Herb'),
                            ),
                            DropdownMenuItem(
                              value: 'shrub',
                              child: Text('Shrub'),
                            ),
                            DropdownMenuItem(
                              value: 'tree',
                              child: Text('Tree'),
                            ),
                            DropdownMenuItem(
                              value: 'graminoid',
                              child: Text('Graminoid'),
                            ),
                            DropdownMenuItem(
                              value: 'vine',
                              child: Text('Vine'),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: family,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.title),
                            labelText: 'Family',
                          ),
                          validator: Validators.compose(
                            [
                              Validators.required('Family is required'),
                              Validators.maxLength(255,
                                  'Family must be  less  than 255 characters'),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: genus,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.title),
                            labelText: 'Genus',
                          ),
                          validator: Validators.compose(
                            [
                              Validators.required('Genus is required'),
                              Validators.maxLength(255,
                                  'Genus must be  less  than 255 characters'),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: species,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.title),
                            labelText: 'Species',
                          ),
                          validator: Validators.compose(
                            [
                              Validators.required('Species is required'),
                              Validators.maxLength(255,
                                  'Species must be  less  than 255 characters'),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                giveFeedback();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(30, 156, 93, 1),
                              foregroundColor: Colors.white,
                            ),
                            child: !loading
                                ? const Text(
                                    "Submit",
                                    style: TextStyle(fontSize: 16.0),
                                  )
                                : const SizedBox(
                                    width: 20.0,
                                    height: 20.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
