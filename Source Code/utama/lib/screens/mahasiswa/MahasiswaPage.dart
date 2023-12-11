import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utama/screens/Auth/login_screen.dart'; // Ganti dengan alamat login screen yang benar
import 'package:utama/screens/mahasiswa/izinkeluar/izinkeluar_screen.dart';

class MahasiswaPage extends StatefulWidget {
  const MahasiswaPage({Key? key}) : super(key: key);

  @override
  _MahasiswaPageState createState() => _MahasiswaPageState();
}

class _MahasiswaPageState extends State<MahasiswaPage> {
  Future<void> logout() async {
    // Hapus token dari SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    // Navigate to the login screen and remove all other routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()),
      (route) => false, // Remove all routes on top of the new route
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mahasiswa Page'),
      ),
      body: Center(
        child: Container(
          height: 80,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextButton(
            onPressed: () {
              // Navigate to IzinkeluarScreen when the button is pressed
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const IzinkeluarScreen(),
                ),
              );
            },
            child: const Text(
              'Izin Keluar',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          logout(); // Panggil fungsi logout saat tombol di tekan
        },
        label: const Text('Logout'),
        icon: const Icon(Icons.logout),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
