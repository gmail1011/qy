import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/location_bean.dart';
import 'package:flutter_base/utils/log.dart';

/// 自动定位城市模型；好几处在用，但是不是全局状态；
class LocationModel with ChangeNotifier {
  static LocationModel _instance;
  factory LocationModel() {
    if (null == _instance) {
      _instance = LocationModel._();
    }
    return _instance;
  }
  LocationModel._();

  /// 业务数据
  LocationBean _locationBean;
  Completer<LocationBean> _requestComplete;

  /// 获取定位
  /// [forceRefresh] 强制刷新请求
  Future<LocationBean> getLocation([bool forceRefresh = false]) async {
    if (forceRefresh || null == _locationBean) {
      var location = await _getLocationInner();
      if (null != location) {
        _locationBean = location;
        notifyListeners();
      }
    }
    return _locationBean;
  }

  LocationBean get location => _locationBean;

  Future<LocationBean> _getLocationInner() async {
    if (null == _requestComplete) {
      _requestComplete = Completer();
      () async {
        LocationBean location;
        try {
          location = await netManager.client.autoLocation();
          _requestComplete.complete(location);
        } catch (e) {
          l.e("LocationModel", "_getLocationInner()...");
          _requestComplete.complete(location);
        } finally {
          _requestComplete = null;
        }
      }();
    }
    return _requestComplete.future;
  }
}
