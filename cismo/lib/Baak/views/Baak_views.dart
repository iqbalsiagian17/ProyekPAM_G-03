import 'package:cismo/Auth/Login/views/login_views.dart';
import 'package:cismo/Baak/views/izinbermalamBaak_views.dart';
import 'package:flutter/material.dart';
import 'package:cismo/Baak/views/izinkeluarBaak_views.dart';
import 'package:shared_preferences/shared_preferences.dart';
class BaakScreen extends StatelessWidget {
  const BaakScreen({Key? key}) : super(key: key);

   Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Panggil fungsi logout saat tombol logout ditekan
              logout(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Baak Screen',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IzinKeluarBaakView(),
                  ),
                );
              },
              child: Text('Lihat Request Izin Keluar'),
            ),
            SizedBox(height: 20), // Add some space between buttons

            // Button to navigate to IzinBermalamBaakView
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IzinBermalamBaakView(),
                  ),
                );
              },
              child: Text('Lihat Request Izin Bermalam'),
            ),
            // Add more menu items as needed
          ],
        ),
      ),
    );
  }
}
