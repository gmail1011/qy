// import 'dart:ffi';
import 'dart:io';
import 'package:fish_redux/fish_redux.dart';

enum ListAction {
  action,
  showChatFields,
  sendHistoryRequest,
  getHistoryMsg,
  sessionId,
  changeIsScrollToBottom,
  loading,
  upPicError,
  removePicFile,
  removeListFile,
  waitAction,
  refuseConnect,
  currentTime,
  solveQuest,
  otherQuest,
  sendNotification,
  msgRead,
  sendMsgIsRead,
  chageReverseStatus,
  hideOrShowFaqBtn,
  showMsg,
  endRefresh,
  reconnectAfterDisconnection,
  onRefresh,
  uplateMsgStatus,
}

class ListActionCreator {
  ///结束刷新
  static Action onEndRefresh(bool reverse) {
    return Action(ListAction.endRefresh, payload: reverse);
  }

  //展示消息  统一管理
  //改变listView当前是否倒置的状态
  static Action onShowMsg(dynamic data) {
    return Action(ListAction.showMsg, payload: data);
  }

  //改变listView当前是否倒置的状态
  static Action onChageReverseStatus(bool reverse) {
    return Action(ListAction.chageReverseStatus, payload: reverse);
  }

  static Action uplateMsgStatus(Map data) {
    return Action(ListAction.uplateMsgStatus, payload: data);
  }

  //判断当前是否链接websocket 隐藏faq底部已解决 其他问题 未解决按钮
  static Action onHideOrShowFaqBtn(bool isConnect) {
    return Action(ListAction.hideOrShowFaqBtn, payload: isConnect);
  }

  // 发送通知取消定时器
  //发送通知 取消当前定时器读秒 -> 这个定时器是用户不小心点了已解决按钮
  //有一个10s的倒计时自动退出页面 但是用户如果又操作了其他功能 就取消
  static Action onSendNotification() {
    return const Action(ListAction.sendNotification);
  }

  // 发送已读消息内容
  static Action onSendMsgIsRead(List<int> lists) {
    return Action(ListAction.sendMsgIsRead, payload: lists);
  }

  // 展示当前时间
  static Action onShowCurrentTime(dynamic data) {
    return Action(ListAction.currentTime, payload: data);
  }

  // 接收消息已读状态
  static Action onMsgRead(dynamic data) {
    return Action(ListAction.msgRead, payload: data);
  }

  //重置当前聊天列表是否需要滑动到底部
  static Action onChangeIsScrollToBottom(bool isCrollToBottom) {
    return Action(ListAction.changeIsScrollToBottom, payload: isCrollToBottom);
  }

  static Action onIsShowLoading(Map<String, bool> loadingState) {
    return Action(ListAction.loading, payload: loadingState);
  }

  //当前没有客服 需要等待
  static Action onWaitAction(dynamic data) {
    return Action(ListAction.waitAction, payload: data);
  }

  //点击已解决按钮时间
  static Action onSolveQuest(String content) {
    return Action(ListAction.solveQuest, payload: content);
  }

  //点击其他疑问
  static Action onOtherQuest(String content) {
    return Action(ListAction.otherQuest, payload: content);
  }

  //服务器因为用户被禁言或者其他原因拒绝连接 =====协议号2000
  static Action onRefuseConnect(dynamic data) {
    return Action(ListAction.refuseConnect, payload: data);
  }

  //获取当前的sessionId
  static Action onSetSessionId(String sessionId) {
    return Action(ListAction.sessionId, payload: sessionId);
  }

  //展示消息
  static Action onShowChatFields(dynamic data) {
    return Action(ListAction.showChatFields, payload: data);
  }

  //发送消息给服务端  请求返回历史消息
  static Action onSendHistoryRequest() {
    return Action(ListAction.sendHistoryRequest);
  }

  static Action onUpPicError(Map<String, File> file) {
    return Action(ListAction.upPicError, payload: file);
  }

  // 删除重新上传集合对象
  static Action onRemovePicFile(String key) {
    return Action(ListAction.removePicFile, payload: key);
  }

  //返回历史消息
  static Action onGetHistoryMsg(dynamic data) {
    return Action(ListAction.getHistoryMsg, payload: data);
  }

  // 删除List中需要再次上传的文件
  static Action onRemoveListFile(dynamic time) {
    return Action(ListAction.removeListFile, payload: time);
  }

  // 断线重链接
  static Action onReconnectAfterDisconnection() {
    return Action(ListAction.reconnectAfterDisconnection);
  }

// 刷新数据
  static Action onRefresh() {
    return Action(ListAction.onRefresh);
  }
}
