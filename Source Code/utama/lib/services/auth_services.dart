import 'dart:convert';

import 'package:utama/Services/globals.dart';
import 'package:http/http.dart' as http;

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
    print(response.body);
    return response;
  }
}
