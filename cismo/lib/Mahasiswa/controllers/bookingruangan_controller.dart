import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cismo/api_response.dart';
import 'package:cismo/Mahasiswa/models/bookingruangan.dart';
import 'package:cismo/global.dart';
import 'package:cismo/Auth/Login/controllers/login_controller.dart';

Future<ApiResponse> createRuanganBooking(
    String ruangan, DateTime start_time, DateTime end_time) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(
      Uri.parse(baseURL + 'bookingruangan'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'ruangan': ruangan,
        'start_time': start_time.toIso8601String(),
        'end_time': end_time.toIso8601String(),
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponse.error = unauthrorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = 'server error';
  }
  return apiResponse;
}

Future<ApiResponse> getRuanganBooking() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(baseURL + 'bookingruangan'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = (jsonDecode(response.body)['RuanganBooking'] as List)
            .map((p) => RuanganBooking.fromJson(p))
            .toList();
        break;
      case 401:
        apiResponse.error = unauthrorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        print("Server Response: ${response.body}");
        break;
    }
  } catch (e) {
    apiResponse.error = 'server error';
  }
  return apiResponse;
}

Future<ApiResponse> updateRuanganBooking(
    int id,String ruangan, DateTime start_time, DateTime end_time) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(
      Uri.parse(baseURL + 'bookingruangan/$id'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'ruangan': ruangan,
        'start_time': start_time.toIso8601String(),
        'end_time': end_time.toIso8601String(),
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthrorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = 'server error';
  }
  return apiResponse;
}

Future<ApiResponse> cancelBooking(int id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.delete(
      Uri.parse(baseURL + 'bookingruangan/$id'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthrorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = 'server error';
  }
  return apiResponse;
}

// Anda juga dapat menambahkan fungsi-fungsi lainnya seperti getRuanganBookingById, atau fungsi khusus lainnya sesuai kebutuhan aplikasi Anda.


// Fungsi-fungsi lainnya untuk update, delete, atau operasi lainnya dengan controller ruangan booking.
