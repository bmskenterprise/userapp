
class Pack {
  final String id;
  final String amount;
  final String date;
  final String recipient;
  final String opt;
  final String status;

  Pack({
    required this.id,
    required this.amount,
    required this.date,
    required this.recipient,
    required this.opt,
    required this.status,
  });

  factory Pack.fromJson(Map<String, dynamic> json) {
    return Pack(
      id: json['id'],
      recipient: json['recipient'],
      amount: json['amount'],
      date: json['date'],
      opt: json['opt'],
      status: json['status'],
    );
  }
}