import 'dart:io';

import 'package:app_food_2023/controller/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/UserModel.dart';
import '../screens/admin/admin_screen.dart';
import '../widgets/transitions_animations.dart';

DateTime? dateTimeEmpolyee;
UserModel? loggedInEmployee;
String? firstname = '',
    lastname = '',
    email = '',
    selectedgender = '',
    phonenumber = '',
    address = '',
    selectedrole = '',
    imageUrl = "";
Future<UserModel?> convertEmployeeToUserModel() async {
  UserModel user = await getCurrentUser();
  loggedInEmployee = user;
  return loggedInEmployee;
  //Lấy tất cả dữ liệu của nhân viên
}

bindingInput() async {
  await convertEmployeeToUserModel();
  address = loggedInEmployee!.Address;
  firstname = loggedInEmployee!.FirstName;
  lastname = loggedInEmployee!.LastName;
  phonenumber = loggedInEmployee!.PhoneNumber;

  dateTimeEmpolyee = loggedInEmployee!.BirthDay;
  imageUrl = loggedInEmployee!.Avatar;
}

bool checkGender() {
  if (loggedInEmployee?.Gender == "Nam") {
    selectedgender = "Nam";
    return true;
  } else {
    selectedgender = "Nữ";
    return false;
  }
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

      imageUrl = value;
    });
  } else {
    return;
  }
}

bool validateInputOnAddNew() {
  return firstname != null &&
      firstname != "" &&
      lastname != null &&
      lastname != "" &&
      email != null &&
      email != "" &&
      selectedgender != null &&
      selectedgender != "" &&
      phonenumber != null &&
      phonenumber != "" &&
      address != null &&
      address != "" &&
      selectedrole != null &&
      selectedrole != "" &&
      dateTimeEmpolyee != null &&
      dateTimeEmpolyee.toString().isNotEmpty;
}

showEmployeeAvatar() {
  if (imageUrl == "") {
    if (loggedInEmployee?.Avatar.toString() == "" ||
        loggedInEmployee?.Avatar.toString() == "images/userAvatar/user.png" ||
        loggedInEmployee?.Avatar == null) {
      return CircleAvatar(
        radius: 140.0,
        backgroundImage: AssetImage("assets/images/profile.png"),
        backgroundColor: Colors.transparent,
      );
    } else {
      return CircleAvatar(
        radius: 140.0,
        backgroundImage: NetworkImage(loggedInEmployee?.Avatar.toString() ??
            "" "assets/images/profile.png"),
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

void UpdateEmployee(BuildContext context) async {
  loggedInEmployee!.Address = address ?? loggedInEmployee!.Address;
  loggedInEmployee!.FirstName = firstname ?? loggedInEmployee!.FirstName;
  loggedInEmployee!.LastName = lastname ?? loggedInEmployee!.LastName;
  loggedInEmployee!.PhoneNumber = phonenumber ?? loggedInEmployee!.PhoneNumber;
  loggedInEmployee!.Gender = selectedgender ?? loggedInEmployee!.Gender;
  loggedInEmployee!.BirthDay = dateTimeEmpolyee ?? loggedInEmployee!.BirthDay;
  loggedInEmployee!.Avatar = imageUrl ?? loggedInEmployee!.Address;

  final collection = FirebaseFirestore.instance.collection("users");
  await collection
      .doc(user?.uid)
      .update(loggedInEmployee!.toMap())
      .then((value) {
    refreshTransition(context, AdminScreen());
  }).catchError((error) {
    print("Thất bại vì lỗi $error");
  });
  await convertEmployeeToUserModel();
}
