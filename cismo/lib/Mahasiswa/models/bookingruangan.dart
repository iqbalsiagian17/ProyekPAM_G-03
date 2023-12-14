
class RuanganBooking {
  final int id;
  final String status;
  final String ruangan;
  final String startTime; 
  final String endTime; 
  final int userId;

  RuanganBooking({
    required this.id,
    required this.ruangan,
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.userId,
  });

  factory RuanganBooking.fromJson(Map<String, dynamic> json) {
    return RuanganBooking(
      id: json['id'],
      status: json['status'],
      ruangan: json['ruangan'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      userId: json['user_id'],
    );
  }
}
