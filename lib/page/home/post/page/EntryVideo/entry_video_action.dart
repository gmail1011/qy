import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/entry_video_entity.dart';

//TODO replace with your own action
enum EntryVideoAction { action ,action1, initData , initData1, getCountDownTime ,onSelected , onDataLoadMore, onDataLoadMore1 , isBeforeToday}

class EntryVideoActionCreator {
  static Action onAction() {
    return const Action(EntryVideoAction.action);
  }

  static Action onAction1() {
    return const Action(EntryVideoAction.action1);
  }

  static Action onInitData(EntryVideoData entryVideoData) {
    return  Action(EntryVideoAction.initData,payload: entryVideoData);
  }

  static Action onInitData1(EntryVideoData entryVideoData) {
    return  Action(EntryVideoAction.initData1,payload: entryVideoData);
  }

  static Action onDataLoadMore(int pageNum) {
    return  Action(EntryVideoAction.onDataLoadMore,payload: pageNum);
  }

  static Action onDataLoadMore1(int pageNum) {
    return  Action(EntryVideoAction.onDataLoadMore1,payload: pageNum);
  }

  static Action onCountDownTime(String countDownTime) {
    return  Action(EntryVideoAction.getCountDownTime,payload: countDownTime);
  }

  static Action onSelected(String id) {
    return  Action(EntryVideoAction.onSelected,payload: id);
  }

  static Action isBeforeToday(bool isBeforeToday) {
    return  Action(EntryVideoAction.isBeforeToday,payload: isBeforeToday);
  }
}
