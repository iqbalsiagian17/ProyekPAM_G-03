import 'package:flutter/material.dart';
import 'package:cismo/api_response.dart';
import 'package:cismo/Baak/models/requestsuratBaak.dart';
import 'package:cismo/Baak/controllers/requestsuratBaak_controller.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cismo/global.dart';
import 'package:cismo/Auth/Login/controllers/login_controller.dart';
import 'package:cismo/Baak/models/userBaak.dart';


class RequestSuratView extends StatefulWidget {
  @override
  _RequestSuratViewState createState() => _RequestSuratViewState();
}

class _RequestSuratViewState extends State<RequestSuratView> {
  late Future<ApiResponse<List<RequestSurat>>> _requestSuratData;
    List<MahasiswaData>mahasiswaData =[];


  @override
  void initState() {
    super.initState();
    _requestSuratData = RequestSuratBaakController.viewAllRequestsForBaak();
    fetchDataMahasiswa();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Permohonan Request Surat Mahasiswa'),
      ),
      body: FutureBuilder<ApiResponse<List<RequestSurat>>>(
        future: _requestSuratData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.error != null) {
            return Center(child: Text('Failed to load data.'));
          } else {
            List<RequestSurat> requestSuratData = snapshot.data!.data!;
            return ListView.builder(
  itemCount: requestSuratData.isEmpty ? 0 : requestSuratData.length * 2 - 1,

  itemBuilder: (context, index) {
    if (index.isOdd) {
      return const Divider(); // Menambahkan Divider setelah setiap item
    }
    final izinIndex = index ~/ 2;
    RequestSurat requestSurat = requestSuratData[izinIndex]; // Change here
    return buildRequestSuratTile(requestSurat);
  },
);

          }
        },
      ),
    );
  }
  
  Widget buildRequestSuratTile(RequestSurat requestSurat) {
      var mahasiswa = mahasiswaData.firstWhere(
    (m) => m.id.toString() == requestSurat.id.toString(),
    orElse: () => MahasiswaData(name: 'unknown', id: null, nim: '',email: ''),
  );
  
    return ListTile(
      title: Text('NIM: ${mahasiswa.nim}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tujuan: ${mahasiswa.name}'),
          Text('Tujuan: ${requestSurat.reason}'),
          Text('Status: ${requestSurat.status}'),
          Text('Waktu Pengambilan : ${requestSurat.startDate}'),
          // Add other widgets as needed
        ],
      ),
      trailing: requestSurat.status == 'pending'
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    approveIzin(requestSurat.id);
                  },
                  child: Text('Approve'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    rejectIzin(requestSurat.id);
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
        await RequestSuratBaakController.approveRequestSurat(izinId);
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to approve: ${response.error}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.data}')),
      );
      setState(() {
        _requestSuratData = RequestSuratBaakController.viewAllRequestsForBaak();
      });
    }
  }

  void rejectIzin(int izinId) async {
    ApiResponse<String> response =
        await RequestSuratBaakController.rejectRequestSurat(izinId);
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reject: ${response.error}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.data}')),
      );
      setState(() {
        _requestSuratData = RequestSuratBaakController.viewAllRequestsForBaak();
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
