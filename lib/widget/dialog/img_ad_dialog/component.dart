import 'package:fish_redux/fish_redux.dart';

import 'state.dart';
import 'view.dart';

class ImgAdDialogComponent extends Component<ImgAdDialogState> {
  ImgAdDialogComponent()
      : super(
          view: buildView,
          dependencies: Dependencies<ImgAdDialogState>(adapter: null, slots: <String, Dependent<ImgAdDialogState>>{}),
        );
}
