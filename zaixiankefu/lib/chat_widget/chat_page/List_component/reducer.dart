import '../../chat_core/pkt/pb.pb.dart';
import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Reducer<ListState> buildReducer() {
  return asReducer(
    <Object, Reducer<ListState>>{
      ListAction.showChatFields: _onShowChatFields,
      ListAction.sessionId: _onSessionId,
      ListAction.changeIsScrollToBottom: _onChangeIsScrollToBottom,
      ListAction.loading: _onIsShowLoading,
      ListAction.upPicError: _onUpPicError,
      ListAction.removePicFile: _onRemovePicFile,
      ListAction.currentTime: _onShowCurrentTime,
      ListAction.removeListFile: _onRemoveListFile,
      ListAction.msgRead: _onMsgRead,
      ListAction.chageReverseStatus: _onChangeReverse,
      ListAction.hideOrShowFaqBtn: _onHideFaqBtn,
      ListAction.endRefresh: _onEndRrefresh,
      ListAction.onRefresh: _onRefresh,
      ListAction.uplateMsgStatus: _uplateMsgStatus,
    },
  );
}

ListState _onEndRrefresh(ListState state, Action action) {
  final ListState newState = state.clone();
  bool reverse = action.payload;
  if (reverse == false) {
    newState.controller.refreshCompleted();
  } else {
    newState.controller.loadComplete();
  }
  return newState;
}

ListState _onShowCurrentTime(ListState state, Action action) {
  final ListState newState = state.clone()
    ..timeServicerInfoFields = action.payload;
  return newState;
}

ListState _onRefresh(ListState state, Action action) {
  final ListState newState = state.clone();
  return newState;
}

//通过websocket是否链接 隐藏faq底部三个按钮
ListState _onHideFaqBtn(ListState state, Action action) {
  final ListState newState = state.clone();
  // ..isConnect = action.payload;
  return newState;
}

//改变listView是否倒置的状态
ListState _onChangeReverse(ListState state, Action action) {
  bool reverse = action.payload;
  final ListState newState = state.clone()..reverse = reverse;
  return newState;
}

ListState _uplateMsgStatus(ListState state, Action action) {
  final ListState newState = state.clone()
    ..sendMsgStatus.addAll(action.payload);
  return newState;
}

//已读消息处理
ListState _onMsgRead(ListState state, Action action) {
  final ListState newState = state.clone();
  for (var i = 0; i < state.list.length; i++) {
    dynamic data = state.list[i];
    if (data is ChatFields && data.isRead != null) {
      if (data.isRead != 2) {
        data.isRead = 2;
      }
    }
  }
  return newState;
}

ListState _onRemovePicFile(ListState state, Action action) {
  final ListState newState = state.clone()..images.remove(action.payload);
  return newState;
}

ListState _onUpPicError(ListState state, Action action) {
  final ListState newState = state.clone()..images.addAll(action.payload);
  return newState;
}

ListState _onSessionId(ListState state, Action action) {
  final ListState newState = state.clone()
    ..currentSessionId = action.payload
    ..isScrollToBottom = false;
  return newState;
}

ListState _onIsShowLoading(ListState state, Action action) {
  final ListState newState = state.clone()..loadingState.addAll(action.payload);
  return newState;
}

ListState _onChangeIsScrollToBottom(ListState state, Action action) {
  final ListState newState = state.clone()..isScrollToBottom = action.payload;
  return newState;
}

ListState _onRemoveListFile(ListState state, Action action) {
  final ListState newState = state.clone();
  var list = newState.list;
  newState.list = list
      .where((item) => item is ChatFields ? item.time != action.payload : true)
      .toList();
  return newState;
}

ListState _onShowChatFields(ListState state, Action action) {
  dynamic childFields = action.payload;
  final ListState newState = state.clone();

  if (childFields is List) {
    var list = List();
    for (var i = 0; i < childFields.length; i++) {
      var c = childFields[i];

      if (c.type == 1) {
        c.type = 2;
      } else {
        c.type = 1;
      }
      list.insert(0, c);
    }
    if (state.reverse == true) {
      newState.list.addAll(list);
    } else {
      newState.list.insertAll(0, list);
    }
    if (list.length > 0) {
      newState.controller.loadComplete();
    }
  } else {
    if (state.reverse == false) {
      newState.list.add(childFields);
    } else {
      newState.list.insert(0, childFields);
    }
  }

  return newState;
}
