import 'dart:convert';
import 'package:cismo/Auth/Login/controllers/login_controller.dart';
import 'package:http/http.dart' as http;
import 'package:cismo/api_response.dart';
import 'package:cismo/Baak/models/requestsuratBaak.dart'; 
import 'package:cismo/global.dart';

class RequestSuratBaakController {
  static Future<ApiResponse<String>> approveRequestSurat(int izinId) async {
    ApiResponse<String> apiResponse = ApiResponse();

    try {
      String token = await getToken();

      final response = await http.put(
        Uri.parse('${baseURL}request-surat/$izinId/approve'),
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
      print("Error in approveRequestSurat: $e");
    }

    return apiResponse;
  }

  static Future<ApiResponse<String>> rejectRequestSurat(int izinId) async {
    ApiResponse<String> apiResponse = ApiResponse();

    try {
      String token = await getToken();

      final response = await http.put(
        Uri.parse('${baseURL}request-surat/$izinId/reject'),
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

  static Future<ApiResponse<List<RequestSurat>>> viewAllRequestsForBaak() async {
    ApiResponse<List<RequestSurat>> apiResponse = ApiResponse();

    try {
      String token = await getToken();

      final response = await http.get(
        Uri.parse('${baseURL}request-surat/all'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse != null && jsonResponse['RequestSurat'] != null) {
          List<dynamic> requestData = jsonResponse['RequestSurat'];
          List<RequestSurat> requestSuratList = requestData
              .map((json) => RequestSurat.fromJson(json))
              .toList();
          apiResponse.data = requestSuratList;
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