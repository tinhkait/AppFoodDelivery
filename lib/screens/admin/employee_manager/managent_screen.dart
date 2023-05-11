import 'package:app_food_2023/screens/admin/employee_manager/edit_specific_employees%20.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'add_employees.dart';

import 'change_role.dart';

class ManagementEmployees extends StatefulWidget {
  @override
  _ManagementEmployeesState createState() => _ManagementEmployeesState();
}

class _ManagementEmployeesState extends State<ManagementEmployees> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Danh Sách Nhân Viên',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('Role', isNotEqualTo: 'Customer')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: Image.network(
                    doc['Avatar'],
                  ).image,
                ),
                title: Text(doc['Role']),
                subtitle: Text(
                  doc['Email'],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditSpecificEmployees(doc: doc),
                          ),
                        );
                      },
                    ),
                    // IconButton(
                    //   icon: Icon(Icons.password),
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) =>
                    //             ChangeSpecificPasswordEmployeesScreen(doc: doc),
                    //       ),
                    //     );
                    //   },
                    // ),
                    IconButton(
                      icon: Icon(Icons.perm_identity),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeRoleEmployees(doc: doc),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEmployees(),
            ),
          );
        },
      ),
    );
  }
}
