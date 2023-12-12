import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/liao_ba_tags_detail_entity.dart';
import 'package:flutter_app/model/tag/tag_bean.dart';
import 'package:flutter_app/model/tag/tag_detail_model.dart';
import 'package:flutter_app/page/home/post/page/common_post/detail/SelectedBean.dart';
import 'package:flutter_app/page/tag/tag_home/compont/cell/state.dart';

///使用枚举定义相应的type
enum TagAction {
  refreshUI,
  onRefresh,
  onLoadMore,
}

///定义一系列action
class TagActionCreator {
  static Action onRefresh() {
    return const Action(TagAction.onRefresh);
  }

  static Action onLoadMore() {
    return const Action(TagAction.onLoadMore);
  }

  static Action updateUI() {
    return const Action(TagAction.refreshUI);
  }
}
