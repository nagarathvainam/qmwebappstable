import 'package:flutter/material.dart';
import 'dart:ui';
class CustomAppBarCommon extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;
  final double height;

  CustomAppBarCommon({
    required this.child,
    this.height = kToolbarHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Container(
      width: double.infinity,
      child:  Text("kannan",style: TextStyle(color: Colors.white),),
    );
  }
}