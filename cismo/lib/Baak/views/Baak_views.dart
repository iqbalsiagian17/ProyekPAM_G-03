import 'package:cismo/Auth/Login/views/login_views.dart';
import 'package:cismo/Baak/views/bookingbajuBaak_views.dart';
import 'package:cismo/Baak/views/izinbermalamBaak_views.dart';
import 'package:flutter/material.dart';
import 'package:cismo/Baak/views/izinkeluarBaak_views.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cismo/Baak/views/requestsuratBaak_views.dart';
import 'package:cismo/Baak/views/bookingruanganBaak_views.dart';

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

 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Baak IT Del'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
                children: [
                  CustomCard(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => IzinKeluarBaakView()),
                      );
                    },
                    icon: Icons.exit_to_app,
                    text: 'Permohonan Izin Keluar Mahasiswa',
                  ),
                  CustomCard(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => IzinBermalamBaakView()),
                      );
                    },
                    icon: Icons.hotel,
                    text: 'Permohonan Izin Bermalam Mahasiswa',
                  ),
                  CustomCard(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RequestSuratView()),
                      );
                    },
                    icon: Icons.mail,
                    text: 'Permohonan Surat Mahasiwa',
                  ),
                  CustomCard(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BookingRuanganBaakView()), // Tambahkan menuju BookingRuanganScreen
                      );
                    },
                    icon: Icons.room_service, // Ganti dengan ikon yang sesuai
                    text: 'Permohonan Pemakaian Ruangan', // Ganti teks sesuai dengan menu baru
                  ),
                  CustomCard(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BookingBajuBaakView()), // Tambahkan menuju BookingRuanganScreen
                      );
                    },
                    icon: Icons.local_offer, // Ganti dengan ikon yang sesuai
                    text: 'Pemesanan Baju Mahasiswa', // Ganti teks sesuai dengan menu baru
                  ),
                  // Tambahkan card lainnya di sini jika diperlukan
                ],
              ),
            ),
          ),
        ],
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

class CustomCard extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String text;

  const CustomCard({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50),
              SizedBox(height: 10),
              Text(
                text,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}