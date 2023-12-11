import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:utama/Services/auth_services.dart';
import 'package:utama/Services/globals.dart';

import 'package:utama/rounded_button.dart';
import 'package:utama/screens/Baak/BaakPage.dart';
import 'package:utama/screens/Auth/register_screen.dart';
import 'package:utama/screens/mahasiswa/MahasiswaPage.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = '';
  String _password = '';

  Future<void> loginPressed() async {
    if (_email.isNotEmpty && _password.isNotEmpty) {
      http.Response response = await AuthServices.login(_email, _password);
      Map<String, dynamic> responseMap = jsonDecode(response.body);

      if (response.statusCode == 200) {
        String token = responseMap['token']; // Ambil token dari respons
        print('Token: $token');

        // Extract the role from the response
        String role = responseMap['user']['role'];

        // Use the role as needed (e.g., navigate to different screens based on the role)
        if (role == 'mahasiswa') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const MahasiswaPage(),
            ),
          );
        } else if (role == 'baak') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const AdminPage(),
            ),
          );
        } else {
          // Handle other roles or scenarios as needed
          errorSnackBar(context, 'Unknown role: $role');
        }
      } else {
        errorSnackBar(context, responseMap['message']);
      }
    } else {
      errorSnackBar(context, 'Enter all required fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 150,
                  child: Image.asset('asset/image/itdel.png'),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your email',
                  hintText: 'Enter valid email id as abc@gmail.com',
                ),
                onChanged: (value) {
                  _email = value;
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your password',
                  hintText: 'Enter your password',
                ),
                onChanged: (value) {
                  _password = value;
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundedButton(
              btnText: 'LOG IN',
              onBtnPressed: loginPressed,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const RegisterScreen(),
                  ),
                );
              },
              child: const Text(
                'already have an account',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
