import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class HelperContext {
  static void showMessage(BuildContext context, String msg) =>
      Toast.show(msg, context,duration: 3,gravity: Toast.CENTER);
}
