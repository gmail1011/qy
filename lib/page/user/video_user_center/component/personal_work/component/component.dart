import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class WorkItemComponent extends Component<WorkItemState> {
  WorkItemComponent()
      : super(
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<WorkItemState>(
                adapter: null,
                slots: <String, Dependent<WorkItemState>>{
                }),);

}
