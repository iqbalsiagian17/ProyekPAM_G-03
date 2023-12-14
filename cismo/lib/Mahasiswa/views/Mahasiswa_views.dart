import 'package:cismo/Mahasiswa/views/izinkeluar_views.dart';
import 'package:cismo/Mahasiswa/views/izinbermalam_views.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cismo/Auth/Login/views/login_views.dart';
import 'package:cismo/Mahasiswa/views/requestsurat_views.dart';
class MahasiswaScreen extends StatelessWidget {
  const MahasiswaScreen({Key? key}) : super(key: key);

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
      appBar: AppBar(
        title: Text('Mahasiswa'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RequestIzinKeluarScreen()),
                  );
                },
                child: Text('Izin Keluar'),
              ),
              SizedBox(height: 20), // Add some spacing between buttons if needed
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RequestIzinBermalamScreen()), // Navigate to the new page
                  );
                },
                child: Text('Izin Bermalam'), // Text displayed on the button
              ),
              SizedBox(height: 20), // Add some spacing between buttons if needed
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RequestSuratScreen()), // Navigate to the new page
                  );
                },
                child: Text('Request Surat'), // Text displayed on the button
              ),
              // You can add more content here if needed
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          logout(context);
        },
        label: const Text('Logout'),
        icon: const Icon(Icons.logout),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
