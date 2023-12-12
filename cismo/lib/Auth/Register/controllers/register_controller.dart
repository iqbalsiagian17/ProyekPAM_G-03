import 'dart:convert';

import 'package:cismo/global.dart';
import 'package:http/http.dart' as http;
import 'package:cismo/api_response.dart';
import 'package:cismo/Auth/Register/models/register.dart';

Future<ApiResponse> register(String name, String nomor_ktp,
    String nomor_handphone, String nim, String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse(baseURL + 'register'), headers: {
      'Accept': 'application/json'
    }, body: {
      'name': name,
      'nomor_ktp': nomor_ktp,
      'nomor_handphone': nomor_handphone,
      'nim': nim,
      'email': email,
      'password': password
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = somethingWentWrong;
  }
  return apiResponse;
}