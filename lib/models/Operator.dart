// ignore: file_names
class Operator {
  String name;
  String icon;

  Operator({required this.name, required this.icon});
  factory Operator.fromJson(Map<String, dynamic> json) {
    return Operator(name: json['name'], icon: json['icon']);
  }
}
