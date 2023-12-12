import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class PostItemComponent extends Component<PostItemState>{
  PostItemComponent()
      : super(
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<PostItemState>(
                adapter: null,
                slots: <String, Dependent<PostItemState>>{
                }),);

}
