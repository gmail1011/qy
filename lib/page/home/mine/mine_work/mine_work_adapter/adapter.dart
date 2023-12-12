import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/home/mine/mine_work/mine_work_item_component/component.dart';
import 'package:flutter_app/page/home/post/post_item_component/component.dart';

import '../state.dart';
import 'reducer.dart';


class MineWorkAdapter extends SourceFlowAdapter<MineWorkState> {
  MineWorkAdapter()
      : super(
          pool: <String, Component<Object>>{
            "work_item": MineWorkItemComponent(),
            "post_item": PostItemComponent(),
          },
          reducer: buildReducer(),
        );
}


