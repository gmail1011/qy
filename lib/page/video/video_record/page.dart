import 'package:fish_redux/fish_redux.dart';
import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///视频发布界面
class VideoRecordingPage extends Page<VideoRecordingState, Map<String, dynamic>> with KeepAliveMixin{
  VideoRecordingPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            wrapper:keepAliveClientWrapper,
            dependencies: Dependencies<VideoRecordingState>(
                adapter: null,
                slots: <String, Dependent<VideoRecordingState>>{
                }),
            middleware: <Middleware<VideoRecordingState>>[
            ],);

}
