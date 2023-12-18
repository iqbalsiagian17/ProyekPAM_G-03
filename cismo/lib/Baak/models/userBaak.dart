class MahasiswaData {
  final String? name;
  final int? id;
  final String? nim;
  final String? email;

  MahasiswaData({
    required this.name,
    required this.id,
    required this.nim,
    required this.email,
  });

  factory MahasiswaData.fromJson(Map<String, dynamic> json) {
    return MahasiswaData(
      id: json['id'],
      name: json['name'], // Assuming 'name' is the field in JSON representing the student's name
      nim: json['nim'],
      email: json['email'],
    );
  }
}
