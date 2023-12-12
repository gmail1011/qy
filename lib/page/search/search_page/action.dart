import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/search_default_entity.dart';
import 'package:flutter_app/model/search_default_hot_blogger_entity.dart';
import 'package:flutter_app/model/tag/hot_tag_model.dart';
import 'package:flutter_app/model/tag/tag_detail_model.dart';

enum SearchAction {
  onSubmitted, //點擊搜索
  showAll, //全部搜索記錄
  refreshHistorys, //刷新历史
  refreshTag, //刷新历史
  refreshHotTag,
  deleteAll,
  delete,
  broadcastRefreshHistorys,
  getHotSearchList,
  getHotSearchBlogger,
  getAdList,
  updateUI,
}

class SearchActionCreator {
  static Action broadcastRefreshHistorys(String text) {
    return Action(SearchAction.broadcastRefreshHistorys, payload: text);
  }

  static Action updateUI() {
    return Action(SearchAction.updateUI);
  }

  static Action delete(int index) {
    return Action(SearchAction.delete, payload: index);
  }

  static Action deleteAll() {
    return Action(SearchAction.deleteAll);
  }

  static Action showAll() {
    return const Action(SearchAction.showAll);
  }

  static Action onSubmitted(String text) {
    return Action(SearchAction.onSubmitted, payload: text);
  }

  static Action onRefreshHistorys(List<String> list) {
    return Action(SearchAction.refreshHistorys, payload: list);
  }

  static Action onRefreshTag(List<TagDetailModel> tagList) {
    return Action(SearchAction.refreshTag, payload: tagList);
  }


  static Action onRefreshHotTag(List<HotTagModel> tagList) {
    return Action(SearchAction.refreshHotTag, payload: tagList);
  }

  static Action onGetHotSearchList(SearchDefaultData searchDefaultData) {
    return Action(SearchAction.getHotSearchList, payload: searchDefaultData);
  }

  static Action onGetHotSearchBlogger(SearchDefaultHotBloggerData searchDefaultData) {
    return Action(SearchAction.getHotSearchBlogger, payload: searchDefaultData);
  }

  static Action onGetAdList(SearchDefaultHotBloggerData searchDefaultData) {
    return Action(SearchAction.getHotSearchBlogger, payload: searchDefaultData);
  }

  static Action getAdList(List<AdsInfoBean> adsList) {
    return Action(SearchAction.getAdList, payload: adsList);
  }
}
