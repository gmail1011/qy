import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class MineLikeItemComponent extends Component<MineLikeItemState> {
  MineLikeItemComponent()
      : super(
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<MineLikeItemState>(
                adapter: null,
                slots: <String, Dependent<MineLikeItemState>>{
                }),);

}
