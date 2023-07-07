import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:medileaf/app_state.dart';

class IdentificationScreen extends StatefulWidget {
  @override
  State<IdentificationScreen> createState() => _IdentificationScreenState();
  const IdentificationScreen({Key? key}) : super(key: key);
}

class _IdentificationScreenState extends State<IdentificationScreen> {
  bool loading = true;
  late XFile _image;
  late List _output;
  final imagePicker = ImagePicker();
  late bool connected;
  late String modelStatus;

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  detectImage(XFile image, ConnectivityStatus connectivityStatus) async {
    if (connectivityStatus != ConnectivityStatus.connected) {
      // api call
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
          loading = false;
        });
        print(prediction);
      } catch (error) {}
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
    var image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image == null) {
      return null;
    } else {
      _image = XFile(image.path);
    }
    detectImage(_image, connectivityStatus);
  }

  pickImageGallery(ConnectivityStatus connectivityStatus) async {
    var image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    } else {
      _image = XFile(image.path);
    }
    detectImage(_image, connectivityStatus);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Consumer<AppState>(
      builder: (context, appState, _) {
        return Container(
          height: height,
          width: width,
          color: Colors.white,
          child: Column(
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
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        pickImageCamera(appState.connectivityStatus);
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
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        pickImageGallery(appState.connectivityStatus);
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
        );
      },
    );
  }
}
