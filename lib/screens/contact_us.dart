import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60),
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
                            Validators.min(
                                2, 'First name must be at least 2 characters'),
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
                            Validators.required('First name is required'),
                            Validators.min(
                                2, 'First name must be at least 2 characters'),
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
                        TextFormField(
                          controller: message,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.message),
                            labelText: 'Message',
                          ),
                          validator: Validators.compose([
                            Validators.required('Subject is required'),
                          ]),
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
                                if (!loading) {
                                  // submit form
                                }
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
