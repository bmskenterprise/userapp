class DepositHistory {
  final String status;
  final String trxID;
  final String paymentMethod;
  final String balanceType;
  final String amount;
  final String date;

  DepositHistory({required this.status,required this.trxID, required this.paymentMethod, required this.balanceType, required this.amount, required this.date});
  
  factory DepositHistory.fromJson(Map<String, dynamic> json) {
    return DepositHistory(
      status: json['status'],
      trxID: json['trx_id'],
      paymentMethod: json['paymentMethod'],
      balanceType: json['balance_type'],
      amount: json['amount'],
      date: json['date'],
    );
  }
}