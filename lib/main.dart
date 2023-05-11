import 'package:app_food_2023/api/seach_place.dart';
import 'package:app_food_2023/controller/user.dart';
import 'package:app_food_2023/screens/cart_test.dart';
import 'package:app_food_2023/widgets/show_rating.dart';
import 'package:app_food_2023/screens/admin/admin_screen.dart';
import 'package:app_food_2023/screens/home_screen.dart';
import 'package:app_food_2023/screens/loading_screen/home_loading.dart';
import 'package:app_food_2023/screens/phone_screen.dart';

import 'package:app_food_2023/screens/verify_phone.dart';
import 'package:app_food_2023/widgets/rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:app_food_2023/screens/login_register/login_screen.dart';

import 'controller/edit_employee.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAuth.instance.userChanges();
  await FirebaseAuth.instance.authStateChanges();
  await getCurrentUser();
  await convertToUserModel();
  if (loggedInUser?.Role != 'Customer') {
    await convertEmployeeToUserModel();
  } else {
    await convertToUserModel();
  }

  // GoogleSignIn signIn = GoogleSignIn();
  // signIn.signOut();
  runApp(MaterialApp(
    initialRoute: 'welcome',
    debugShowCheckedModeBanner: false,
    routes: {
      'cart_test': (context) => CartTest(),
      'admin': (context) => AdminScreen(),
      'login': (context) => LoginScreen(),
      'home': (context) => AppHomeScreen(),
      'phone': (context) => MyPhone(),
      'verify': (context) => MyVerify(),
      'ratingTest': (context) => RatingTest(),
      'ratingBar': (context) => RatingBarScreen(),
      'welcome': (context) => LoadingHomeScreen(),
      'welcoame': (context) => AddressPage(),
    },
  ));
}
