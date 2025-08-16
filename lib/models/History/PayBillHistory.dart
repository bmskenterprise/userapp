
class PayBillHistory {
  final String status;
  final String ac;
  final String amount;
  final String date;
  final String recipient;
  final String type;

  PayBillHistory({required this.status,required this.ac,required this.amount,required this.date,required this.recipient,required this.type,});

  factory PayBillHistory.fromJson(Map<String, dynamic> json) {
    return PayBillHistory(
      status: json['status'],
      ac: json['ac'],
      amount: json['amount'],
      date: json['date'],
      recipient: json['recipient'],
      type: json['type'],
    );
  }
}