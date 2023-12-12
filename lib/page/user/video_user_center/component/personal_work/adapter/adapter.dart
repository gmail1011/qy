import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/user/video_user_center/component/personal_work/component/component.dart';

import '../state.dart';
import 'reducer.dart';

class UserWorkAdapter extends SourceFlowAdapter<UserWorkPostState> {
  UserWorkAdapter()
      : super(
          pool: <String, Component<Object>>{
            'workItem': WorkItemComponent(),
          },
          reducer: buildReducer(),
        );
}

