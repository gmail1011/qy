/*
 * @Author: your name
 * @Date: 2020-05-29 21:42:51
 * @LastEditTime: 2020-05-29 21:44:49
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter-client-yh/lib/utils/msg_count_model.dart
 */
import 'package:flutter/cupertino.dart';

/// 客服消息数量
class MsgCountModel with ChangeNotifier {
  int _dtCount = 0;
  int _msgCount = 0;

  void setCount(var countObj) {
    this._msgCount = countObj["msgCount"];
    this._dtCount = countObj["dtCount"];
    notifyListeners();
  }

  int get countNum => _dtCount + _msgCount;

  int get msgCountNum => _dtCount;
}
