class BajuData {
     int? id;
   String? harga;
   String? ukuran;

  BajuData({
    this.harga,
    this.id,
    this.ukuran,
  });

  factory BajuData.fromJson(Map<String, dynamic> json) {
    return BajuData(
      id: json['id'] , // Default value (0 in this case) if null
      harga: json['harga'] , // Default value (empty string) if null
      ukuran: json['ukuran'] , // Default value (empty string) if null
    );
  }
}


