import 'dart:async';
import 'package:my_worker_manager/src/runnable.dart';
import 'package:my_worker_manager/src/task.dart';

import '../../my_worker_manager.dart';

class IsolateWrapperImpl implements IsolateWrapper {
  @override
  int runnableNumber;

  Completer<Object> _result;

  @override
  Future<void> initialize() async => await Future.value(true);

  @override
  Future<O> work<A, B, C, D, O>(Task<A, B, C, D, O> task) async {
    runnableNumber = task.number;
    _result = Completer<O>();
    if (!(_result?.isCompleted ?? true)) {
      _result.complete(await _execute(task.runnable));
    }
    return _result.future;
  }

  static FutureOr _execute(Runnable runnable) => runnable();

  @override
  Future<void> kill() async {
    _result = null;
  }
}
