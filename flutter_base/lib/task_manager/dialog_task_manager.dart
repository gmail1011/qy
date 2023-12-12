import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

final newDialogTaskManager = DialogTaskManager();

/// 购买视频对话框dialog 管理器，避免一次弹出多个dialog
const _MAX_FAILED_CNT = 3;

class DialogTaskManager {
  //文件上传和下载队列，这个map是上传下载的状态管理，并不会做去除重复的操作
  List<DialogNewTask> _dialogList = <DialogNewTask>[];

  PublishSubject<bool> _allFinish = PublishSubject();
  DialogNewTask curTask;
  String lastFailedId;
  int failedCnt = 0;

  /// 添加一个新的dialog 到
  Future<B> addDialogNewTaskToQueue<B>(AsyncValueGetter<B> call, {String uniqueId}) {
    if (null == call) return null;
    uniqueId = (uniqueId ?? Uuid().v1());
    if (uniqueId == curTask?.taskId) {
      return Future.error("task:$uniqueId is already showing...");
    }
    var task = _dialogList.firstWhere((it) => it.taskId == uniqueId,
        orElse: () => null);
    if (null != task) {
      return Future.error("already exist task:$uniqueId");
    }
    task = DialogNewTask<B>(call, uniqueId);
    _dialogList.add(task);
    doExecute();
    return task.getFuture;
  }

  void handleErrorIfNeed() {
    failedCnt++;
    if (failedCnt >= _MAX_FAILED_CNT) {
      failedCnt = 0;
      if (!(curTask?.completer?.isCompleted ?? true))
        curTask?.completer?.complete(null);
      curTask = null;
      if (_dialogList.isEmpty) _allFinish.sink.add(true);
    }
  }

  /// 非async 函数
  doExecute() {
    if (_dialogList.isEmpty) return;
    if (null != curTask) return;
    curTask = _dialogList.removeAt(0);
    final task = curTask;
    l.i("dialog_manager", "doExecute()..展示dialog:${task?.taskId}");
    task?.call().then((v) {
      l.i("dialog_manager", "doExecute()..展示dialog:${task?.taskId} 成功");
      curTask = null;
      if (!(task?.completer?.isCompleted ?? true)) task?.completer?.complete(v);
    }).catchError((e) {
      l.i("dialog_manager", "doExecute()..展示dialog:${task?.taskId} 错误");
      curTask = null;
      task?.completer?.completeError(e);
    }).whenComplete(() {
      l.i("dialog_manager", "doExecute()..展示dialog:${task?.taskId} 结束");
      curTask = null;
      if (_dialogList.isEmpty) _allFinish.sink.add(true);
      doExecute();
    });
  }

  Stream<bool> waitForAll() {
    if (_dialogList.isEmpty && null == curTask) return Stream.value(true);
    return _allFinish.asBroadcastStream();
  }

  void remove(String taskId) {
    _dialogList?.removeWhere((element) {
      return element?.taskId == taskId;
    });
  }
}

class DialogNewTask<B> {
  String _uniqueId;
  AsyncValueGetter<B> call;
  Completer<B> completer = Completer();

  DialogNewTask(this.call, [String uniqueId])
      : this._uniqueId = uniqueId ?? Uuid().v1();

  String get taskId => _uniqueId;

  Future<B> get getFuture => completer.future;
}
