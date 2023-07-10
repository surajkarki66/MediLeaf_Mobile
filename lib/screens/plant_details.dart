import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:medileaf/models/plant.dart';
import 'package:medileaf/services/remote_service.dart';
import 'package:medileaf/widgets/full_image.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PlantDetailsScreen extends StatefulWidget {
  final String title;
  @override
  State<PlantDetailsScreen> createState() => _PlantDetailsScreenState();
  const PlantDetailsScreen({super.key, required this.title});
}

class _PlantDetailsScreenState extends State<PlantDetailsScreen> {
  Plant? plant;
  String? _error;
  bool loading = true;

  getPlant() async {
    try {
      List<String> scientificName = widget.title.split(" ");

      Plant plantDetails;
      if (scientificName.length == 2) {
        plantDetails = await RemoteService().getPlantDetailsByScientificName(
            scientificName[0], scientificName[1]);
      } else {
        plantDetails = await RemoteService()
            .getPlantDetailsByScientificName(scientificName[0], null);
      }
      setState(() {
        loading = false;
        plant = plantDetails;
      });
    } catch (error) {
      setState(() {
        loading = false;
        _error = error.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPlant();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color.fromRGBO(30, 156, 93, 1),
        titleSpacing: 5,
      ),
      body: ModalProgressHUD(
        inAsyncCall: loading,
        progressIndicator: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color.fromRGBO(30, 156, 93, 1)),
            SizedBox(height: 10.0),
            Text(
              'Please wait...',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w200,
              ),
            ),
          ],
        ),
        child: plant != null
            ? ListView(padding: const EdgeInsets.all(8.0), children: [
                Card(
                  elevation: 0,
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 5,
                    mainAxisSpacing: 5.0,
                    crossAxisSpacing: 5.0,
                    children: [
                      for (var p in plant!.images)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullImageScreen(
                                  imageUrl: p.image,
                                  plant: p.plant,
                                  imagePart: p.imagePart,
                                ),
                              ),
                            );
                          },
                          child: SizedBox(
                            width: 200,
                            height: 200,
                            child: Image.network(
                              p.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 5.0),
                Card(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0, top: 16.0),
                        child: Text(
                          'Description',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          bottom: 16.0,
                        ),
                        child: Html(
                          data: plant!.description,
                          style: {
                            'p': Style(
                                textAlign: TextAlign.justify,
                                lineHeight: const LineHeight(1.5)),
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0, top: 16.0),
                        child: Text(
                          'Medicinal Properties',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, bottom: 16.0),
                        child: Html(
                          data: plant!.medicinalProperties,
                          style: {
                            'p': Style(
                                textAlign: TextAlign.justify,
                                lineHeight: const LineHeight(1.5)),
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0, top: 16.0),
                        child: Text(
                          'General Information',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ListTile(
                        title: const Text('Family'),
                        subtitle: Text(plant!.family),
                      ),
                      ListTile(
                        title: const Text('Genus'),
                        subtitle: Text(plant!.genus),
                      ),
                      if (plant!.species != null)
                        ListTile(
                          title: const Text('Species'),
                          subtitle: Text(plant!.species!),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: ListTile(
                          title: const Text('Common Names'),
                          subtitle: Text(plant!.commonNames.join(', ')),
                        ),
                      ),
                    ],
                  ),
                ),
                if (plant!.wikipediaLink != null)
                  Card(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0, top: 16.0),
                          child: Text(
                            'Addition Information',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: ListTile(
                              title: const Text('Wikipedia'),
                              subtitle: Text.rich(
                                TextSpan(
                                  text: plant!.wikipediaLink,
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      launchUrlString(plant!.wikipediaLink!);
                                    },
                                ),
                              )),
                        ),
                        if (plant!.otherResourcesLinks!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: ListTile(
                              title: const Text('Other Resources'),
                              subtitle: Text.rich(
                                TextSpan(
                                  text: '',
                                  children: [
                                    for (final link
                                        in plant!.otherResourcesLinks!)
                                      TextSpan(
                                        text: "$link\n",
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            launchUrlString(link);
                                          },
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
              ])
            : _error != null
                ? Align(
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
                          _error!.split(":")[0],
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : const Text(""),
      ),
    );
  }
}
