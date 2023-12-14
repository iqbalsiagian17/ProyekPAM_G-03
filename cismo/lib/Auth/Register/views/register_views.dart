import 'package:flutter/material.dart';
import 'package:cismo/api_response.dart';
import 'package:cismo/Auth/Register/models/register.dart';
import 'package:cismo/Auth/Register/controllers/register_controller.dart';
import 'package:cismo/rounded_button.dart';
import 'package:cismo/Mahasiswa/views/Mahasiswa_views.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cismo/Auth/Login/views/login_views.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController txtname = TextEditingController();
  TextEditingController txtnomorktp = TextEditingController();
  TextEditingController txtnomorhandphone = TextEditingController();
  TextEditingController txtnim = TextEditingController();
  TextEditingController txtemail = TextEditingController();
  TextEditingController txtpassword = TextEditingController();

  createAccountPressed() async {
    ApiResponse response = await register(
      txtname.text,
      txtnomorktp.text,
      txtnomorhandphone.text,
      txtnim.text,
      txtemail.text,
      txtpassword.text,
    );
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
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MahasiswaScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: txtname,
              validator: (val) =>
                  val!.isEmpty ? 'Nama Tidak Boleh Kosong' : null,
              decoration: const InputDecoration(
                labelText: 'nama',
                hintText: 'Enter your name',
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: txtnim,
              validator: (val) => val!.isEmpty ? 'NIM tidak boleh kosong' : null,
              decoration: const InputDecoration(
                labelText: 'NIM',
                hintText: 'Enter your NIM',
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: txtnomorhandphone,
              validator: (val) =>
                  val!.isEmpty ? 'Nomor Handphone tidak boleh kosong' : null,
              decoration: const InputDecoration(
                labelText: 'Nomor Handphone',
                hintText: 'Enter your Number Phone',
              ),
            ),
            TextFormField(
              controller: txtnomorktp,
              validator: (val) => val!.isEmpty ? 'Nomor KTP tidak boleh kosong' : null,
              decoration: const InputDecoration(
                labelText: 'Nomor KTP',
                hintText: 'Enter your Number KTP',
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: txtemail,
              validator: (val) =>
                  val!.isEmpty ? 'Invalid email address' : null,
              decoration: const InputDecoration(
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
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const SizedBox(
            ),
            RoundedButton(
              btnText: 'Register',
              onBtnPressed: () => createAccountPressed(),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text(
                "Sudah punya akun? Login sekarang",
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
