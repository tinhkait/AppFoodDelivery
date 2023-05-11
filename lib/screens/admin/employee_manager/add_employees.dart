import 'package:app_food_2023/appstyle/screensize_aspectratio/mediaquery.dart';
import 'package:app_food_2023/controller/add_employee.dart';

import 'package:app_food_2023/widgets/employee_manament/datetime_picker.dart';
import 'package:app_food_2023/widgets/employee_manament/employee_widgets.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../../../widgets/appbar.dart';
import '../../../widgets/employee_manament/gender_chose.dart';
import '../../../widgets/select_image/image_select.dart';

class AddEmployees extends StatefulWidget {
  @override
  AddEmployeesScreenState createState() => AddEmployeesScreenState();
}

class AddEmployeesScreenState extends State<AddEmployees>
    with SingleTickerProviderStateMixin {
  User currentUser = FirebaseAuth.instance.currentUser!;
  // final FocusNode myFocusNode = FocusNode();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _phonenumberController;
  late TextEditingController _addressController;

  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passFocusNode = FocusNode();
  final _phoneNumberFocusNode = FocusNode();

  User? employee;
  String? imageUrl = "";
  // String phoneNumber = '';
  // String email = '';

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _phonenumberController = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phonenumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // Future<void> _postEmployee(String employeeID) async {
  //   final storage = FirebaseStorage.instance;
  //   final ref = storage.ref().child('userAvatar/$employeeID.jpg');
  //   final metadata = SettableMetadata(
  //     contentType: 'image/jpeg',
  //   );

  //   setState(() {
  //     _uploading = true;
  //   });

  //   await ref.putFile(_imageFile!, metadata);
  //   final url = await ref.getDownloadURL();

  //   setState(() {
  //     _uploading = false;
  //   });
  //   print(employeeID);
  //   await FirebaseFirestore.instance
  //       .collection('employee')
  //       .doc(employeeID)
  //       .update({
  //     'Avatar': url,
  //   });
  //   Navigator.pushAndRemoveUntil<dynamic>(
  //     context,
  //     MaterialPageRoute<dynamic>(
  //       builder: (BuildContext context) => ManagementEmployees(),
  //     ),
  //     (route) => false,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Thêm nhân viên',
          showLeading: true,
        ),
        body: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: MediaHeight(context, 5),
                    child: ImagePickerWidget(
                      onImageSelected: ((chosenImage) {
                        setState(() {
                          image = chosenImage;
                        });
                      }),
                    ),
                  ),
                  Container(
                    color: Color(0xffFFFFFF),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          MyTitleTextFieldWidget(
                            title: 'Ngày tháng năm sinh',
                          ),
                          BirthdayDatePickerWidget(
                            initialDate: birthDay,
                            onChanged: (value) {
                              setState(() {
                                birthDay = value;
                              });
                            },
                          ),
                          MyTitleTextFieldWidget(
                            title: 'Họ và tên',
                          ),
                          TextInputWidget(
                            hintText: 'Nhập họ và tên',
                            controller: _lastNameController,
                            onChanged: (value) {
                              new_lastname = value;
                            },
                            focusNode: _lastNameFocusNode,
                            nextFocusNode: _firstNameFocusNode,
                          ),
                          MyTitleTextFieldWidget(
                            title: 'Tên',
                          ),
                          TextInputWidget(
                            hintText: "Nhập tên",
                            controller: _firstNameController,
                            onChanged: (value) {
                              new_firstname = value;
                            },
                            focusNode: _firstNameFocusNode,
                            nextFocusNode: _emailFocusNode,
                          ),
                          MyTitleTextFieldWidget(
                            title: 'Email',
                          ),
                          TextInputWidget(
                            hintText: "Nhập email",
                            controller: _emailController,
                            onChanged: (value) {
                              new_email = value;
                            },
                            focusNode: _emailFocusNode,
                            nextFocusNode: _passFocusNode,
                          ),
                          MyTitleTextFieldWidget(
                            title: 'Mật khẩu mới',
                          ),
                          TextInputWidget(
                            hintText: "Nhập mật khẩu",
                            controller: _passwordController,
                            onChanged: (value) {
                              new_password = value;
                            },
                            focusNode: _passFocusNode,
                            nextFocusNode: _phoneNumberFocusNode,
                          ),
                          MyTitleTextFieldWidget(
                            title: 'Giới tính',
                          ),
                          GenderSelectionWidget(
                            gender: new_selectedgender,
                            size: 1.5,
                            onChanged: (value) {
                              setState(() {
                                new_selectedgender = value;
                              });
                            },
                          ),
                          MyTitleTextFieldWidget(
                            title: 'Số điện thoại',
                          ),
                          TextInputWidget(
                            hintText: "Nhập số điện thoại",
                            controller: _phonenumberController,
                            onChanged: (value) {
                              new_phonenumber = value;
                            },
                            focusNode: _phoneNumberFocusNode,
                            nextFocusNode: _addressFocusNode,
                          ),
                          MyTitleTextFieldWidget(
                            title: 'Địa chỉ',
                          ),
                          TextInputWidget(
                            hintText: 'Nhập địa chỉ',
                            controller: _addressController,
                            onChanged: (value) {
                              new_address = value;
                            },
                            focusNode: _addressFocusNode,
                            nextFocusNode: null,
                          ),
                          MyTitleTextFieldWidget(
                            title: 'Chức vụ',
                          ),
                          MyRoleDropdownWidget(
                            onRoleSelected: (selectedRole) {
                              setState(() {
                                new_selectedrole = selectedRole;
                              });
                              print(new_selectedrole);
                            },
                          ),
                          SaveCancelButtonsWidget(
                            onSavePressed: () async {
                              await addNewEmployee();
                            },
                            onCancelPressed: () {
                              // Handle cancel button press
                            },
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

  // if (_imageFile == null) {
  //   return;
  // }
  // if (dateTimeEmpolyee == null) {
  //   nullBirthDay();
  //   return;
  // }
  // FirebaseApp secondaryApp =
  //     await Firebase.initializeApp(
  //   name: 'SecondaryApp',
  //   options: Firebase.app().options,
  // );
  // // setState(() {
  // //   FocusScope.of(context)
  // //       .requestFocus(new FocusNode());
  // // });
  // setState(() {
  //   _uploading = true;
  // });
  // UserCredential userCredential =
  //     await FirebaseAuth.instanceFor(
  //             app: secondaryApp)
  //         .createUserWithEmailAndPassword(
  //             email:
  //                 _emailController.text,
  //             password:
  //                 _passwordController
  //                     .text);

  // setState(() {
  //   employee = userCredential.user;
  // });
  // FirebaseFirestore firebaseFirestore =
  //     FirebaseFirestore.instance;
  // UserModel userModel = UserModel();

  // userModel.Email = employee?.email;
  // userModel.LastName =
  //     _lastNameController.text;
  // userModel.FirstName =
  //     _firstNameController.text;
  // userModel.Avatar = "";
  // userModel.Gender = selectedGender;
  // userModel.Address =
  //     _addressController.text;
  // userModel.Role = _selectedRole;
  // userModel.BirthDay = dateTimeEmpolyee;
  // userModel.PhoneNumber =
  //     _phonenumberController.text;

  // firebaseFirestore
  //     .collection("users")
  //     .doc(employee?.uid)
  //     .set(userModel.toMap());
  // _postEmployee(employee!.uid);
  // await secondaryApp.delete();

  bool isValidPhoneNumber(String phoneNumber) {
    final RegExp regex = RegExp(r'^\+?[0-9]{10,}$');
    return regex.hasMatch(phoneNumber);
  }

  bool isValidEmail(String email) {
    final RegExp regex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return regex.hasMatch(email);
  }
}
