class Data {
  final int? id;
  final String date;
  final String time;
  final String message;
  final double? amount;    // nullable double
  final double? balance;   // nullable double
  final String consumer;
  final String callname;
  final String category;
  final String upiid;
  final String transactionType;
  final String bank;

  Data( {
    this.id,
    required this.date,
    required this.time,
    required this.message,
    this.amount,
    this.balance,
    required this.consumer,
    required this.category,
    required this.upiid,
    required this.transactionType,
    required this.bank,
    required this.callname,
  });

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      id :map['id'] ?? 0,
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      message: map['message'] ?? '',
      amount: (map['amount'] is num) ? (map['amount'] as num).toDouble() : null,
      balance: (map['balance'] is num) ? (map['balance'] as num).toDouble() : null,
      consumer: map['consumer'] ?? '',
      callname: map['callname'] ?? '',
      category: map['category'] ?? '',
      upiid: map['upiid'] ?? '',
      transactionType: map['transaction_type'] ?? '',
      bank: map['bank'] ?? '',
    );
  }
}
