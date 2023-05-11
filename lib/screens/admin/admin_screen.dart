import 'package:app_food_2023/controller/edit_employee.dart';
import 'package:app_food_2023/screens/admin/category_manager/category_screen.dart';
import 'package:app_food_2023/screens/admin/employee_manager/edit_current_employees.dart';
import 'package:app_food_2023/screens/admin/employee_manager/managent_screen.dart';

import 'package:app_food_2023/screens/loading_screen/logout_loading.dart';
import 'package:app_food_2023/widgets/appbar.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/user.dart';

import 'coupon_manager/coupons_screen.dart';
import 'employee_manager/change_password_employees.dart';
import 'food_manager/food_list.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  void initState() {
    super.initState();
    convertEmployeeToUserModel();
  }

  bool checkImage() {
    if (loggedInEmployee?.Avatar == null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showLeading: true,
        title: "Quản lý",
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 20),
            Container(
              width: 100.0,
              height: 100.0,
              child: checkImage()
                  ? CircularProgressIndicator()
                  : CircleAvatar(
                      radius: 100,
                      backgroundImage:
                          NetworkImage(loggedInEmployee!.Avatar.toString())),
            ),
            SizedBox(height: 20.0),
            Text(
              '${loggedInEmployee?.LastName} ${loggedInEmployee?.FirstName}',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${loggedInEmployee?.Email}',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text(
                      'Tài khoản',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Cập nhật thông tin'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditEmployees(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.lock),
                    title: Text('Đổi mật khẩu'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePasswordEmployeesScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Quản lý',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.group),
                    title: Text('Quản lý nhân viên'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManagementEmployees(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.category),
                    title: Text('Quản lý danh mục'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoryListScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.shopping_cart),
                    title: Text('Quản lý món ăn'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FoodListScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.shopping_cart),
                    title: Text('Quản lý mã giảm giá'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CouponsListPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.delivery_dining),
                    title: Text('Delivery'),
                    onTap: () {
                      // Xử lý đi đạt
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.receipt_long),
                    title: Text('Quản lý đơn hàng'),
                    onTap: () {
                      // Xử lý đi đạt
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Đăng xuất'),
                    onTap: () {
                      logOut(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future logOut(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    preferences.reload();
    user = null;
    loggedInUser = loggedInEmployee = null;
    GoogleSignIn _googleSignIn = GoogleSignIn();
    _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
    await FirebaseAuth.instance.userChanges();
    Fluttertoast.showToast(
      msg: "Đăng xuất thành công!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => LogoutLoadingScreen(),
      ),
      (route) => false, //if you want to disable back feature set to false
    );
  }
}
