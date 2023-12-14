import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:cismo/api_response.dart';
import 'package:cismo/global.dart';
import 'package:cismo/Mahasiswa/models/izinbermalam.dart';
import 'package:cismo/Auth/Login/controllers/login_controller.dart';

Future<ApiResponse> CreateIzinBermalam(
    String reason, DateTime start_date, DateTime end_date) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String formattedStartDate =
        DateFormat("yyyy-MM-dd HH:mm:ss").format(start_date);
    String formattedEndDate =
        DateFormat("yyyy-MM-dd HH:mm:ss").format(end_date);

    // Check if the request is made on Friday after 17:00 or on Saturday between 08:00 and 17:00
    if (!((start_date.weekday == 5 && start_date.hour >= 17) ||
        (start_date.weekday == 6 &&
            (start_date.hour >= 8 && start_date.hour < 17)) ||
        (end_date.weekday == 6 && end_date.hour < 17))) {
      apiResponse.error =
          'Izin bermalam hanya bisa direquest pada Jumat setelah pukul 17:00 dan Sabtu antara pukul 08:00 - 17:00.';
      return apiResponse;
    }

    String token = await getToken();
    final response =
        await http.post(Uri.parse(baseURL + 'izinbermalam'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'reason': reason,
      'start_date': formattedStartDate,
      'end_date': formattedEndDate,
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        // Print the server response for debugging
        print('Server Response: ${response.body}');
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponse.error = unauthrorized;
        break;
      default:
        print('Unexpected status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = 'server error';
    print("Error in CreateIzinBermalam: $e");
  }
  return apiResponse;
}

Future<ApiResponse> getIzinBermalam() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(baseURL + 'izinbermalam'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data =
            (jsonDecode(response.body)['RequestIzinBermalam'] as List)
                .map((p) => RequestIzinBermalam.fromJson(p))
                .toList();
        break;
      case 401:
        apiResponse.error = unauthrorized;
        break;
      default:
        print('Unexpected status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = 'server error';
    print("Error in getIzinBermalam: $e");
  }
  return apiResponse;
}

Future<ApiResponse> updateIzinBermalam(
    int id, String reason, DateTime start_date, DateTime end_date) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String formattedStartDate =
        DateFormat("yyyy-MM-dd HH:mm:ss").format(start_date);
    String formattedEndDate =
        DateFormat("yyyy-MM-dd HH:mm:ss").format(end_date);

    // Additional check for update request, similar to the create request
    if (!((start_date.weekday == 5 && start_date.hour >= 17) ||
        (start_date.weekday == 6 &&
            (start_date.hour >= 8 && start_date.hour < 17)) ||
        (end_date.weekday == 6 && end_date.hour < 17))) {
      apiResponse.error =
          'Izin bermalam hanya bisa direquest pada Jumat setelah pukul 17:00 dan Sabtu antara pukul 08:00 - 17:00.';
      return apiResponse;
    }

    String token = await getToken();
    final response = await http.put(
      Uri.parse(baseURL + 'izinbermalam/$id'), // Use PUT method here
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'reason': reason,
        'start_date': formattedStartDate,
        'end_date': formattedEndDate,
      },
    );

    // Handle response based on status code
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = 'Unauthorized';
        break;
      default:
        apiResponse.error = 'Something went wrong';
        break;
    }
  } catch (e) {
    apiResponse.error = 'Server error: $e';
  }
  return apiResponse;
}

Future<ApiResponse> DeleteIzinBermalam(int id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.delete(Uri.parse(baseURL + 'izinbermalam/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthrorized;
        break;
    }
  } catch (e) {}
  return apiResponse;
}
