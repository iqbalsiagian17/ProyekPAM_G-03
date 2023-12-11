import 'package:flutter/material.dart';
import 'package:utama/screens/Baak/izinkeluar/izinkeluarBaak_screen.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  void approveLeaveRequest() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const IzinKeluarBaakScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 80,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Welcome BAAK',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: approveLeaveRequest,
              child: const Text('Approve Leave for Mahasiswa'),
            ),
          ],
        ),
      ),
    );
  }
}
