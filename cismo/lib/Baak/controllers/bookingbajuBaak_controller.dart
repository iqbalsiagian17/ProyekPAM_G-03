import 'dart:convert';
import 'package:cismo/Auth/Login/controllers/login_controller.dart';
import 'package:http/http.dart' as http;
import 'package:cismo/api_response.dart';
import 'package:cismo/Baak/models/bookingbajuBaak.dart'; // Sesuaikan dengan lokasi file model IzinKeluar.dart Anda
import 'package:cismo/global.dart';

class BookingBajuBaakController {


  static Future<ApiResponse<String>> approveBookingBaju(int izinId) async {
    ApiResponse<String> apiResponse = ApiResponse();

    try {
      String token = await getToken();

      final response = await http.put(
        Uri.parse(baseURL + 'booking-baju/$izinId/approve'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      switch (response.statusCode) {
        case 200:
          apiResponse.data = 'Permintaan Izin Keluar Telah Disetujui';
          break;
        case 401:
          apiResponse.error = 'Unauthorized';
          break;
        default:
          apiResponse.error = 'Something went wrong';
          print("Server Response: ${response.body}");
          break;
      }
    } catch (e) {
      apiResponse.error = 'Server error: $e';
      print("Error in approveIzinKeluar: $e");
    }

    return apiResponse;
  }


 static Future<ApiResponse<String>> rejectBookingBaju(int izinId) async {
    ApiResponse<String> apiResponse = ApiResponse();

    try {
      String token = await getToken();

      final response = await http.put(
        Uri.parse(baseURL + 'booking-baju/$izinId/reject'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      switch (response.statusCode) {
        case 200:
          apiResponse.data = 'Permintaan Izin Keluar Telah Ditolak';
          break;
        case 401:
          apiResponse.error = 'Unauthorized';
          break;
        default:
          apiResponse.error = 'Something went wrong';
          print("Server Response: ${response.body}");
          break;
      }
    } catch (e) {
      apiResponse.error = 'Server error: $e';
      print("Error in rejectIzinKeluar: $e");
    }

    return apiResponse;
  }


  static Future<ApiResponse<List<BookingBaju>>> viewAllRequestsForBaak() async {
    ApiResponse<List<BookingBaju>> apiResponse = ApiResponse();

    try {
    String token = await getToken();

      final response = await http.get(
        Uri.parse(baseURL + 'booking-baju/all'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      switch (response.statusCode) {
        case 200:
          Iterable data = json.decode(response.body)['BookingBaju'];
          List<BookingBaju> bookingBajuList = data
              .map((json) => BookingBaju.fromJson(json))
              .toList();
          apiResponse.data = bookingBajuList;
          break;
        case 401:
          apiResponse.error = 'Unauthorized';
          break;
        default:
          apiResponse.error = 'Something went wrong';
          print("Server Response: ${response.body}");
          break;
      }
    } catch (e) {
      apiResponse.error = 'Server error: $e';
      print("Error in viewAllRequestsForBaak: $e");
    }

    return apiResponse;
  }

  

  
}
