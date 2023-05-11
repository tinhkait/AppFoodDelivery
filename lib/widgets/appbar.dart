import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLeading;

  CustomAppBar({this.title, this.showLeading = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: showLeading
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      title: Text(
        title ?? "",
        style: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
