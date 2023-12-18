  import 'package:cismo/Mahasiswa/models/surat.dart';
  import 'package:cismo/Mahasiswa/views/FormRequestSurat.dart';
  import 'package:flutter/material.dart';
  import 'package:intl/intl.dart';
  import 'package:cismo/api_response.dart';
  import 'package:cismo/Mahasiswa/controllers/requestsurat_controller.dart';
  import 'package:cismo/Auth/Login/views/login_views.dart';
  import 'package:cismo/global.dart';
  import 'package:cismo/Auth/Login/controllers/login_controller.dart';

  class RequestSuratScreen extends StatefulWidget {
    @override
    _RequestSuratScreenState createState() =>
        _RequestSuratScreenState();
  }

  class _RequestSuratScreenState extends State<RequestSuratScreen> {
    List<dynamic> _requestSurat = [];
    int userId = 0;
    bool _loading = true;

    Future<void> retrievePosts() async {
      try {
        userId = await getUserId();
        ApiResponse response = await getRequestSurat();

        if (response.error == null) {
          setState(() {
            _requestSurat = response.data as List<dynamic>;
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
                title: 'Request Surat',
              )));
    }

    void deleteIzinKeluar(int id) async {
      try {
        ApiResponse response = await DeleteRequestSurat(id);

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
        print("Error in delete Reqeust Surat: $e");
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
          title: Text('Permohonan Request Surat'),
        ),
        body: _loading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('No')),
                    DataColumn(label: Text('Tujuan')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: _requestSurat
                      .map(
                        (requestSurat) => DataRow(
                          cells: [
                            DataCell(Text(
                                '${_requestSurat.indexOf(requestSurat) + 1}')),
                            DataCell(Text(requestSurat.reason)),
                            DataCell(Text(requestSurat
                                .status)), // Replace with actual status property
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
            child: Text('View'),
            value: 'view',
          ),
          PopupMenuItem(
            child: Text('Cancel'),
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
      if (requestSurat.status == 'pending') {
        if (value == 'edit') {
          int index = _requestSurat.indexOf(requestSurat);
          RequestSurat selectedRequestSurat = _requestSurat[index];
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => FormRequestSurat(
              title: "Edit Reqeust Surat",
              formRequestSurat: selectedRequestSurat,
            ),
          ));
        } else if (value == 'delete') {
          int index = _requestSurat.indexOf(requestSurat);
          RequestSurat selectedRequestSurat = _requestSurat[index];
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Delete Reqeust Surat"),
                content: Text("Apakah Anda yakin ingin menghapus Reqeust Surat ini?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Tutup dialog konfirmasi
                    },
                    child: Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () {
                      deleteIzinKeluar(selectedRequestSurat.id ?? 0);
                    },
                    child: Text('Hapus'),
                  ),
                ],
              );
            },
          );
        } else if (value == 'view') {
          showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
  title: Text("View Reqeust Surat"),
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
          DataCell(Text(requestSurat.reason)),
        ]),
        DataRow(cells: [
          DataCell(Text('Start Date')), // Ubah label menjadi 'Start Date'
          DataCell(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat('dd MMMM yyyy').format(requestSurat.startDate)), // Menggunakan startDate
              Text(DateFormat('HH:mm:ss').format(requestSurat.startDate)), // Menggunakan startDate
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
        }
      } else if (value == 'view') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("View Reqeust Surat"),
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
                      DataCell(Text(requestSurat.reason)),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Start Date')),
                      DataCell(Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(DateFormat('dd MMMM yyyy').format(requestSurat.startDate)),
                          Text(DateFormat('HH:mm:ss').format(requestSurat.startDate)),
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
      }
    },
  )

                              
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
