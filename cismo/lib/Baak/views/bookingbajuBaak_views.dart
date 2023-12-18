import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cismo/global.dart';
import 'package:cismo/Mahasiswa/controllers/bookingbaju_controller.dart';
import 'package:cismo/Auth/Login/controllers/login_controller.dart';
import 'package:cismo/Baak/models/userBaak.dart';
import 'package:cismo/Baak/models/bajuBaak.dart';
import 'package:flutter/material.dart';
import 'package:cismo/api_response.dart';
import 'package:cismo/Baak/models/bookingbajuBaak.dart';
import 'package:cismo/Baak/controllers/bookingbajuBaak_controller.dart';
import 'package:cismo/Auth/Login/views/login_views.dart';

class BookingBajuBaakView extends StatefulWidget {
  @override
  _BookingBajuBaakViewState createState() => _BookingBajuBaakViewState();
}

class _BookingBajuBaakViewState extends State<BookingBajuBaakView> {
  late Future<ApiResponse<List<BookingBaju>>> _bookingBajuData;
List<MahasiswaData>mahasiswaData =[];
List<dynamic> bajuData = [];
  bool _loading = false;


  @override
  void initState() {
    super.initState();
    _bookingBajuData = BookingBajuBaakController.viewAllRequestsForBaak();
    fetchDataMahasiswa();
  }


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Pembelian Baju IT Del'),
    ),
    body: FutureBuilder<ApiResponse<List<BookingBaju>>>(
      future: _bookingBajuData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.error != null) {
          return Center(child: Text('Failed to load data.'));
        } else {
          List<BookingBaju> bookingBajuList = snapshot.data!.data!;
          return ListView.builder(
            itemCount: (bookingBajuList.isNotEmpty) ? (bookingBajuList.length * 2 - 1) : 0,
            itemBuilder: (context, index) {
              if (index.isOdd) {
                return Divider(); // Add Divider after each item
              }
              final bookingIndex = index ~/ 2;
              if (bookingIndex >= 0 && bookingIndex < bookingBajuList.length) {
                BookingBaju bookingBaju = bookingBajuList[bookingIndex];
                return buildBookingBajuTile(bookingBaju);
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



  
  
Widget buildBookingBajuTile(BookingBaju izinKeluar) {
  var mahasiswa = mahasiswaData.firstWhere(
    (m) => m.id.toString() == izinKeluar.userId.toString(),
    orElse: () => MahasiswaData(name: 'unknown', id: null, nim: '' ,email: ''),

  );

  var baju = bajuData.firstWhere(
    (m) => m.id.toString() == izinKeluar.bajuId.toString(),
    orElse: () => BajuData(ukuran: 'L', id: 0, harga: ''),
  );

  return ListTile(
    title: 
    Text('NIM: ${mahasiswa.nim}'),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Text('Nama: ${mahasiswa.name}'),
        Text('Ukuran: ${baju.ukuran}'),
        Text('Status: ${izinKeluar.status}'),
        Text('Pemabayaran: ${izinKeluar.metodePembayaran}'),
        Text('Pengambilan: ${izinKeluar.tanggalPengambilan}'),
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
        await BookingBajuBaakController.approveBookingBaju(izinId);
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to approve: ${response.error}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.data}')),
      );
      setState(() {
        _bookingBajuData = BookingBajuBaakController.viewAllRequestsForBaak();
      });
    }
  }

  void rejectIzin(int izinId) async {
    ApiResponse<String> response =
        await BookingBajuBaakController.rejectBookingBaju(izinId);
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reject: ${response.error}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.data}')),
      );
      setState(() {
        _bookingBajuData = BookingBajuBaakController.viewAllRequestsForBaak();
      });
    }
  }

  Future<void> retrieveBaju() async {
  try {
    // int userId = await getUserId(); // Remove this line if userId is not used

    ApiResponse response = await getBaju(); // Correct function

    if (response.error == null) {
      setState(() {
        bajuData = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == 'unauthorized') {
      logout().then((value) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
      setState(() {
        _loading = false; // Set loading to false on error
      });
    }
  } catch (e) {
    print("Error in fetchBookingData: $e");
    setState(() {
      _loading = false; // Set loading to false on exception
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