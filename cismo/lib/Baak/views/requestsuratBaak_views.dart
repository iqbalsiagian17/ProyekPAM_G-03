import 'package:flutter/material.dart';
import 'package:cismo/api_response.dart';
import 'package:cismo/Baak/models/requestsuratBaak.dart';
import 'package:cismo/Baak/controllers/requestsuratBaak_controller.dart';

class RequestSuratView extends StatefulWidget {
  @override
  _RequestSuratViewState createState() => _RequestSuratViewState();
}

class _RequestSuratViewState extends State<RequestSuratView> {
  late Future<ApiResponse<List<RequestSurat>>> _requestSuratData;

  @override
  void initState() {
    super.initState();
    _requestSuratData = RequestSuratBaakController.viewAllRequestsForBaak();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Permohonan Booking Ruangan'),
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

  String loggedInUserName = 'Nama Pengguna Default'; 

  
  Widget buildRequestSuratTile(RequestSurat requestSurat) {
    return ListTile(
      title: Text('ID: ${requestSurat.userId}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reason: ${requestSurat.reason}'),
          Text('Status: ${requestSurat.status}'),
          Text('startDate: ${requestSurat.startDate}'),
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
}
