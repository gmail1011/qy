import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ListComponent extends Component<ListState> {
  ListComponent()
      : super(
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<ListState>(
                adapter: null,
                slots: <String, Dependent<ListState>>{
                }),);

}
