import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class MineBuyItemComponent extends Component<MineBuyItemState> {
  MineBuyItemComponent()
      : super(
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<MineBuyItemState>(
                adapter: null,
                slots: <String, Dependent<MineBuyItemState>>{
                }),);

}
