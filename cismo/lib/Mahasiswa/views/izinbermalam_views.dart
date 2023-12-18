import 'package:flutter/material.dart';
import 'package:cismo/Mahasiswa/views/FormIzinBermalam.dart';
import 'package:cismo/api_response.dart';
import 'package:cismo/Mahasiswa/controllers/izinbermalam_controller.dart'; // Import the controller for izin bermalam
import 'package:cismo/Auth/Login/views/login_views.dart';
import 'package:cismo/global.dart';
import 'package:cismo/Auth/Login/controllers/login_controller.dart';

class RequestIzinBermalamScreen extends StatefulWidget {
  @override
  _RequestIzinBermalamScreenState createState() =>
      _RequestIzinBermalamScreenState();
}

class _RequestIzinBermalamScreenState extends State<RequestIzinBermalamScreen> {
  List<dynamic> _izinBermalamList = [];
  int userId = 0;
  bool _loading = true;

  Future<void> retrievePosts() async {
    try {
      userId = await getUserId();
      ApiResponse response = await getIzinBermalam();

      if (response.error == null) {
        setState(() {
          _izinBermalamList = response.data as List<dynamic>;
          _loading = _loading ? !_loading : _loading;
        });
      } else if (response.error == unauthrorized) {
        logout().then((value) => {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              )
            });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}'),
        ));
      }
    } catch (e) {
      print("Error in retrievePosts: $e");
    }
  }

  void _navigateToAddData() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => FormIzinBermalam(
              title: 'Request Izin Bermalam',
            )));
  }

  void deleteIzinBermalam(int id) async {
    try {
      ApiResponse response = await DeleteIzinBermalam(id);

      if (response.error == null) {
        await Future.delayed(Duration(milliseconds: 300));
        Navigator.pop(context);
        retrievePosts();
      } else if (response.error == unauthrorized) {
        // Handle unauthorized
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}'),
        ));
      }
    } catch (e) {
      print("Error in deleteIzinBermalam: $e");
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
        title: Text('Permohonan Izin Bermalam'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('No')),
                  DataColumn(label: Text('Alasan')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _izinBermalamList
                    .map(
                      (izinBermalam) => DataRow(
                        cells: [
                          DataCell(Text(
                              '${_izinBermalamList.indexOf(izinBermalam) + 1}')),
                          DataCell(Text(izinBermalam.reason)),
                          DataCell(Text(
                              izinBermalam.status)), // Replace with actual status property
                          DataCell(
                            PopupMenuButton(
                              itemBuilder: (BuildContext context) {
                                if (izinBermalam.status == 'pending') {
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
        builder: (context) => FormIzinBermalam(
          title: "Edit Izin Bermalam",
          formIzinBermalam: izinBermalam, ),
                                  ));                                  // You can navigate to a form for editing
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
                                              deleteIzinBermalam(
                                                  izinBermalam.id ?? 0);
                                            },
                                            child: Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else if (value == 'view') {
                                  // Handle view action
                                  // You can show detailed view of the data
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
        onPressed: _navigateToAddData,
        child: Icon(Icons.add),
      ),
    );
  }
}
