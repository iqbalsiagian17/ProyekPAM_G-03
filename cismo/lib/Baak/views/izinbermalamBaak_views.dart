import 'package:flutter/material.dart';
import 'package:cismo/api_response.dart';
import 'package:cismo/Baak/models/izinbermalamBaak.dart';
import 'package:cismo/Baak/controllers/izinbermalamBaak_controller.dart';
import 'package:cismo/Baak/models/userBaak.dart';
import 'package:cismo/Auth/Login/controllers/login_controller.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cismo/global.dart';


class IzinBermalamBaakView extends StatefulWidget {
  @override
  _IzinBermalamBaakViewState createState() => _IzinBermalamBaakViewState();
}

class _IzinBermalamBaakViewState extends State<IzinBermalamBaakView> {
  late Future<ApiResponse<List<IzinBermalam>>> _izinBermalamData;
  List<MahasiswaData>mahasiswaData =[];

  @override
  void initState() {
    super.initState();
    _izinBermalamData = IzinBermalamBaakController.viewAllRequestsForBaak();
    fetchDataMahasiswa();

  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Permohonan Izin Bermalam Mahasiswa'),
    ),
    body: FutureBuilder<ApiResponse<List<IzinBermalam>>>(
      future: _izinBermalamData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.error != null) {
          return Center(child: Text('Failed to load data.'));
        } else {
          List<IzinBermalam> izinBermalamList = snapshot.data!.data!;
          return ListView.builder(
            itemCount: (izinBermalamList.isNotEmpty) ? (izinBermalamList.length * 2 - 1) : 0,
            itemBuilder: (context, index) {
              if (index.isOdd) {
                return Divider(); // Add Divider after each item
              }
              final izinIndex = index ~/ 2;
              if (izinIndex >= 0 && izinIndex < izinBermalamList.length) {
                IzinBermalam izinBermalam = izinBermalamList[izinIndex];
                return buildIzinBermalamTile(izinBermalam);
              } else {
                return SizedBox(); // Return an empty SizedBox for invalid indices
              }
            },
          );
        }
      },
    ),
  );
}

  
  Widget buildIzinBermalamTile(IzinBermalam izinBermalam) {
 var mahasiswa = mahasiswaData.firstWhere(
    (m) => m.id.toString() == izinBermalam.id.toString(),
    orElse: () => MahasiswaData(name: 'unknown', id: null, nim: '',email: ''),

  );

    return ListTile(
      title: Text('NIM: ${mahasiswa.nim}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nama : ${mahasiswa.name}'),
          Text('Alasan : ${izinBermalam.reason}'),
          Text('Status : ${izinBermalam.status}'),
          Text('Berangkat : ${izinBermalam.startDate}'),
          Text('Kembali : ${izinBermalam.endDate}'),
          // Add other widgets as needed
        ],
      ),
      trailing: izinBermalam.status == 'pending'
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    approveIzin(izinBermalam.id);
                  },
                  child: Text('Approve'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    rejectIzin(izinBermalam.id);
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
        await IzinBermalamBaakController.approveIzinBermalam(izinId);
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to approve: ${response.error}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.data}')),
      );
      setState(() {
        _izinBermalamData = IzinBermalamBaakController.viewAllRequestsForBaak();
      });
    }
  }

  void rejectIzin(int izinId) async {
    ApiResponse<String> response =
        await IzinBermalamBaakController.rejectIzinBermalam(izinId);
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reject: ${response.error}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.data}')),
      );
      setState(() {
        _izinBermalamData = IzinBermalamBaakController.viewAllRequestsForBaak();
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
