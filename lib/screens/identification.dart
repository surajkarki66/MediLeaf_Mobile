import 'dart:convert';
import 'dart:io';
import 'package:mime/mime.dart';

import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:medileaf/app_state.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:medileaf/widgets/modal.dart';

class IdentificationScreen extends StatefulWidget {
  @override
  State<IdentificationScreen> createState() => _IdentificationScreenState();
  const IdentificationScreen({Key? key}) : super(key: key);
}

class _IdentificationScreenState extends State<IdentificationScreen> {
  bool loading = false;
  late File _image;
  List _output = [];
  final imagePicker = ImagePicker();
  late bool connected;
  late String modelStatus;
  final String url = "http://127.0.0.1:3001/classify";

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  detectImage(File image, ConnectivityStatus connectivityStatus) async {
    setState(() {
      loading = true;
    });
    if (connectivityStatus == ConnectivityStatus.connected) {
      await upload(image);
    } else {
      try {
        var prediction = await Tflite.runModelOnImage(
          path: image.path,
          numResults: 3,
          threshold: 0.1,
          imageMean: 127.5,
          imageStd: 255.0,
        );
        setState(() {
          _output = prediction!;
        });
      } catch (error) {
        rethrow;
      }
    }
  }

  Future<void> upload(File image) async {
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
          _output = resJson;
          loading = true;
        });
      } else {
        setState(() {
          _output = resJson;
          loading = true;
        });
      }
    } catch (error) {
      rethrow;
    }
  }

  loadModel() async {
    modelStatus = (await Tflite.loadModel(
        model: 'assets/model/model.tflite',
        labels: 'assets/model/labels.txt'))!;
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  pickImageCamera(ConnectivityStatus connectivityStatus) async {
    try {
      var image = await imagePicker.pickImage(source: ImageSource.camera);
      if (image == null) {
        return null;
      } else {
        _image = File(image.path);
      }
      await detectImage(_image, connectivityStatus);
    } catch (error) {
      rethrow;
    }
  }

  pickImageGallery(ConnectivityStatus connectivityStatus) async {
    try {
      var image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        return null;
      } else {
        _image = File(image.path);
      }
      await detectImage(_image, connectivityStatus);
    } catch (error) {
      rethrow;
    }
  }

  void showDia(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Modal(
          image: _image,
          cardDataList: _output,
          onClose: () {
            setState(() {
              _output = [];
            });
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return ModalProgressHUD(
          inAsyncCall: loading && _output.isEmpty,
          opacity: 0.3,
          progressIndicator: const CircularProgressIndicator(
            color: Color.fromRGBO(30, 156, 93, 1),
          ),
          child: Container(
            height: height,
            width: width,
            color: Colors.white,
            child: loading && _output.isEmpty
                ? null
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Touch to identify',
                        style: GoogleFonts.lato(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(30, 156, 93, 1),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () async {
                                try {
                                  await pickImageCamera(
                                      appState.connectivityStatus);
                                  setState(() {
                                    loading = false;
                                  });
                                  if (_output.isNotEmpty && !loading) {
                                    // ignore: use_build_context_synchronously
                                    showDia(context);
                                  }
                                } catch (error) {
                                  setState(() {
                                    loading = false;
                                  });
                                  const message = SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text("Something went wrong!"),
                                  );

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(message);
                                }
                              },
                              icon: const Icon(
                                Icons.camera_alt,
                                size: 80,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 35),
                          const Text("OR"),
                          const SizedBox(height: 35),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(30, 156, 93, 1),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () async {
                                try {
                                  await pickImageGallery(
                                      appState.connectivityStatus);
                                  setState(() {
                                    loading = false;
                                  });
                                  if (_output.isNotEmpty && !loading) {
                                    // ignore: use_build_context_synchronously
                                    showDia(context);
                                  }
                                } catch (error) {
                                  setState(() {
                                    loading = false;
                                  });
                                  const message = SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text("Something went wrong!"),
                                  );

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(message);
                                }
                              },
                              icon: const Icon(
                                Icons.photo_library,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
