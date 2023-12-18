  import 'dart:convert';

import 'package:flutter/material.dart';
  import 'package:cismo/api_response.dart';
  import 'package:cismo/Baak/models/bookingruanganBaak.dart';
  import 'package:cismo/Baak/controllers/bookingruanganBaak_controller.dart';
  import 'package:cismo/Baak/models/userBaak.dart';
  import 'package:cismo/Auth/Login/controllers/login_controller.dart';
  import 'package:http/http.dart' as http;
  import 'package:cismo/global.dart';

  class BookingRuanganBaakView extends StatefulWidget {
    @override
    _BookingRuanganBaakViewState createState() => _BookingRuanganBaakViewState();
  }

  class _BookingRuanganBaakViewState extends State<BookingRuanganBaakView> {
    late Future<ApiResponse<List<BookingRuanganBaak>>> _bookingRuanganData;
    List<MahasiswaData>mahasiswaData =[];


    @override
    void initState() {
      super.initState();
      _bookingRuanganData = BookingRuanganBaakController.viewAllRequestsForBaak();
        fetchDataMahasiswa();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('List Booking Ruangan'),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  // Refresh data
                  _bookingRuanganData =
                      BookingRuanganBaakController.viewAllRequestsForBaak();
                });
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
          ),
          child: FutureBuilder<ApiResponse<List<BookingRuanganBaak>>>(
            future: _bookingRuanganData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.error != null) {
                final error = snapshot.data?.error ?? 'Failed to load data.';
                return Center(child: Text(error));
              } else {
                List<BookingRuanganBaak> bookingRuanganList =
                    snapshot.data!.data!;
                return ListView.builder(
                  itemCount: bookingRuanganList.length,
                  itemBuilder: (context, index) {
                    BookingRuanganBaak bookingRuangan = bookingRuanganList[index];
                    
                    var mahasiswa = mahasiswaData.firstWhere(
                    (m) => m.id.toString() == bookingRuangan.userId.toString(),
                    orElse: () => MahasiswaData(name: 'unknown', id: null, nim: '',email: ''),
                  );
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text('NIM: ${mahasiswa.nim}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nama : ${mahasiswa.name}'),
                            Text('Tujuan : ${bookingRuangan.reason}'),
                            Text('Status: ${bookingRuangan.status}'),
                            Text('Ruangan : ${bookingRuangan.roomId}'),
                            Text('Mulai : ${bookingRuangan.startTime}'),
                            Text('Sampai : ${bookingRuangan.endTime}'),
                          ],
                        ),
                        trailing: (bookingRuangan.status == 'pending')
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          approveIzin(bookingRuangan.id);
                                        },
                                        child: Text('Approve'),
                                      ),
                                      SizedBox(width: 8.0),
                                      ElevatedButton(
                                        onPressed: () {
                                          rejectIzin(bookingRuangan.id);
                                        },
                                        child: Text('Reject'),
                                      ),
                                    ],
                                  ):null,
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      );
    }

    void approveIzin(int izinId) async {
      ApiResponse<String> response =
          await BookingRuanganBaakController.approveBookingRuangan(izinId);
      if (response.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to approve: ${response.error}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.data}')),
        );
        setState(() {
          // Refresh data after approval
          _bookingRuanganData =
              BookingRuanganBaakController.viewAllRequestsForBaak();
        });
      }
    }

    void rejectIzin(int izinId) async {
      ApiResponse<String> response =
          await BookingRuanganBaakController.rejectBookingRuangan(izinId);
      if (response.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to reject: ${response.error}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.data}')),
        );
        setState(() {
          _bookingRuanganData =
              BookingRuanganBaakController.viewAllRequestsForBaak();
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