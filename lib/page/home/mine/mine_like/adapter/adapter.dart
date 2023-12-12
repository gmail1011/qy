import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/home/mine/mine_like/component/component.dart';
import '../state.dart';
import 'reducer.dart';

class MineLikeAdapter extends SourceFlowAdapter<MineLikePostState> {
  MineLikeAdapter()
      : super(
          pool: <String, Component<Object>>{
            'mineLikeItem':MineLikeItemComponent()
          },
          reducer: buildReducer(),
        );
}
