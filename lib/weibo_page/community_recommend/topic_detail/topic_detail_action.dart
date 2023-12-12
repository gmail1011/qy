import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/tag/tag_bean.dart';

//TODO replace with your own action
enum TopicDetailAction { action ,getData,getVideoData,getMovieData,onLoadMore,setCollect,onVideoLoadmore,onMovieLoadmore,getPlayCount}

class TopicDetailActionCreator {
  static Action onAction() {
    return const Action(TopicDetailAction.action);
  }

  static Action onGetData(TagBean tagBean) {
    return  Action(TopicDetailAction.getData,payload: tagBean);
  }

  static Action onGetPlayCount(int tagBean) {
    return  Action(TopicDetailAction.getPlayCount,payload: tagBean);
  }

  static Action onLoadMore(int pageNum) {
    return  Action(TopicDetailAction.onLoadMore,payload: pageNum);
  }

  static Action onVideoLoadMore(int pageNum) {
    return  Action(TopicDetailAction.onVideoLoadmore,payload: pageNum);
  }

  static Action onMovieLoadMore(int pageNum) {
    return  Action(TopicDetailAction.onMovieLoadmore,payload: pageNum);
  }

  static Action setCollect(bool collect) {
    return  Action(TopicDetailAction.setCollect,payload: collect);
  }

  static Action onGetVideoData(TagBean tagBean) {
    return  Action(TopicDetailAction.getVideoData,payload: tagBean);
  }

  static Action onGetMovieData(TagBean tagBean) {
    return  Action(TopicDetailAction.getMovieData,payload: tagBean);
  }
}
