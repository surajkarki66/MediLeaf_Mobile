import 'package:flutter/material.dart';
import 'package:medileaf/screens/profile.dart';
import 'package:medileaf/services/remote_service.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginStateScreen();
}

class _LoginStateScreen extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool passToggle = true;
  bool loading = false;

  togglePass() {
    setState(() {
      passToggle = !passToggle;
    });
  }

  void doLogin(String email, password) async {
    setState(() {
      loading = true;
    });
    try {
      final result = await RemoteService().login(email, password);
      showMessage(result["message"], false);
      setState(() {
        loading = false;
      });
      goToProfile();
    } catch (e) {
      showMessage(e.toString(), true);
      setState(() {
        loading = false;
      });
    }
  }

  goToProfile() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()));
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
        title: const Text('Login'),
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text(
                          'Login',
                          style: TextStyle(fontSize: 30),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(0),
                              ),
                              child: const Text(
                                "Forgot password?",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromRGBO(30, 156, 93, 1),
                                ),
                              ),
                            ),
                          ],
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
                                if (!loading) {
                                  doLogin(email.text, password.text);
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
                                    "Login",
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account"),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(0),
                              ),
                              child: const Text(
                                "Sign up",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromRGBO(30, 156, 93, 1),
                                ),
                              ),
                            ),
                          ],
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
