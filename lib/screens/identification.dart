import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:medileaf/screens/result_screen.dart';
import 'package:medileaf/widgets/modal.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

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
  late File _image;
  final imagePicker = ImagePicker();

  static const modelPath = 'assets/model/MobileNetV2.tflite';
  static const labelsPath = 'assets/model/labels.txt';

  Interpreter? interpreter;
  List<String> labels = [];

  Tensor? inputTensor;
  Tensor? outputTensor;

  Future<void> loadModel(String modelPath) async {
    final options = InterpreterOptions();

    // Use XNNPACK Delegate
    if (Platform.isAndroid) {
      options.addDelegate(XNNPackDelegate());
    }

    // Use GPU Delegate
    // doesn't work on emulator
    // if (Platform.isAndroid) {
    //   options.addDelegate(GpuDelegateV2());
    // }

    // Use Metal Delegate
    if (Platform.isIOS) {
      options.addDelegate(GpuDelegate());
    }

    // Load model from assets
    interpreter = await Interpreter.fromAsset(modelPath, options: options);

    if (interpreter != null) {
      // Get tensor input shape [1, 224, 224, 3]
      inputTensor = interpreter?.getInputTensors().first;
      // Get tensor output shape [1, 1001]
      outputTensor = interpreter?.getOutputTensors().first;

      log('Interpreter loaded successfully');
    }
  }

  Future<void> loadLabels(String labelPath) async {
    final labelTxt = await rootBundle.loadString(labelsPath);
    labels = labelTxt.split('\n');
  }

  Future<List<Map<String, dynamic>>> runInference(
    List<List<List<num>>> imageMatrix,
  ) async {
    // Set tensor input [1, 224, 224, 3]
    final input = [imageMatrix];

    // Set tensor output [1, 30]
    final output = [List<num>.filled(30, 0)];

    // Run inference
    interpreter?.run(input, output);

    // Get first output tensor
    final result = output.first;

    List<Map<String, dynamic>> predictions = [];
    for (int i = 0; i < labels.length; i++) {
      predictions.add({'label': labels[i], 'confidence': result[i]});
    }

    predictions.sort((a, b) => b['confidence'].compareTo(a['confidence']));

    List<Map<String, dynamic>> top3 = predictions.sublist(0, 3);

    List<Map<String, dynamic>> formattedResult = top3.map((item) {
      return {'label': item['label'], 'confidence': item['confidence']};
    }).toList();

    return formattedResult;
  }

  @override
  void initState() {
    super.initState();
    loadModel(modelPath);
    loadLabels(labelsPath);
  }

  @override
  void dispose() {
    interpreter?.close();
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
      _showDia(connectivityStatus);
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
      _showDia(connectivityStatus);
    } catch (error) {
      rethrow;
    }
  }

  void _showResult(ConnectivityStatus connectivityStatus) {
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ResultScreen(
          image: _image,
          connectivityStatus: connectivityStatus,
          runInference: runInference,
        ),
      ),
    );
  }

  void _showDia(ConnectivityStatus connectivityStatus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Modal(
          image: _image,
          onClose: () {
            Navigator.of(context).pop();
          },
          showResult: _showResult,
          connectivityStatus: connectivityStatus,
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
                      color: Color.fromRGBO(30, 156, 93, 1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () async {
                        try {
                          await pickImageCamera(appState.connectivityStatus);
                        } catch (error) {
                          const message = SnackBar(
                            backgroundColor: Colors.red,
                            content: Text("Something went wrong!"),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(message);
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
                          await pickImageGallery(appState.connectivityStatus);
                        } catch (error) {
                          const message = SnackBar(
                            backgroundColor: Colors.red,
                            content: Text("Something went wrong!"),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(message);
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
        );
      },
    );
  }
}
