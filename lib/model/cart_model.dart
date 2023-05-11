import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  String? dishID;
  String? userId;
  int quantity;
  double total;
  bool isChecked;
  CartItem({
    this.isChecked = false,
    this.dishID,
    this.userId,
    this.quantity = 1,
    this.total = 0.0,
  });

  factory CartItem.fromSnapshotCart(QueryDocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return CartItem(
      dishID: data['DishID'],
      userId: data['UserId'],
      quantity: data['Quantity'] ?? 1,
      total: data['Total']?.toDouble() ?? 0.0,
      isChecked: false,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'dish': dishID,
      'isChecked': isChecked,
      'userId': userId,
      'quantity': quantity,
      'total': total,
    };
  }
}
