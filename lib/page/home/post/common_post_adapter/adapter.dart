import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/home/post/post_item_component/component.dart';

import 'effect.dart';
import 'reducer.dart';

class CommonPostAdapter<T extends MutableSource> extends SourceFlowAdapter<T> {
  CommonPostAdapter()
      : super(
          pool: <String, Component<Object>>{'post_item': PostItemComponent()},
          reducer: buildReducer<T>(),
          effect: buildEffect<T>(),
        );
}
