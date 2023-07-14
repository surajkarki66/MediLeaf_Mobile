import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medileaf/services/remote_service.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupStateScreen();
}

class _SignupStateScreen extends State<SignupScreen> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController country = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool passToggle = true;
  bool loading = false;

  togglePass() {
    setState(() {
      passToggle = !passToggle;
    });
  }

  doRegister(String firstName, String lastName, String email, String password,
      String country, String phoneNumber) async {
    setState(() {
      loading = true;
    });
    try {
      final result = await RemoteService().register(firstName, lastName, email,
          password, country.replaceAll(' ', ''), phoneNumber);
      showMessage(result["message"], false);
      setState(() {
        loading = false;
      });
      goLogin();
    } catch (e) {
      showMessage(e.toString(), true);
      setState(() {
        loading = false;
      });
    }
  }

  goLogin() {
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
        title: const Text('Registration'),
        backgroundColor: const Color.fromRGBO(30, 156, 93, 1),
        titleSpacing: 5,
      ),
      body: Center(
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
                    child: RawKeyboardListener(
                      focusNode: FocusNode(),
                      onKey: (RawKeyEvent event) {
                        if (event.runtimeType == RawKeyDownEvent &&
                            event.logicalKey == LogicalKeyboardKey.enter) {
                          if (_formKey.currentState!.validate()) {
                            doRegister(
                                firstName.text,
                                lastName.text,
                                email.text,
                                password.text,
                                country.text,
                                phoneNumber.text);
                          }
                        }
                      },
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const Text(
                              'Registration',
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
                              keyboardType: TextInputType.emailAddress,
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
                              controller: country,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(FontAwesomeIcons.addressCard),
                                labelText: 'Country',
                              ),
                              validator: Validators.compose(
                                [
                                  Validators.required('Country  is required'),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: phoneNumber,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\+?\d{0,}[1-9]\d{0,}$'),
                                ),
                              ],
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.phone),
                                labelText: 'Phone Number',
                              ),
                              validator: Validators.compose([
                                Validators.required('Phone number is required'),
                              ]),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: password,
                              obscureText: passToggle,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.lock),
                                  labelText: 'Password',
                                  suffix: InkWell(
                                    onTap: togglePass,
                                    child: Icon(passToggle
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  )),
                              validator: Validators.compose(
                                [
                                  Validators.required('Password is required'),
                                  Validators.minLength(8,
                                      'Password must must be at least 8 characters')
                                ],
                              ),
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
                                    doRegister(
                                        firstName.text,
                                        lastName.text,
                                        email.text,
                                        password.text,
                                        country.text,
                                        phoneNumber.text);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(30, 156, 93, 1),
                                  foregroundColor: Colors.white,
                                ),
                                child: !loading
                                    ? const Text(
                                        "Register",
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
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
