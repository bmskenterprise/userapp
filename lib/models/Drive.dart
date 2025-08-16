// ignore: file_names
class Drive {
  String? title;
  int? price;
  int? commission;

  Drive({required this.title, required this.price, required this.commission});
  factory Drive.fromJson(Map<String, dynamic> json) {
    return Drive(
      title: json['title'],
      price: json['price'].toDouble(),
      commission: json['commission'].toDouble(),
    );
  }
}
