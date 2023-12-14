import 'package:flutter/material.dart';
import 'package:cismo/Mahasiswa/views/FormRequestSurat.dart';
import 'package:cismo/api_response.dart';
import 'package:cismo/Mahasiswa/controllers/requestsurat_controller.dart'; // Import the controller for izin bermalam
import 'package:cismo/Auth/Login/views/login_views.dart';
import 'package:cismo/global.dart';
import 'package:cismo/Auth/Login/controllers/login_controller.dart';

class RequestSuratScreen extends StatefulWidget {
  @override
  _RequestSuratScreenState createState() =>
      _RequestSuratScreenState();
}

class _RequestSuratScreenState extends State<RequestSuratScreen> {
  List<dynamic> _requestSuratList = [];
  int userId = 0;
  bool _loading = true;

  Future<void> retrievePosts() async {
    try {
      userId = await getUserId();
      ApiResponse response = await getRequestSurat();

      if (response.error == null) {
        setState(() {
          _requestSuratList = response.data as List<dynamic>;
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
        builder: (context) => FormRequestSurat(
              title: 'Request Izin Bermalam',
            )));
  }

  void deleteRequestSurat(int id) async {
    try {
      ApiResponse response = await DeleteRequestSurat(id);

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
        title: Text('List'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('No')),
                  DataColumn(label: Text('Reason')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _requestSuratList
                    .map(
                      (requestSurat) => DataRow(
                        cells: [
                          DataCell(Text(
                              '${_requestSuratList.indexOf(requestSurat) + 1}')),
                          DataCell(Text(requestSurat.reason)),
                          DataCell(Text(
                              requestSurat.status)), // Replace with actual status property
                          DataCell(
                            PopupMenuButton(
                              itemBuilder: (BuildContext context) {
                                if (requestSurat.status == 'pending') {
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
        builder: (context) => FormRequestSurat(
          title: "Edit Izin Bermalam",
          formRequestSurat: requestSurat, ),
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
                                              deleteRequestSurat(
                                                  requestSurat.id ?? 0);
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
