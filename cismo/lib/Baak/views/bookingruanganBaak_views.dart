import 'package:flutter/material.dart';
import 'package:cismo/api_response.dart';
import 'package:cismo/Baak/models/bookingruanganBaak.dart';
import 'package:cismo/Baak/controllers/bookingruanganBaak_controller.dart';

class BookingRuanganBaakView extends StatefulWidget {
  @override
  _BookingRuanganBaakViewState createState() => _BookingRuanganBaakViewState();
}

class _BookingRuanganBaakViewState extends State<BookingRuanganBaakView> {
  late Future<ApiResponse<List<RuanganBooking>>> _ruanganBookingData;

  @override
  void initState() {
    super.initState();
    _ruanganBookingData = BookingRuanganBaakController.viewAllRequestsForBaak();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Izin Keluar Baak'),
      ),
      body: FutureBuilder<ApiResponse<List<RuanganBooking>>>(
        future: _ruanganBookingData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot}'));
          } else if (!snapshot.hasData || snapshot.data!.error != null) {
            return Center(child: Text('Failed to load data.'));
          } else {
            List<RuanganBooking> ruanganBookingData = snapshot.data!.data!;
            return ListView.builder(
              itemCount: ruanganBookingData.length * 2 - 1,
              itemBuilder: (context, index) {
                if (index.isOdd) {
                  return Divider(); // Menambahkan Divider setelah setiap item
                }
                final izinIndex = index ~/ 2;
                RuanganBooking booking = ruanganBookingData[izinIndex];
                return buildIzinKeluarTile(booking);
              },
            );
          }
        },
      ),
    );
  }
  
Widget buildIzinKeluarTile(RuanganBooking bookingRuangan) {
  return ListTile(
    title: Text('ID: ${bookingRuangan.userId}'),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ruangan: ${bookingRuangan.ruangan}'),
        Text('Status: ${bookingRuangan.status}'),
        Text('Start Date: ${bookingRuangan.startTime}'),
        Text('End Date: ${bookingRuangan.endTime}'),
        // Add other widgets as needed
      ],
    ),
    trailing: bookingRuangan.status == 'pending'
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  approveIzin(bookingRuangan.id);
                },
                child: Text('Approve'),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  rejectIzin(bookingRuangan.id);
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
        _ruanganBookingData = BookingRuanganBaakController.viewAllRequestsForBaak();
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
        _ruanganBookingData = BookingRuanganBaakController.viewAllRequestsForBaak();
      });
    } 
  }
}