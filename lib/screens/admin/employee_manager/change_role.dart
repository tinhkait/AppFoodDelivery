import 'package:app_food_2023/screens/admin/employee_manager/managent_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChangeRoleEmployees extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> doc;

  const ChangeRoleEmployees({Key? key, required this.doc}) : super(key: key);

  @override
  _ChangeRoleEmployeesState createState() => _ChangeRoleEmployeesState();
}

class _ChangeRoleEmployeesState extends State<ChangeRoleEmployees> {
  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.doc['Role'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Thay Đổi Vai Trò',
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
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/profile.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              '${widget.doc['Email']}',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Chức Vụ:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              items: [
                DropdownMenuItem(
                  child: Text('Admin'),
                  value: 'Admin',
                ),
                DropdownMenuItem(
                  child: Text('Delivery'),
                  value: 'Delivery',
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedRole = value;
                });
              },
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                child: Text('Lưu'),
                onPressed: () async {
                  try {
                    await FirebaseFirestore.instance
                        .collection('employee')
                        .doc(widget.doc.id)
                        .update({'Role': _selectedRole});
                    Navigator.pop(context);
                  } catch (e) {
                    print(e.toString());
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Lỗi'),
                          content: Text('Có lỗi xảy ra khi lưu thay đổi'),
                          actions: [
                            TextButton(
                              child: Text('Đóng'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
