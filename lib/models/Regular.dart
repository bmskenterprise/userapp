// ignore: file_names
class Regular {
  String? title;
  int? price;
  int? commission;
  Regular({this.title, this.price, this.commission});
  factory Regular.fromJson(Map<String, dynamic> json) {
    return Regular(
      title: json['title'],
      price: json['price'],
      commission: json['commission'],
    );
  }
  Map<String, dynamic> toJson() {
    return {'title': title, 'price': price, 'commission': commission};
  }
}
