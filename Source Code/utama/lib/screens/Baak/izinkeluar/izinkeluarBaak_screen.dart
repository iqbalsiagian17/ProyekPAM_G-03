import 'package:flutter/material.dart';
import 'package:utama/Services/Izinkeluar_services.dart'; // Sesuaikan path import dengan struktur proyek Anda
import 'package:http/http.dart' as http;

class IzinKeluarBaakScreen extends StatefulWidget {
  const IzinKeluarBaakScreen({Key? key}) : super(key: key);

  @override
  _IzinKeluarBaakScreenState createState() => _IzinKeluarBaakScreenState();
}

class _IzinKeluarBaakScreenState extends State<IzinKeluarBaakScreen> {
  List<dynamic> izinKeluarList = [];

  @override
  void initState() {
    super.initState();
    fetchIzinKeluarList();
  }

  Future<void> fetchIzinKeluarList() async {
    List<dynamic> list = await IzinkeluarServices.getAllIzinKeluar();

    setState(() {
      izinKeluarList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Izin Keluar List'),
      ),
      body: izinKeluarList.isNotEmpty
          ? ListView.builder(
              itemCount: izinKeluarList.length,
              itemBuilder: (context, index) {
                final izinKeluar = izinKeluarList[index];
                return ListTile(
                  title: Text('Mahasiswa: ${izinKeluar['nama']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Alasan: ${izinKeluar['reason']}'),
                      Text('Status: ${izinKeluar['status']}'),
                      // Tambahkan detail status lainnya sesuai kebutuhan
                    ],
                  ),
                  trailing: izinKeluar['status'] == 'pending'
                      ? ElevatedButton(
                          onPressed: () {
                            // Panggil fungsi approveIzinKeluar dengan izinId yang sesuai
                            approveIzinKeluar(izinKeluar['id']);
                          },
                          child: Text('Approve'),
                        )
                      : null, // Hanya tampilkan tombol 'Approve' jika status izin keluar masih 'pending'
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Future<void> approveIzinKeluar(int izinId) async {
    try {
      http.Response response = await IzinkeluarServices.approveIzinKeluar(izinId);
      if (response.statusCode == 200) {
        print('Izin keluar berhasil disetujui');
        // Refresh list setelah berhasil menyetujui izin
        fetchIzinKeluarList();
      } else {
        print('Gagal menyetujui izin keluar');
        // Tampilkan pesan atau handling error lainnya jika diperlukan
      }
    } catch (error) {
      print('Error: $error');
      // Tampilkan pesan atau handling error lainnya jika diperlukan
    }
  }
}
