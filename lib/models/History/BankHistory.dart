
class BankHistory {
  final String status;
  final String ac;
  final String recipient;
  final int amount;
  final String date;

  BankHistory({required this.status,required this.ac,required this.recipient,required this.amount,required this.date,});

  factory BankHistory.fromJson(Map<String, dynamic> json) {
    return BankHistory(
      status: json['status'],
      ac: json['ac'],
      recipient: json['recipient'],
      amount: json['amount'],
      date: json['date'],
    );
  }
}