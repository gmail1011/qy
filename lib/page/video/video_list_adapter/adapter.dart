import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/video/video_item_commponent/component.dart';
import 'reducer.dart';
import 'effect.dart';

class VideoListAdapter<T extends MutableSource> extends SourceFlowAdapter<T>
// with VisibleChangeMixin<T>
{
  VideoListAdapter()
      : super(
          pool: <String, Component<Object>>{
            "video_item": VideoItemComponent(),
          },
          reducer: buildReducer<T>(),
          effect: buildEffect<T>(),
        );
}
