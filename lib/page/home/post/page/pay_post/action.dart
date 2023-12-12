import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/home/post/post_item_component/state.dart';

enum PayPostAction { initList }

class PayPostActionCreator {

  static Action initList(List<PostItemState> items) {
    return Action(PayPostAction.initList, payload: items);
  }
}
