import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/liao_ba_tags_detail_entity.dart';
import 'package:flutter_app/page/home/post/page/common_post/detail/SelectedBean.dart';

//TODO replace with your own action
enum common_post_detailAction { action , initData , selectedData ,}

class common_post_detailActionCreator {
  static Action onAction() {
    return const Action(common_post_detailAction.action);
  }

  static Action onInitData(LiaoBaTagsDetailData tagListModel) {
    return  Action(common_post_detailAction.initData,payload: tagListModel);
  }

  static Action onSelectedData(SelectedBean selectedBean) {
    return  Action(common_post_detailAction.selectedData,payload: selectedBean);
  }
}
