class RuanganBooking {
  final int id;
  final String status;
  final String ruangan;
  final DateTime startTime; // Ubah tipe data ke DateTime
  final DateTime endTime; // Ubah tipe data ke DateTime
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
      startTime: DateTime.parse(json['start_time']), // Ubah ke DateTime
      endTime: DateTime.parse(json['end_time']), // Ubah ke DateTime
      userId: json['user_id'],
    );
  }
}