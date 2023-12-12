import 'package:flutter/material.dart';
import 'package:cismo/api_response.dart';
import 'package:cismo/Auth/Login/models/login.dart';
import 'package:cismo/Auth/Login/controllers/login_controller.dart';

import 'package:cismo/rounded_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cismo/Baak/views/Baak_views.dart';
import 'package:cismo/Mahasiswa/views/Mahasiswa_views.dart';
import 'package:cismo/Auth/Register/views/register_views.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtemail = TextEditingController();
  TextEditingController txtpassword = TextEditingController();
  bool loading = false;

  void _loginUser() async {
    ApiResponse response = await login(txtemail.text, txtpassword.text);
    if (response.error == null) {
      _saveAndRedirectHome(response.data as User);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  void _saveAndRedirectHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);

    if (user.role == 'mahasiswa') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MahasiswaScreen()),
        (route) => false,
      );
    } else if (user.role == 'baak') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => BaakScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 70,
            ),
            // Displaying the 'itdel.png' logo
            Image.asset(
              'assets/images/itdel.png',
              width: 150, // Set the width as per your requirement
              height: 150, // Set the height as per your requirement
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: txtemail,
              validator: (val) =>
                  val!.isEmpty ? 'Invalid email address' : null,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: txtpassword,
              obscureText: true,
              validator: (val) =>
                  val!.length < 6 ? 'Needs at least 6 characters' : null,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const SizedBox(
              height: 30,
            ),
            RoundedButton(
              btnText: 'LOG IN',
              onBtnPressed: () => _loginUser(),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                  (route) => false,
                );
              },
              child: Text(
                "Belum punya akun? Daftar disini",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
