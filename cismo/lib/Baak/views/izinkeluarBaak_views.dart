import 'package:flutter/material.dart';
import 'package:cismo/api_response.dart';
import 'package:cismo/Baak/models/izinkeluarBaak.dart';
import 'package:cismo/Baak/controllers/izinkeluarBaak_controller.dart';

class IzinKeluarBaakView extends StatefulWidget {
  @override
  _IzinKeluarBaakViewState createState() => _IzinKeluarBaakViewState();
}

class _IzinKeluarBaakViewState extends State<IzinKeluarBaakView> {
  late Future<ApiResponse<List<IzinKeluar>>> _izinKeluarData;

  @override
  void initState() {
    super.initState();
    _izinKeluarData = IzinKeluarBaakController.viewAllRequestsForBaak();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Izin Keluar Baak'),
      ),
      body: FutureBuilder<ApiResponse<List<IzinKeluar>>>(
        future: _izinKeluarData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.error != null) {
            return Center(child: Text('Failed to load data.'));
          } else {
            List<IzinKeluar> izinKeluarList = snapshot.data!.data!;
            return ListView.builder(
              itemCount: izinKeluarList.length * 2 - 1,
              itemBuilder: (context, index) {
                if (index.isOdd) {
                  return Divider(); // Menambahkan Divider setelah setiap item
                }
                final izinIndex = index ~/ 2;
                IzinKeluar izinKeluar = izinKeluarList[izinIndex];
                return buildIzinKeluarTile(izinKeluar);
              },
            );
          }
        },
      ),
    );
  }
  
Widget buildIzinKeluarTile(IzinKeluar izinKeluar) {
  return ListTile(
    title: Text('ID: ${izinKeluar.userId}'),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reason: ${izinKeluar.reason}'),
        Text('Status: ${izinKeluar.status}'),
        Text('Start Date: ${izinKeluar.startDate}'),
        Text('End Date: ${izinKeluar.endDate}'),
        // Add other widgets as needed
      ],
    ),
    trailing: izinKeluar.status == 'pending'
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  approveIzin(izinKeluar.id);
                },
                child: Text('Approve'),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  rejectIzin(izinKeluar.id);
                },
                child: Text('Reject'),
              ),
            ],
          )
        : null, // Trailing null jika status bukan 'pending'
  );
}


  void approveIzin(int izinId) async {
    ApiResponse<String> response =
        await IzinKeluarBaakController.approveIzinKeluar(izinId);
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to approve: ${response.error}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.data}')),
      );
      setState(() {
        _izinKeluarData = IzinKeluarBaakController.viewAllRequestsForBaak();
      });
    }
  }

  void rejectIzin(int izinId) async {
    ApiResponse<String> response =
        await IzinKeluarBaakController.rejectIzinKeluar(izinId);
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reject: ${response.error}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.data}')),
      );
      setState(() {
        _izinKeluarData = IzinKeluarBaakController.viewAllRequestsForBaak();
      });
    }
  }
}