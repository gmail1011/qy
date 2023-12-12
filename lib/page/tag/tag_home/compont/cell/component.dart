import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/tag/tag_home/compont/cell/state.dart';

import 'view.dart';

/// tag Detail item
class TagDetailCellComponent extends Component<TagItemState> {
  TagDetailCellComponent()
      : super(
            view: buildView,
            dependencies: Dependencies<TagItemState>(
                adapter: null,
                slots: <String, Dependent<TagItemState>>{
                }),);

}
