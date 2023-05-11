import 'package:app_food_2023/appstyle/error_messages/error_style.dart';
import 'package:app_food_2023/appstyle/succes_messages/success_style.dart';
import 'package:app_food_2023/controller/user.dart';
import 'package:app_food_2023/widgets/appbar.dart';
import 'package:app_food_2023/widgets/employee_manament/employee_widgets.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controller/changepassword_employee.dart';
import '../../../widgets/employee_manament/change_password.dart';
import '../admin_screen.dart';

class ChangePasswordEmployeesScreen extends StatefulWidget {
  @override
  ChangePasswordEmployeesScreenState createState() =>
      ChangePasswordEmployeesScreenState();
}

class ChangePasswordEmployeesScreenState
    extends State<ChangePasswordEmployeesScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController emailController = new TextEditingController();
  TextEditingController oldPassController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  TextEditingController reenterPassController = new TextEditingController();
  @override
  void initState() {
    super.initState();

    convertToUserModel();
  }

  @override
  Widget build(BuildContext context) {
    emailController.text = loggedInUser?.Email.toString() ?? "";
    return Scaffold(
        appBar: CustomAppBar(
          showLeading: true,
          title: 'Đổi mật khẩu',
        ),
        body: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              AvatarContainer(
                  isLoading: checkImage(),
                  avatarUrl: loggedInUser?.Avatar.toString()),
              Column(
                children: <Widget>[
                  Container(
                    color: Color(0xffFFFFFF),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          MyTitleTextFieldWidget(title: "Email"),
                          TextInputWidget(
                              hintText: 'Nhập Email',
                              controller: emailController),
                          Visibility(
                            visible: !checkUserAuthencation(),
                            child: Column(
                              children: [
                                MyTitleTextFieldWidget(title: 'Mật khẩu cũ'),
                                PasswordTextField(
                                  controller: oldPassController,
                                  onChanged: (value) {
                                    setState(() {
                                      oldPass = value;
                                    });
                                  },
                                  hintText: 'Nhập mật khẩu cũ',
                                  helperText: checkMatchPassword(),
                                ),
                                MyTitleTextFieldWidget(title: 'Mật khẩu mới'),
                                PasswordTextField(
                                  controller: passwordController,
                                  onChanged: (value) {
                                    setState(() {
                                      passInput = value;
                                    });
                                  },
                                  hintText: 'Nhập mật khẩu mới',
                                  helperText: checkMatchPassword(),
                                ),
                                MyTitleTextFieldWidget(
                                    title: 'Xác nhận mật khẩu mới'),
                                PasswordTextField(
                                  controller: reenterPassController,
                                  onChanged: (value) {
                                    setState(() {
                                      confirmPassInput = value;
                                    });
                                  },
                                  hintText: 'Nhập lại mật khẩu ',
                                  helperText: checkMatchPassword(),
                                ),
                                SaveCancelButtonsWidget(
                                    onSavePressed: () {},
                                    onCancelPressed: () {})
                              ],
                            ),
                          ),
                          Visibility(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: Icon(CupertinoIcons.envelope),
                              label: Text("Gửi mail xác nhận"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Future<bool> changePassword(String newPassword) async {
  //   try {
  //     AuthCredential credential = EmailAuthProvider.credential(
  //         email: emailController.text, password: newPassword);
  //     await user?.reauthenticateWithCredential(credential);
  //     await user?.updatePassword(newPassword);
  //     print("Password changed successfully!");
  //     return true;
  //   } catch (e) {
  //     print("Failed to change password: $e");
  //     return false;
  //   }
  // }
}
