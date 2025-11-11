import 'package:flutter/material.dart';
import 'package:tusk_app/common/app_color.dart';

class AppInfo {
  static success(BuildContext context, String msg) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: AppColor.approved,
    ));
  }

  static failed(BuildContext context, String msg) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: AppColor.rejected,
    ));
  }
}
