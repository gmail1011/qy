import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/selected_tags_entity.dart';
import 'package:flutter_app/model/tags_liao_ba_entity.dart';

import 'SelectedTagsBean.dart';

//TODO replace with your own action
enum CommonPostDetailAction { action , getTags,getDetails,loadmore ,getSelected ,setLoading}

class CommonPostDetailActionCreator {
  static Action onAction() {
    return const Action(CommonPostDetailAction.action);
  }

  static Action getTags(TagsLiaoBaData specialModel) {
    return Action(CommonPostDetailAction.getTags,payload: specialModel);
  }

  static Action getDetails(SelectedTagsData selectedTagsData) {
    return Action(CommonPostDetailAction.getDetails,payload: selectedTagsData);
  }

  static Action loadMore(SelectedTagsBean selectedTagsBean) {
    return Action(CommonPostDetailAction.loadmore,payload: selectedTagsBean);
  }

  static Action setLoading(bool isLoading) {
    return Action(CommonPostDetailAction.setLoading,payload: isLoading);
  }
}
