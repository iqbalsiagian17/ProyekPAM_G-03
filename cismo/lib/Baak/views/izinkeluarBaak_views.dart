import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cismo/global.dart';

import 'package:cismo/Auth/Login/controllers/login_controller.dart';
import 'package:cismo/Baak/models/userBaak.dart';
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
  List<MahasiswaData>mahasiswaData =[];

  @override
  void initState() {
    super.initState();
    _izinKeluarData = IzinKeluarBaakController.viewAllRequestsForBaak();
    fetchDataMahasiswa();
  }

  

Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Permohonan Izin Keluar Mahasiswa'),
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
            itemCount: (izinKeluarList.length > 0) ? izinKeluarList.length : 0,
            itemBuilder: (context, index) {
              IzinKeluar izinKeluar = izinKeluarList[index];
              return buildIzinKeluarCard(izinKeluar);
            },
          );
        }
      },
    ),
  );
}

Widget buildIzinKeluarCard(IzinKeluar izinKeluar) {
  var mahasiswa = mahasiswaData.firstWhere(
    (m) => m.id.toString() == izinKeluar.id.toString(),
    orElse: () => MahasiswaData(name: 'unknown', id: null, nim: '',email: ''),
  );

  return Card(
    margin: EdgeInsets.all(8.0),
    child: ListTile(
      title: Text('NIM: ${mahasiswa.nim}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nama: ${mahasiswa.name}'),
          Text('Alasan: ${izinKeluar.reason}'),
          Text('Status: ${izinKeluar.status}'),
          Text('Berangkat: ${izinKeluar.startDate}'),
          Text('Kembali: ${izinKeluar.endDate}'),
        ],
      ),
      trailing: (izinKeluar.status == 'pending')
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
          : null,
    ),
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

  Future<void> fetchDataMahasiswa() async {
  try {
      String token = await getToken();

  final response = await http.get(
        Uri.parse('${baseURL}getmahasiswa'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      setState(() {
        mahasiswaData = responseData.map((item) => MahasiswaData.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load mahasiswa data');
    }
  } catch (error) {
    throw Exception('Failed to load mahasiswa data: $error');
  }
}


}