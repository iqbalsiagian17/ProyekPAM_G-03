import 'package:flutter/material.dart';
import 'package:cismo/api_response.dart';
import 'package:cismo/Baak/models/izinbermalamBaak.dart';
import 'package:cismo/Baak/controllers/izinbermalamBaak_controller.dart';

class IzinBermalamBaakView extends StatefulWidget {
  @override
  _IzinBermalamBaakViewState createState() => _IzinBermalamBaakViewState();
}

class _IzinBermalamBaakViewState extends State<IzinBermalamBaakView> {
  late Future<ApiResponse<List<IzinBermalam>>> _izinBermalamData;

  @override
  void initState() {
    super.initState();
    _izinBermalamData = IzinBermalamBaakController.viewAllRequestsForBaak();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Izin Bermalam Baak'),
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
              itemCount: izinBermalamList.length * 2 - 1,
              itemBuilder: (context, index) {
                if (index.isOdd) {
                  return Divider(); // Menambahkan Divider setelah setiap item
                }
                final izinIndex = index ~/ 2;
                IzinBermalam izinBermalam = izinBermalamList[izinIndex];
                return buildIzinBermalamTile(izinBermalam);
              },
            );
          }
        },
      ),
    );
  }
  
  Widget buildIzinBermalamTile(IzinBermalam izinBermalam) {
    return ListTile(
      title: Text('ID: ${izinBermalam.userId}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reason: ${izinBermalam.reason}'),
          Text('Status: ${izinBermalam.status}'),
          Text('Start Date: ${izinBermalam.startDate}'),
          Text('End Date: ${izinBermalam.endDate}'),
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
}
