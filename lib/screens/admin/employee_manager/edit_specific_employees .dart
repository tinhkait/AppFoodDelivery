import 'dart:io';

import 'package:app_food_2023/model/UserModel.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'managent_screen.dart';

class EditSpecificEmployees extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> doc;
  const EditSpecificEmployees({Key? key, required this.doc}) : super(key: key);
  @override
  EditSpecificEmployeesState createState() => EditSpecificEmployeesState();
}

class EditSpecificEmployeesState extends State<EditSpecificEmployees>
    with SingleTickerProviderStateMixin {
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;
  UserModel? loggedInUser;

  String? imageUrl = "";
  String? selectedGender = "";
  DateTime? dateTime, currentBirthDay;

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("employee")
        .doc(user?.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {
        dateTime = loggedInUser?.BirthDay;
      });
    });
  }

  void pickUploadImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );
    Reference ref =
        FirebaseStorage.instance.ref().child('employeeAvatar/${user!.uid}.jpg');
    if (image != null) {
      await ref.putFile(File(image.path));
      ref.getDownloadURL().then((value) {
        print(value);
        setState(() {
          imageUrl = value;
        });
      });
    } else {
      return;
    }
  }

  String phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    _lastNameController.text = widget.doc['FirstName'] ?? "";
    _lastNameController.text = widget.doc['LastName'] ?? "";
    _phoneController.text = widget.doc['PhoneNumber'] ?? "";
    _addressController.text = widget.doc['Address'] ?? "";

    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Thông tin tài khoản',
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManagementEmployees(),
                ),
              );
            },
          ),
        ),
        body: new Container(
          color: Colors.white,
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Container(
                    height: 250.0,
                    color: Colors.white,
                    child: new Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child:
                              new Stack(fit: StackFit.loose, children: <Widget>[
                            new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Container(
                                  width: 140.0,
                                  height: 140.0,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(70)),
                                    color: Colors.red,
                                  ),
                                  child: Center(
                                    child: showUserAvatar(),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.only(top: 90.0, right: 100.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        pickUploadImage();
                                      },
                                      child: CircleAvatar(
                                        backgroundColor:
                                            Color.fromARGB(255, 19, 123, 38),
                                        radius: 25.0,
                                        child: new Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ]),
                        )
                      ],
                    ),
                  ),
                  new Container(
                    color: Color(0xffFFFFFF),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Thông Tin Tài Khoản',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Ngày tháng năm sinh',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: Center(
                              child: SizedBox(
                                width: 250,
                                height: 40,
                                child: ElevatedButton(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(Icons.calendar_today),
                                      Text(
                                        "${dateTime?.day ?? "Ngày"}/${dateTime?.month ?? "Tháng"}/${dateTime?.year ?? "Năm"}",
                                        style: TextStyle(
                                          color: Colors.yellow[400],
                                          fontSize: 23.0,
                                        ),
                                      )
                                    ],
                                  ),
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.zero),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.green),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final date = await pickDate();
                                    if (date == null) return;
                                    setState(() {
                                      dateTime = date;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Họ và tên đệm',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      controller: _lastNameController,
                                      decoration: const InputDecoration(
                                        hintText: "Nhập họ và tên đệm",
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Tên',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      controller: _firstNameController,
                                      decoration: const InputDecoration(
                                        hintText: "Nhập tên",
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Số Điện Thoại',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Flexible(
                                  child: TextField(
                                    controller: _phoneController,
                                    decoration: InputDecoration(
                                      hintText: "Nhập số điện thoại",
                                    ),
                                    keyboardType: TextInputType.phone,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Địa Chỉ',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      controller: _addressController,
                                      decoration: const InputDecoration(
                                          hintText: "Nhập địa chỉ"),
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 45.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: Container(
                                      child: ElevatedButton(
                                        child: Text("Save"),
                                        onPressed: () {
                                          if (loggedInUser != null) {
                                            loggedInUser = null;
                                          }
                                          final collection = FirebaseFirestore
                                              .instance
                                              .collection("employee");
                                          collection.doc(user?.uid).update({
                                            "FirstName":
                                                _firstNameController.text,
                                            "LastName":
                                                _lastNameController.text,
                                            "BirthDay": dateTime,
                                            "PhoneNumber":
                                                _phoneController.text,
                                            "Address": _addressController.text,
                                            "Avatar": imageUrl,
                                          }).then((value) {
                                            phoneNumber = "";

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ManagementEmployees()));

                                            FirebaseFirestore.instance
                                                .collection("employee")
                                                .doc(user?.uid)
                                                .get()
                                                .then((value) {
                                              this.loggedInUser =
                                                  UserModel.fromMap(
                                                      value.data());
                                              setState(() {});
                                            });
                                          }).catchError((error) {
                                            print("Thất bại vì lỗi $error");
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor:
                                              Color.fromARGB(255, 14, 215, 24),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  flex: 2,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Container(
                                      child: ElevatedButton(
                                        child: Text("Cancel"),
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  flex: 2,
                                ),
                              ],
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
    // Clean up the controller when the Widget is disposed
    super.dispose();
  }

  // bool isValidPhoneNumber(String phoneNumber) {
  //   final RegExp regex = RegExp(r'^\+?[0-9]{10,}$');
  //   return regex.hasMatch(phoneNumber);
  // }

  // bool isValidEmail(String email) {
  //   final RegExp regex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
  //   return regex.hasMatch(email);
  // }

  showUserAvatar() {
    if (imageUrl == "") {
      if (loggedInUser?.Avatar.toString() == "" ||
          loggedInUser?.Avatar.toString() == "images/userAvatar/user.png" ||
          loggedInUser?.Avatar == null) {
        return CircleAvatar(
          radius: 140.0,
          backgroundImage: AssetImage("assets/images/profile.png"),
          backgroundColor: Colors.transparent,
        );
      } else {
        return CircleAvatar(
          radius: 140.0,
          backgroundImage: NetworkImage(widget.doc['Avatar']),
          backgroundColor: Colors.transparent,
        );
      }
    } else {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        imageBuilder: (context, imageProvider) => Container(
          width: 140.0,
          height: 140.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    }
  }

  showUserBirthDay() {
    if (loggedInUser?.BirthDay != "null" || loggedInUser?.BirthDay != null) {
      currentBirthDay = loggedInUser?.BirthDay;
      String? day = dateTime?.day.toString() ?? "Ngày";
      String? month = dateTime?.month.toString() ?? "Tháng";
      String? year = dateTime?.year.toString() ?? "Năm";
      return "$day/$month/$year";
    } else {
      currentBirthDay = DateTime.now();
      String? day = dateTime?.day.toString() ?? "Ngày";
      String? month = dateTime?.month.toString() ?? "Tháng";
      String? year = dateTime?.year.toString() ?? "Năm";
      return "$day/$month/$year";
    }
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: dateTime ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));
}
