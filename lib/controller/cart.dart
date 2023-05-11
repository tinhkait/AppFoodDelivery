import 'dart:async';

import 'package:app_food_2023/appstyle/succes_messages/success_style.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../appstyle/error_messages/error_style.dart';
import '../model/cart_model.dart';

import '../model/dishes_model.dart';
import '../screens/home_screen.dart';
import '../widgets/popups.dart';

List<CartItem>? cartItems = [];
Timer? timer;
int totalQuantity = 0;
bool? isChecked = false, showRemoveAll = false;

User? user;
_getCurrentUser() async {
  await FirebaseAuth.instance.authStateChanges().listen((User? currentUser) {
    user = currentUser;
  });
}

String formatCurrency(double value) {
  final currentcy = new NumberFormat('#,##0', 'ID');
  String result =
      currentcy.format(double.parse(value.toStringAsFixed(0))) + " đ";
  return result;
}

Set<String> checkedItems = {};

void toggleChecked(String dishID) {
  if (checkedItems.contains(dishID)) {
    checkedItems.remove(dishID);
  } else {
    checkedItems.add(dishID);
  }
  print(checkedItems.length);
}

Future<bool> compareCart() async {
  print(checkedItems.length);
  final querySnapshot = await FirebaseFirestore.instance
      .collection('cart')
      .where('UserID', isEqualTo: user?.uid)
      .get();
  if (querySnapshot.docs.length == checkedItems.length &&
      querySnapshot.docs.isNotEmpty &&
      checkedItems.isNotEmpty) {
    return true;
  } else {
    return false;
  }
}

Future<bool> getCurrentCheckedItems() async {
  if (checkedItems.length > 0)
    return true;
  else
    return false;
}

Stream<QuerySnapshot<Map<String, dynamic>>> cartListStream() async* {
  await _getCurrentUser();
  yield* FirebaseFirestore.instance
      .collection('cart')
      .where('UserID', isEqualTo: user?.uid)
      .snapshots();
}

int checkSl(BuildContext context, int sl) {
  if (sl < 1 || sl > 100) {
    QuantityRange(context);
    if (sl < 1) return 1;
    if (sl > 100) return 100;
  }
  return sl;
}

void addToCart(BuildContext context, DishModel dish, int quantity) async {
  await _getCurrentUser();

  if (user == null) {
    cannotAddToCart();
    return;
  } else {
    final refCart = await FirebaseFirestore.instance.collection('cart');
    await refCart
        .where('DishID', isEqualTo: dish.id)
        .where('UserID', isEqualTo: user?.uid)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = querySnapshot.docs.first;
        int currentQuantity = doc.get('Quantity');
        int newQuantity = currentQuantity + quantity;
        double price = dish.Price!;
        double newTotal = price * newQuantity;

        doc.reference.update({
          'Quantity': newQuantity,
          'Total': newTotal,
        });
      } else {
        refCart.add({
          'DishID': dish.id,
          'UserID': user?.uid,
          'Quantity': quantity,
          'Total': dish.Price! * quantity,
        });
      }
    });
    addToCartSucceededPopup(context);
  }
}

Stream<double> cartTotalStream() async* {
  await _getCurrentUser();
  await for (QuerySnapshot cartSnapshot in FirebaseFirestore.instance
      .collection('cart')
      .where('UserID', isEqualTo: user!.uid)
      .snapshots()) {
    double totalCart = 0;
    cartSnapshot.docs.forEach((doc) {
      double total = (doc.data() as Map<String, dynamic>)['Total'];
      totalCart += total;
    });
    yield totalCart;
  }
}

// void showDeleteCart(){
//   if()
// }
void increaseQuantity(String? dishID) async {
  final refCart = await FirebaseFirestore.instance
      .collection('cart')
      .where('UserID', isEqualTo: user?.uid)
      .where('DishID', isEqualTo: dishID);
  final querySnapshot = await refCart.get();
  if (querySnapshot.docs.isNotEmpty) {
    final cartItemSnapshot = querySnapshot.docs.first;
    int oldQuantity = cartItemSnapshot.get('Quantity');
    double total = cartItemSnapshot.get('Total');

    int newQuantity = oldQuantity + 1;
    double dishPrice = total / oldQuantity;
    double newTotal = dishPrice * newQuantity;
    await cartItemSnapshot.reference.update({
      "Total": newTotal,
      "Quantity": newQuantity,
    });
  }
}

void decreaseQuantity(String? dishID) async {
  final refCart = await FirebaseFirestore.instance
      .collection('cart')
      .where('UserID', isEqualTo: user?.uid)
      .where('DishID', isEqualTo: dishID);
  final querySnapshot = await refCart.get();
  if (querySnapshot.docs.isNotEmpty) {
    final cartItemSnapshot = querySnapshot.docs.first;
    int oldQuantity = cartItemSnapshot.get('Quantity');
    double total = cartItemSnapshot.get('Total');

    int newQuantity = oldQuantity - 1;
    double dishPrice = total / oldQuantity;
    double newTotal = dishPrice * newQuantity;
    if (oldQuantity <= 1) {
      await cartItemSnapshot.reference.delete();
      await checkedItems.remove(dishID);
      removeFromCartSucceed();

      return;
    }

    await cartItemSnapshot.reference.update({
      "Total": newTotal,
      "Quantity": newQuantity,
    });
  }
}

bool checkQuantity(bool check) {
  if (check == true)
    return true;
  else
    return false;
}

removeFromCart(String dishID) async {
  final refCart = await FirebaseFirestore.instance.collection('cart');
  final cartItemSnapshot = await refCart
      .where('DishID', isEqualTo: dishID)
      .where('UserID', isEqualTo: user?.uid)
      .get();
  await checkedItems.remove(dishID);
  if (cartItemSnapshot.docs.isNotEmpty) {
    final docSnapshot = cartItemSnapshot.docs.first;
    await docSnapshot.reference.delete();

    removeFromCartSucceed();
  }
  await compareCart();
  await getCurrentCheckedItems();
}

void checkedAll() async {
  final refCart = FirebaseFirestore.instance.collection('cart');
  final cartSnapshot =
      await refCart.where('UserID', isEqualTo: user?.uid).get();
  if (isChecked == true) {
    for (final doc in cartSnapshot.docs) {
      checkedItems.add(doc.data()['DishID']);
    }
  } else {
    checkedItems.clear();
  }
  print(checkedItems.length);
}

void clearCart(BuildContext context) async {
  final refCart = FirebaseFirestore.instance.collection('cart');
  final cartSnapshot =
      await refCart.where('UserID', isEqualTo: user?.uid).get();

  for (final doc in cartSnapshot.docs) {
    await doc.reference.delete();
  }

  removeSucceed();
  checkedItems.clear();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => AppHomeScreen()),
  );
}

void removeChosenItems() async {
  final refCart = FirebaseFirestore.instance.collection('cart');
  final cartSnapshot = await refCart
      .where('UserID', isEqualTo: user?.uid)
      .where('DishID', whereIn: checkedItems.toList())
      .get();

  for (final doc in cartSnapshot.docs) {
    await doc.reference.delete();
  }

  removeSucceed();

  await compareCart();
}
