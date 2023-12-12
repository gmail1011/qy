import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class VideoAndPicturePublishPage extends Page<VideoAndPicturePublishState, Map<String, dynamic>> with KeepAliveMixin{
  VideoAndPicturePublishPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            wrapper:keepAliveClientWrapper,
            dependencies: Dependencies<VideoAndPicturePublishState>(
                adapter: null,
                slots: <String, Dependent<VideoAndPicturePublishState>>{
                }),
            middleware: <Middleware<VideoAndPicturePublishState>>[
            ],);

}
