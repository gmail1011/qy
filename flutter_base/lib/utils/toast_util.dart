import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'text_util.dart';

/// 显示统一的toast 无context
Future<bool> showToast(
    {@required String msg,
    Toast toastLength = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.CENTER}) {
  if (TextUtil.isEmpty(msg)) return Future.value(false);
  return Fluttertoast.showToast(
      msg: msg, gravity: gravity, toastLength: toastLength);
}
