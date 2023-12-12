import 'package:flutter/cupertino.dart';

final PlayCountModel playCountModel = PlayCountModel();

/// 剩余播放次数
class PlayCountModel with ChangeNotifier {
  ///剩余播放的次数
  int _canPlayCnt = 0;
  void setPlayCnt(int canPlayNum) {
    _canPlayCnt = canPlayNum;
    notifyListeners();
  }

  void decreasePlayCnt() {
    _canPlayCnt--;
    notifyListeners();
  }

  int get canPlayCnt => _canPlayCnt < 0 ? 0 : _canPlayCnt;
}
