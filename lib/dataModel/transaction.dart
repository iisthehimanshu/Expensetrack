import 'dart:convert';

class Transaction {
  DateTime dateTime;  // DateTime object will now act as the identifier
  String name;
  int amount;
  String? description;
  bool deducted;

  Transaction({
    required this.dateTime,
    required this.name,
    required this.amount,
    required this.description,
    required this.deducted,
  });

  // Convert a Transaction object to a Map (for SQLite)
  Map<String, dynamic> toJsonMap() {
    return {
      'dateTime': dateTime.toIso8601String(),  // Use DateTime as the primary key
      'name': name,
      'amount': amount,
      'description': description,
      'deducted': deducted ? 1 : 0,  // Store booleans as 1 (true) or 0 (false)
    };
  }

  // Convert a Map to a Transaction object
  factory Transaction.fromJsonMap(Map<String, dynamic> map) {
    return Transaction(
      dateTime: DateTime.parse(map['dateTime']),  // DateTime will now be parsed directly
      name: map['name'],
      amount: map['amount'],
      description: map['description'],
      deducted: map['deducted'] == 1, // Convert 1 to true and 0 to false
    );
  }

  @override
  String toString() {
    return 'Transaction{name: $name, dateTime: $dateTime, amount: $amount, description: $description, deducted: $deducted}';
  }
}
