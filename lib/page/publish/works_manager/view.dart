import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/page/publish/works_manager/work_manager_page.dart';
import 'state.dart';

///稿件管理UI 作品管理
Widget buildView(
    WorksManagerState state, Dispatch dispatch, ViewService viewService) {

  return WorkUnitManagerPage(state: state, dispatch: dispatch, viewService: viewService);
}
