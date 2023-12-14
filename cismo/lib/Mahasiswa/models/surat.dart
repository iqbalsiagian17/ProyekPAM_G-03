import 'package:cismo/Auth/Login/models/login.dart';


class RequestSurat {
  int? id;
  User? user;
  String? reason;
  DateTime? pickuptime;
  String? status;

  RequestSurat({
    this.id,
    this.user,
    this.reason,
    this.pickuptime,
    this.status,
  });

  factory RequestSurat.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return RequestSurat();
    }

    return RequestSurat(
      id: json['id'] as int?,
      reason: json['reason'] as String?,
      pickuptime: json['pickup_time'] != null
          ? DateTime.parse(json['pickup_time'])
          : null,
      status: json['status'] as String?,
      user: json['user'] != null
          ? User(id: json['user']['id'], name: json['user']['name'])
          : null,
    );
  }
}
