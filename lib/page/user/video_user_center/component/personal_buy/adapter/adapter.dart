import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/user/video_user_center/component/personal_buy/component/component.dart';

import '../state.dart';
import 'reducer.dart';

class UserBuyAdapter extends SourceFlowAdapter<UserBuyPostState> {
  UserBuyAdapter()
      : super(
          pool: <String, Component<Object>>{
            'buyItem': BuyItemComponent(),
          },
          reducer: buildReducer(),
        );
}
