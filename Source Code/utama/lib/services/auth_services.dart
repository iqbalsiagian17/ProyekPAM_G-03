import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:utama/Services/globals.dart';

class AuthServices {
  static Future<http.Response> register(
      String nama, String nim, String noKtp, String nomorHandphone, String email, String password) async {
    Map data = {
      "nama": nama,
      "nim": nim,
      "noKtp": noKtp,
      "nomorHandphone": nomorHandphone,
      "email": email,
      "password": password,
    };

    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'auth/register');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print(response.body);
    return response;
  }

 static Future<http.Response> login(String email, String password) async {
    Map data = {
      "email": email,
      "password": password,
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'auth/login');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      String token = responseData['token']; // Ambil token dari respons
      print('Token: $token'); // Tampilkan token di konsol debug

      // Simpan token ke SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
    }

    print(response.body);
    return response;
  }
}