import 'package:flutter/material.dart';
import 'package:utama/services/izinkeluar_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
  
class IzinkeluarScreen extends StatefulWidget {
  const IzinkeluarScreen({Key? key}) : super(key: key);

  @override
  _IzinkeluarScreenState createState() => _IzinkeluarScreenState();
}

class _IzinkeluarScreenState extends State<IzinkeluarScreen> {
  TextEditingController reasonController = TextEditingController();
  TextEditingController timeOutController = TextEditingController();
  TextEditingController timeInController = TextEditingController();
  late String token = ''; // Token dideklarasikan dan diinisialisasi dengan string kosong

  @override
  void initState() {
    super.initState();
    getToken(); // Panggil fungsi getToken() saat initState()
  }

Future<void> getToken() async {
   SharedPreferences pref = await SharedPreferences.getInstance();
  String? savedToken = pref.getString('token');  

  // Periksa jika savedToken tidak null dan bukan string kosong
  if (savedToken != null && savedToken.isNotEmpty) {
    setState(() {
      token = savedToken;
      print('Token: $token'); // Tambahkan ini untuk memeriksa token
    });

    // Panggil submitIzinKeluar() hanya jika token tidak kosong
    submitIzinKeluar();
 } else {
    print('Token kosong atau tidak diperoleh');
    // Lakukan penanganan jika token kosong atau tidak diperoleh
  }
}



  Future<void> submitIzinKeluar() async {
    String reason = reasonController.text;
    String timeOut = timeOutController.text;
    String timeIn = timeInController.text;

    if (token.isNotEmpty) {
var response = await IzinkeluarServices.requestIzinKeluar(
  reason,
  timeOut,
  timeIn,
);


      if (response.statusCode == 200) {
        print('Permintaan izin keluar berhasil');
        // Perform navigation or other logic here
      } else {
        print('Gagal membuat permintaan izin keluar');
        // Handle errors
      }
    } else {
      print('Token kosong atau tidak diperoleh');
      // Handle case when token is empty or not obtained
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Izin Keluar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason',
              ),
            ),
            TextFormField(
              controller: timeOutController,
              decoration: const InputDecoration(
                labelText: 'Time Out',
              ),
            ),
            TextFormField(
              controller: timeInController,
              decoration: const InputDecoration(
                labelText: 'Time In',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                submitIzinKeluar();
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
