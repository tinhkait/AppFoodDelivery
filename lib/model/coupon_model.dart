import 'package:cloud_firestore/cloud_firestore.dart';

class Coupon {
  String id;
  String code;
  String description;
  dynamic amount;
  bool isPercent;
  DateTime expirationDate;

  Coupon({
    required this.id,
    required this.code,
    required this.description,
    required this.amount,
    required this.isPercent,
    required this.expirationDate,
  });

  factory Coupon.fromMap(Map<String, dynamic> map) {
    return Coupon(
      id: map['id'],
      code: map['code'],
      description: map['description'],
      amount: map['amount'],
      isPercent: map['isPercent'],
      expirationDate: DateTime.fromMillisecondsSinceEpoch(
        map['expirationDate'].millisecondsSinceEpoch,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'description': description,
      'amount': amount,
      'isPercent': isPercent,
      'expirationDate': Timestamp.fromDate(expirationDate),
    };
  }
}
