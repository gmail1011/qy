import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/user/user_certification_entity.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';

class MyCertificationState implements Cloneable<MyCertificationState> {
  BaseRequestController requestController = BaseRequestController();
  UserCertificationData userCertification;

  @override
  MyCertificationState clone() {
    return MyCertificationState()
      ..requestController = requestController
      ..userCertification = userCertification;
  }
}

MyCertificationState initState(Map<String, dynamic> args) {
  return MyCertificationState();
}
