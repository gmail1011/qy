import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/home/post/post_item_component/state.dart';


import 'view.dart';

class MineWorkItemComponent extends Component<PostItemState> {
  MineWorkItemComponent()
      : super(
          view: buildView,
          dependencies: Dependencies<PostItemState>(
              adapter: null,
              slots: <String, Dependent<PostItemState>>{}),
        );
}
