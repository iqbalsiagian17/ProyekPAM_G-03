import 'dart:convert';
import 'package:cismo/Auth/Login/controllers/login_controller.dart';
import 'package:http/http.dart' as http;
import 'package:cismo/api_response.dart';
import 'package:cismo/Baak/models/bookingruanganBaak.dart'; // Sesuaikan dengan lokasi file model RuanganBooking.dart Anda
import 'package:cismo/global.dart';

class BookingRuanganBaakController {
  static Future<ApiResponse<String>> approveBookingRuangan(int izinId) async {
    ApiResponse<String> apiResponse = ApiResponse();

    try {
      String token = await getToken();

      final response = await http.put(
        Uri.parse(baseURL + 'booking-ruangan/$izinId/approve'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      switch (response.statusCode) {
        case 200:
          apiResponse.data = 'Permintaan Izin Booking Ruangan Telah Disetujui';
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
      print("Error in approveRuanganBooking: $e");
    }

    return apiResponse;
  }


 static Future<ApiResponse<String>> rejectBookingRuangan(int izinId) async {
    ApiResponse<String> apiResponse = ApiResponse();

    try {
      String token = await getToken();

      final response = await http.put(
        Uri.parse('${baseURL}booking-ruangan/$izinId/reject'),
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
      print("Error in rejectRequestSurat: $e");
    }

    return apiResponse;
  }


  static Future<ApiResponse<List<RuanganBooking>>> viewAllRequestsForBaak() async {
    ApiResponse<List<RuanganBooking>> apiResponse = ApiResponse();

    try {
      String token = await getToken();

      final response = await http.get(
        Uri.parse('${baseURL}booking-ruangan/all'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse != null && jsonResponse['RuanganBooking'] != null) {
          List<dynamic> bookingData = jsonResponse['RuanganBooking'];
          List<RuanganBooking> bookingDataList = bookingData
              .map((json) => RuanganBooking.fromJson(json))
              .toList();
          apiResponse.data = bookingDataList;
        } else {
          apiResponse.error = 'Empty response data or invalid format';
        }
      } else {
        apiResponse.error = 'Failed to fetch data: ${response.statusCode}';
      }
    } catch (e) {
      apiResponse.error = 'Server error: $e';
      print("Error in viewAllRequestsForBaak: $e");
    }

    return apiResponse;
  }
}
