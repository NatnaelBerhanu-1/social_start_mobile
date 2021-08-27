import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Transaction extends Equatable {
  final double amount;
  final String from;
  final String to;
  final String paymnentProvider;
  final String transactionId;
  Transaction({
    @required this.amount,
    @required this.from,
    @required this.to,
    @required this.paymnentProvider,
    @required this.transactionId,
  });

  

  @override
  List<Object> get props {
    return [
      amount,
      from,
      to,
      paymnentProvider,
      transactionId,
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'from': from,
      'to': to,
      'paymnentProvider': paymnentProvider,
      'transactionId': transactionId,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      amount: map['amount'],
      from: map['from'],
      to: map['to'],
      paymnentProvider: map['paymnentProvider'],
      transactionId: map['transactionId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Transaction.fromJson(String source) => Transaction.fromMap(json.decode(source));
}
