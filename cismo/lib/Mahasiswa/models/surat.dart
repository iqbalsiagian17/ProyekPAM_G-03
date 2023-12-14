import 'package:cismo/Auth/Login/models/login.dart';


class RequestSurat {
  int? id;
  User? user;
  String? reason;
  DateTime? startDate;
  String? status;

  RequestSurat({
    this.id,
    this.user,
    this.reason,
    this.startDate,
    this.status,
  });

  factory RequestSurat.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return RequestSurat();
    }

    return RequestSurat(
      id: json['id'] as int?,
      reason: json['reason'] as String?,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      status: json['status'] as String?,
      user: json['user'] != null
          ? User(id: json['user']['id'], name: json['user']['name'])
          : null,
    );
  }
}