import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class BuyItemComponent extends Component<BuyItemState> {
  BuyItemComponent()
      : super(
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<BuyItemState>(
                adapter: null,
                slots: <String, Dependent<BuyItemState>>{
                }),);

}
