import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/user/video_user_center/component/personal_like/component/component.dart';

import '../state.dart';
import 'reducer.dart';

class UserLikeAdapter extends SourceFlowAdapter<UserLikePostState> {
  UserLikeAdapter()
      : super(
          pool: <String, Component<Object>>{
            'likeItem':LikeItemComponent()
          },
          reducer: buildReducer(),
        );
}
