import 'package:flutter/material.dart';
import 'package:medileaf/app_state.dart';
import 'package:medileaf/services/remote_service.dart';
import 'package:provider/provider.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
  const ContactUsScreen({super.key});
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController subject = TextEditingController();
  TextEditingController message = TextEditingController();

  sendMessage(
      String fname, String lname, String em, String sub, String msg) async {
    setState(() {
      loading = true;
    });
    try {
      final result =
          await RemoteService().sendMessage(fname, lname, em, sub, msg);
      showMessage(
          "Thank you! ${result.firstName} for your message, we will get back to you very soon.",
          false);
      setState(() {
        loading = false;
      });
      _formKey.currentState!.reset();
      firstName.clear();
      lastName.clear();
      email.clear();
      subject.clear();
      message.clear();
    } catch (error) {
      showMessage(error.toString(), true);
      setState(() {
        loading = false;
      });
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
      duration: const Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, _) {
      if (appState.connectivityStatus == ConnectivityStatus.connected) {
        return Container(
          color: Colors.white,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/login.png', scale: 4.0),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const Text(
                              'Contact us',
                              style: TextStyle(fontSize: 30),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: firstName,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.abc),
                                labelText: 'First Name',
                              ),
                              validator: Validators.compose([
                                Validators.required('First name is required'),
                                Validators.minLength(2,
                                    'First name must be at least 2 characters'),
                              ]),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: lastName,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.abc),
                                labelText: 'Last Name',
                              ),
                              validator: Validators.compose([
                                Validators.required('Last name is required'),
                                Validators.minLength(2,
                                    'Last name must be at least 2 characters'),
                              ]),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: email,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.email),
                                labelText: 'Email',
                              ),
                              validator: Validators.compose([
                                Validators.required('Email is required'),
                                Validators.email('Invalid email address'),
                              ]),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: subject,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.subject),
                                labelText: 'Subject',
                              ),
                              validator: Validators.compose([
                                Validators.required('Subject is required'),
                              ]),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Message',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: message,
                                  maxLines: 5,
                                  keyboardType: TextInputType.multiline,
                                  textAlignVertical: TextAlignVertical.top,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: Validators.compose([
                                    Validators.required('Message is required'),
                                  ]),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    sendMessage(
                                      firstName.text,
                                      lastName.text,
                                      email.text,
                                      subject.text,
                                      message.text,
                                    );
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
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      ),
                              ),
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
    });
  }
}
