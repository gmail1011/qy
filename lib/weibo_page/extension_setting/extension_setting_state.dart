import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ExtensionBean.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/video_model.dart';

class ExtensionSettingState implements Cloneable<ExtensionSettingState> {
  List<AdsInfoBean> adsList = [];
  VideoModel videoModel;

  List<SelectBean> selectBean = [];

  int selectedValue = 0;

  @override
  ExtensionSettingState clone() {
    return ExtensionSettingState()
      ..adsList = adsList
      ..videoModel = videoModel
      ..selectedValue = selectedValue
      ..selectBean = selectBean;
  }
}

ExtensionSettingState initState(Map<String, dynamic> args) {
  return ExtensionSettingState()..videoModel = args["videoModel"];
}
