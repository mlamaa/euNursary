import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Colors.dart';

Widget myAppBar() {
  return AppBar(
    centerTitle: true,
    title: Text(
              "Nursery",
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w900),
            ),

    backgroundColor: MyColors.color1,
    elevation: 0.0,
  );
}
