import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class SectionComponent extends Component<SectionState> {
  SectionComponent()
      : super(
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<SectionState>(
                adapter: null,
                slots: <String, Dependent<SectionState>>{
                }),);

}
