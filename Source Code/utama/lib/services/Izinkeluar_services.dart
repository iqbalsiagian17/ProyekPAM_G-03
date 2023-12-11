import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utama/Services/globals.dart';

class IzinkeluarServices {
  static Future<http.Response> requestIzinKeluar(
      String reason, String timeOut, String timeIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      Map<String, String> data = {
        "reason": reason,
        "time_out": timeOut,
        "time_in": timeIn,
      };

      var body = json.encode(data);
      var url = Uri.parse(baseURL + 'izin-keluar/request');
      http.Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/`json`',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      print(response.body);
      return response;
    } else {
      print('Token is empty or not found');
      return http.Response('Unauthorized', 401);
    }
  }

  static Future<http.Response> approveIzinKeluar(int izinId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      var url = Uri.parse(baseURL + 'izin-keluar/$izinId/approve');
      http.Response response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print(response.body);
      return response;
    } else {
      print('Token is empty or not found');
      return http.Response('Unauthorized', 401);
    }
  }

static Future<List<dynamic>> getAllIzinKeluar() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  if (token != null && token.isNotEmpty) {
    var url = Uri.parse(baseURL + 'izin-keluar/all');
    try {
      http.Response response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> izinKeluarList = jsonDecode(response.body);
        return izinKeluarList;
      } else {
        print('Failed to fetch izin keluar list');
        return []; // Return empty list in case of failure
      }
    } catch (error) {
      print('Error fetching izin keluar list: $error');
      return []; // Return empty list in case of error
    }
  } else {
    print('Token is empty or not found');
    return []; // Return empty list if token is empty or not found
  }
}

}