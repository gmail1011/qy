import 'dart:async';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/flare.dart';

import 'package:flutter_base/flutter_base.dart';

/// 带loading框的异步任务

/// 后台任务函数
typedef BackgroundFunction<T> = Future<T> Function();

/// 带loading的异步任务
Future<T> asyncTask<T>(BuildContext context, BackgroundFunction<T> task,
    {String loadingTitle}) async {
  if (null == task) return null;
  if (null == context) context = FlutterBase.appContext;
  Completer<T> completer = Completer();
  _asyncTaskInner(context, task, completer);
  return completer.future;
}

_asyncTaskInner<T>(BuildContext context, BackgroundFunction<T> task,
    Completer<T> completer) async {
  Future.delayed(Duration(microseconds: 100), () async {
    T t = await task();
    completer.complete(t);
    safePopPage();
  });
  await showDialog(context: context, builder: (context) => LoadingView());
}

/// 加载中的view
class LoadingView extends StatefulWidget {
  final String title;

  LoadingView({Key key, this.title}) : super(key: key);

  @override
  _LoadingViewState createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // 设置透明背影
      body: Center(
          child: Container(
              width: 40,
              height: 20,
              child: FlareActor(AssetsFlare.LOADING,
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation:
                      "loading") // 自带loading效果，需要宽高设置可在外加一层sizedbox，设置宽高即可
              )),
    );
  }
}
