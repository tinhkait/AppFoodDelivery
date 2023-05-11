import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/UserModel.dart';

File? image;
DateTime? birthDay;
String? new_firstname = '',
    new_lastname = '',
    new_email = '',
    new_password = '',
    new_selectedgender = '',
    new_phonenumber = '',
    new_address = '',
    new_selectedrole = '',
    new_imageUrl = "";
bool validateInputOnAddNew() {
  return new_firstname != null &&
      new_firstname != "" &&
      new_lastname != null &&
      new_lastname != "" &&
      new_email != null &&
      new_email != "" &&
      new_password != null &&
      new_password != "" &&
      new_selectedgender != null &&
      new_selectedgender != "" &&
      new_phonenumber != null &&
      new_phonenumber != "" &&
      new_address != null &&
      new_address != "" &&
      new_selectedrole != null &&
      new_selectedrole != "" &&
      birthDay != null &&
      birthDay.toString().isNotEmpty;
}

Future<void> uploadImageToFirebaseStorage(String? userID) async {
  if (image != null) {
    final fileName = 'user_${userID}.jpg';
    final Reference storageReference =
        FirebaseStorage.instance.ref().child('userAvatar/$fileName');
    final UploadTask uploadTask = storageReference.putFile(image!);
    final TaskSnapshot downloadUrl = (await uploadTask);
    final String url = await downloadUrl.ref.getDownloadURL();
    await FirebaseFirestore.instance.collection('users').doc(userID).update({
      'Avatar': url,
    });
  }
}

addNewEmployee() async {
  if (validateInputOnAddNew() == false) {
    return;
  }

  FirebaseApp secondaryApp = await Firebase.initializeApp(
    name: 'SecondaryApp',
    options: Firebase.app().options,
  );

  UserCredential userCredential =
      await FirebaseAuth.instanceFor(app: secondaryApp)
          .createUserWithEmailAndPassword(
              email: new_email!, password: new_password!);
  User? employee = userCredential.user;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  UserModel userModel = UserModel();

  userModel.Email = new_email;
  userModel.LastName = new_lastname;
  userModel.FirstName = new_firstname;
  userModel.Avatar = "";
  userModel.Gender = new_selectedgender;
  userModel.Address = new_address;
  userModel.Role = new_selectedrole;
  userModel.BirthDay = birthDay;
  userModel.PhoneNumber = new_phonenumber;

  firebaseFirestore
      .collection("users")
      .doc(employee?.uid)
      .set(userModel.toMap());
  await uploadImageToFirebaseStorage(employee!.uid);
  await secondaryApp.delete();
}
