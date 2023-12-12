import 'package:flutter/material.dart';
import 'package:flutter_app/model/novel_model.dart';

class FictionUpdate with ChangeNotifier {
  NovelModel _novelModel = NovelModel();
  void setCountdown(NovelModel novelModel) {
    _novelModel = novelModel;
    notifyListeners();
  }

  NovelModel get novelModel => _novelModel;
}