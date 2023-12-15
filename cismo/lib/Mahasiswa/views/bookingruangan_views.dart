import 'package:cismo/Mahasiswa/views/FormBookingRuangan.dart';
import 'package:flutter/material.dart';
import 'package:cismo/Mahasiswa/controllers/bookingruangan_controller.dart';
import 'package:cismo/api_response.dart';
import 'package:cismo/Auth/Login/views/login_views.dart';
import 'package:cismo/Auth/Login/controllers/login_controller.dart';

class BookingRuanganScreen extends StatefulWidget {
  @override
  _BookingRuanganScreenState createState() => _BookingRuanganScreenState();
}

class _BookingRuanganScreenState extends State<BookingRuanganScreen> {
  List<dynamic> _bookingRuanganList = [];
  int userId = 0;
  bool _loading = true;

  Future<void> retrievePosts() async {
    try {
      userId = await getUserId();
      ApiResponse response = await getRuanganBooking(); // Correct function

      if (response.error == null) {
        setState(() {
          _bookingRuanganList = response.data as List<dynamic>;
          _loading =_loading ? !_loading : _loading;
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

void _navigateToFormBookingRuangan() {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => FormBookingRuangan(), // Assuming FormBookingRuangan is the screen for creating a new booking
  ));
}


  void CancelBooking(int id) async {
    try {
      ApiResponse response = await Cancelbooking(id);

      if (response.error == null) {
        await Future.delayed(Duration(milliseconds: 300));
        Navigator.pop(context);
        retrievePosts();
    } else if (response.error == 'unauthorized') {
        // Handle unauthorized
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}'),
        ));
      }
    } catch (e) {
      print("Error in cancelBooking: $e");
    }
  }

  @override
  void initState() {
    retrievePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('No')),
                  DataColumn(label: Text('Ruangan')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _bookingRuanganList
                    .map(
                      (bookingRuangan) => DataRow(
                        cells: [
                          DataCell(Text('${_bookingRuanganList.indexOf(bookingRuangan) + 1}')),
                          DataCell(Text(bookingRuangan.ruangan)),
                          DataCell(Text(bookingRuangan.status)),
                          DataCell(
                            PopupMenuButton(
                              itemBuilder: (BuildContext context) {
                                if (bookingRuangan.status == 'pending') {
                                  return [
                                    PopupMenuItem(
                                      child: Text('Edit'),
                                      value: 'edit',
                                    ),
                                    PopupMenuItem(
                                      
                                      child: Text('Delete'),
                                      value: 'delete',
                                    ),
                                  ];
                                } else {
                                  return [
                                    PopupMenuItem(
                                      child: Text('View'),
                                      value: 'view',
                                    ),
                                  ];
                                }
                              },
                              onSelected: (String value) {
                                if (value == 'edit') {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => FormBookingRuangan(
                                      title: "Edit Izin Bermalam",
                                      formBookingRuangan: bookingRuangan,
                                    ),
                                  ));
                                } else if (value == 'delete') {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Delete Izin Bermalam"),
                                        content: Text(
                                            "Are you sure you want to delete this data?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              CancelBooking(bookingRuangan.id);
                                            },
                                            child: Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else if (value == 'view') {
                                  // Handle view action
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToFormBookingRuangan,
        child: Icon(Icons.add),
      ),
    );
  }
}
