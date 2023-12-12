import 'package:flutter/material.dart';

// 二级播放列表是否显示UI
class SecondPlayerShowModel with ChangeNotifier {
  bool _show = true;

  void setShow(bool show) {
    if (show == _show) return;
    this._show = show;
    notifyListeners();
  }

  bool get isShow => _show;
}
