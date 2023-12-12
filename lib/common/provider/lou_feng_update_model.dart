import 'package:flutter/material.dart';
import 'package:flutter_app/model/lou_feng_model.dart';

class LouFengUpdate with ChangeNotifier {
  LouFengModel _louFengModel = LouFengModel();
  void setCountdown(LouFengModel louFengModel) {
    _louFengModel = louFengModel;
    notifyListeners();
  }

  LouFengModel get louFengModel => _louFengModel;
}