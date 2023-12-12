import 'package:cismo/Mahasiswa/models/izinkeluar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'FormIzinKeluar.dart';
import 'package:cismo/api_response.dart';
import 'package:cismo/Mahasiswa/controllers/izinkeluar_controller.dart';
import 'package:cismo/Auth/Login/views/login_views.dart';
import 'package:cismo/global.dart';
import 'package:cismo/Auth/Login/controllers/login_controller.dart';

class RequestIzinKeluarScreen extends StatefulWidget {
  @override
  _RequestIzinKeluarScreenState createState() =>
      _RequestIzinKeluarScreenState();
}

class _RequestIzinKeluarScreenState extends State<RequestIzinKeluarScreen> {
  List<dynamic> _izinkeluarlist = [];
  int userId = 0;
  bool _loading = true;

  Future<void> retrievePosts() async {
    try {
      userId = await getUserId();
      ApiResponse response = await getIzinKeluar();

      if (response.error == null) {
        setState(() {
          _izinkeluarlist = response.data as List<dynamic>;
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
        builder: (context) => FormIzinKeluars(
              title: 'Request Izin Keluar',
            )));
  }

  void deleteIzinKeluar(int id) async {
    try {
      ApiResponse response = await DeleteIzinKeluar(id);

      if (response.error == null) {
        await Future.delayed(Duration(milliseconds: 300)); // Add this line
        Navigator.pop(context); // Close the confirmation dialog
        retrievePosts(); // Move retrievePosts after the dialog is closed
      } else if (response.error == unauthrorized) {
        // ... (unchanged)
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}'),
        ));
      }
    } catch (e) {
      print("Error in deleteIzinKeluar: $e");
    }
  }

  @override
  void initState() {
    // Call retrievePosts to fetch data when the screen is initialized
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
                rows: _izinkeluarlist
                    .map(
                      (requestIzinKeluar) => DataRow(
                        cells: [
                          DataCell(Text(
                              '${_izinkeluarlist.indexOf(requestIzinKeluar) + 1}')),
                          DataCell(Text(requestIzinKeluar.reason)),
                          DataCell(Text(requestIzinKeluar
                              .status)), // Replace with actual status property
                          DataCell(
                            PopupMenuButton(
                              itemBuilder: (BuildContext context) {
                                return [
                                  PopupMenuItem(
                                    child: Text('Edit'),
                                    value: 'edit',
                                  ),
                                  PopupMenuItem(
                                    child: Text('View'),
                                    value: 'view',
                                  ),
                                  PopupMenuItem(
                                    child: Text('Cancel'),
                                    value: 'delete',
                                  ),
                                ];
                              },
                              onSelected: (String value) {
                                if (value == 'edit') {
                                  int index = _izinkeluarlist
                                      .indexOf(requestIzinKeluar);
                                  RequestIzinKeluar selectedIzinKeluar =
                                      _izinkeluarlist[index];

                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => FormIzinKeluars(
                                      title: "Edit Izin Keluar",
                                      formIzinKeluar: selectedIzinKeluar,
                                    ),
                                  ));
                                } else if (value == 'view') {
                                 showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: Text("View Izin Keluar"),
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Information')),
            DataColumn(label: Text('Details'), numeric: true), // Perluas lebar kolom
          ],
          rows: [
            DataRow(cells: [
              DataCell(Text('Reason')),
              DataCell(Text(requestIzinKeluar.reason)),
            ]),
            DataRow(cells: [
              DataCell(Text('Start Date')),
              DataCell(Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(DateFormat('dd MMMM yyyy').format(requestIzinKeluar.startDate)), // Tampilkan tanggal
                  Text(DateFormat('HH:mm:ss').format(requestIzinKeluar.startDate)), // Tampilkan waktu
                ],
              )),
            ]),
            DataRow(cells: [
              DataCell(Text('End Date')),
              DataCell(Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(DateFormat('dd MMMM yyyy').format(requestIzinKeluar.endDate)), // Tampilkan tanggal
                  Text(DateFormat('HH:mm:ss').format(requestIzinKeluar.endDate)), // Tampilkan waktu
                ],
              )),
            ]),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Close'),
        ),
      ],
    );
  },
);


                                } else if (value == 'delete') {
                                  int index = _izinkeluarlist
                                      .indexOf(requestIzinKeluar);
                                  RequestIzinKeluar selectedIzinKeluar =
                                      _izinkeluarlist[index];
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Delete Izin Keluar"),
                                        content: Text(
                                            "Apakah Anda yakin ingin menghapus izin keluar ini?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                  context); // Tutup dialog konfirmasi
                                            },
                                            child: Text('Batal'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              deleteIzinKeluar(
                                                  selectedIzinKeluar.id ?? 0);
                                            },
                                            child: Text('Hapus'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
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
