import 'package:cismo/Auth/Login/views/login_views.dart';
import 'package:cismo/Baak/views/izinbermalamBaak_views.dart';
import 'package:flutter/material.dart';
import 'package:cismo/Baak/views/izinkeluarBaak_views.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cismo/Baak/views/requestsuratBaak_views.dart';

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
              logout(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Image.asset(
            'assets/images/itdel.png',
            width: 100,
            height: 150,
          ),
          Text(
            'Welcome to Baak Screen',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CardItem(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IzinKeluarBaakView(),
                          ),
                        );
                      },
                      icon: Icon(Icons.exit_to_app, size: 70), // Icon keluar dengan ukuran 70
                      text: 'Request Izin Keluar',
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CardItem(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IzinBermalamBaakView(),
                          ),
                        );
                      },
                      icon: Icon(Icons.hotel, size: 70), // Icon bermalam dengan ukuran 70
                      text: 'Request Izin Bermalam',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CardItem(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RequestSuratView(),
                          ),
                        );
                      },
                      icon: Icon(Icons.mail, size: 70), // Icon surat dengan ukuran 70
                      text: 'Request Surat',
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CardItem(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RequestSuratView(),
                          ),
                        );
                      },
                      icon: Icon(Icons.room_service, size: 70), // Icon surat dengan ukuran 70
                      text: 'Booking Ruangan',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;
  final String text;

  const CardItem({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(height: 8),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
