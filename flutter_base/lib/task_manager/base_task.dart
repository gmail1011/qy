import 'dart:async';
import 'package:flutter_base/utils/log.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import 'task_state.dart';

///进度回传函数
///[value] 进度，
///[msg]其他负载消息
///  isSuccess 是否可以删除掉？？ 按照onError原则应该是可以及时返回的，过程中间给success是否有其他考虑？？
///
////// 规定helper从不主动调用onDone
/// task才有调用onDone()的权利
typedef ProgressChanged = void Function(double progress,
    {dynamic msg, bool isSuccess});

/// 基础任务,给一些默认的属性和变量赋值
/// [B] 返回类型
abstract class BaseTask<B> extends TaskState {
  bool _cancel = false;
  bool running = false;
  ProgressChanged updateListener;
  DateTime startTime = DateTime.now();
  final String _taskId;
  Completer<B> completer;
  // 当前任务进度
  double _nowProgress = .0;
  // 获取当前的任务进度度
  double get getNowProgress => _nowProgress;
  // 任务进度控制器
  BehaviorSubject<double> _progressController = BehaviorSubject();
  // 获取任务进度的流
  Stream<double> get onProgressUpdate => _progressController.stream;

  BaseTask({String taskId, this.updateListener})
      : this._taskId = taskId ?? Uuid().v1();

  Future<B> execute() {
    completer = Completer();
    sonDoExecute();
    return getFuture;
  }

  /// 儿子干事情
  void sonDoExecute();

  String get getTaskId => _taskId;

  void onUpdate(double progress, {dynamic msg, bool isSuccess}) {
    if(progress >= 1.0){
      debugLog("progress==$progress");
    }
    _nowProgress = progress;
    _progressController.add(_nowProgress);
    updateListener?.call(progress, msg: msg, isSuccess: isSuccess);
  }

  ///配置回调
  Future<B> configUpdateCallback(ProgressChanged updateListener) {
    this.updateListener = updateListener;
    return getFuture;
  }

  void onDone(B done) {
    l.i("taskmanager", "call onDone()...$done completer?:${null == completer}");
    _progressController.close();
    completer?.complete(done);
    completer = null;
  }

  void onError(Object error) {
    l.i("taskmanager",
        "call onError()...$error completer?:${null == completer}");
    completer?.completeError(error);
    completer = null;
  }

  cancelTask() {
    _cancel = true;
    completer?.completeError('cancelTask');
    completer = null;
  }

  bool isTaskCanceled() => _cancel;

  bool isRunning() => running;

  Future<B> get getFuture => completer.future;
}
