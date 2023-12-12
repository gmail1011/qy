import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/video_model.dart';

class TagItemState extends Cloneable<TagItemState> {

  VideoModel videoModel;

  @override
  TagItemState clone() {
    return TagItemState()..videoModel = videoModel;
  }
}
