class TopupHistory {
  final String status;
  final String recipient;
  final String telecom;
  final String amount;
  final String date;

  TopupHistory({required this.status, required this.recipient, required this.telecom, required this.amount, required this.date,});

  factory TopupHistory.fromJson(Map<String, dynamic> json) {
    return TopupHistory(
      status: json['status'],
      recipient: json['number'],
      telecom: json['telecom'],
      amount: json['amount'],
      date: json['date'],
    );
  }
}
