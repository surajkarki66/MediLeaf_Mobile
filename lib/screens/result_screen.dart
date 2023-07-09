import 'dart:io';
import 'dart:convert';

import 'package:mime/mime.dart';
import 'package:flutter/material.dart';
import 'package:medileaf/app_state.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:medileaf/widgets/plant_card.dart';

typedef DetectImage = dynamic Function(ConnectivityStatus connectivityStatus);

class ResultScreen extends StatefulWidget {
  final File image;
  final ConnectivityStatus connectivityStatus;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
  const ResultScreen({
    Key? key,
    required this.image,
    required this.connectivityStatus,
  }) : super(key: key);
}

class _ResultScreenState extends State<ResultScreen> {
  List _output = [];
  String _error = "";
  bool _loading = true;
  final String url = "http://127.0.0.1:3001/classify";

  detectImage(ConnectivityStatus connectivityStatus) async {
    try {
      if (connectivityStatus == ConnectivityStatus.connected) {
        await upload(widget.image);
      } else {
        // Tflite model
      }
    } catch (error) {
      setState(() {
        _loading = false;
      });
      rethrow;
    }
  }

  upload(File image) async {
    try {
      final request = http.MultipartRequest("POST", Uri.parse(url));
      final header = {"Content_type": "multipart/form-data"};
      final mimeType = lookupMimeType(image.path);

      request.files.add(await http.MultipartFile.fromPath(
          "image_field", image.path,
          filename: image.path.split('/').last,
          contentType: MediaType.parse(mimeType!)));
      request.headers.addAll(header);
      final myRequest = await request.send();
      http.Response res = await http.Response.fromStream(myRequest);

      final resJson = jsonDecode(res.body);

      if (myRequest.statusCode == 200) {
        setState(() {
          _loading = false;
          _output = resJson;
        });
      } else {
        setState(() {
          _loading = false;
          _output = resJson;
        });
      }
    } catch (error) {
      setState(() {
        _loading = false;
        _error = error.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    detectImage(widget.connectivityStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identification - Results'),
        backgroundColor: const Color.fromRGBO(30, 156, 93, 1),
        titleSpacing: 5,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 240,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(widget.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (_output.isEmpty)
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _error != ""
                      ? [
                          Visibility(
                            visible: !_loading,
                            child: const Icon(
                              Icons.error_outline,
                              size: 70,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Visibility(
                            visible: !_loading,
                            child: Text(
                              _error.split(":")[0],
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ]
                      : [
                          Visibility(
                            visible: _loading,
                            child: const CircularProgressIndicator(
                              color: Color.fromRGBO(30, 156, 93, 1),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Visibility(
                            visible: _loading,
                            child: const Text(
                              'Please wait...',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ),
                        ],
                ),
              ),
            ),
          if (_output.isNotEmpty)
            for (var cardData in _output)
              PlantCard(
                label: cardData['label'],
                confidence: cardData['confidence'],
              ),
          if (_output.isNotEmpty)
            const SizedBox(
              height: 10.0,
            ),
          if (_output.isNotEmpty)
            TextButton(
                onPressed: () {},
                child: const Text(
                  "Suggest",
                  style: TextStyle(
                    color: Color.fromRGBO(30, 156, 93, 1),
                  ),
                ))
        ],
      ),
    );
  }
}
