import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/home/mine/minel_buy/component/component.dart';

import '../state.dart';
import 'reducer.dart';

class MineBuyAdapter extends SourceFlowAdapter<MineBuyPostState> {
  MineBuyAdapter()
      : super(
          pool: <String, Component<Object>>{
            'mineBuyItem': MineBuyItemComponent(),
          },
          reducer: buildReducer(),
        );
}
