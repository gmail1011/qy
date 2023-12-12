import 'dart:async';
import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alipay/flutter_alipay.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import './app.dart';
import 'assets/app_colors.dart';
import 'assets/app_fontsize.dart';
import 'assets/lang.dart';
import 'common/config/config.dart';
import 'utils/time_zone_tool.dart';

Future<void> main() async {
  // FlutterBugly.postCatchedException(() async {
  //   SystemChrome.setPreferredOrientations(
  //           [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp])
  //       .then((_) async {
  //     FlutterBugly.init(androidAppId: "06ed1177f0", iOSAppId: "06ed1177f0");
  //   });
  // });

  runZoned(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    ErrorWidget.builder = (FlutterErrorDetails details) {
      Zone.current.handleUncaughtError(details.exception, details.stack);
      return Container(color: Colors.transparent);
    };

    ///强制竖屏后，启动app
    SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
        .then((value) => startApp());
  }, onError: (Object obj, StackTrace stack) {
    //添加崩溃日志保存文件
    l.e('ERROR', 'onError happend ...$obj', saveFile: true);
    l.e('ERROR', 'onError happend ...stack:$stack',
        stackTrace: stack, saveFile: true);
    l.writeCrash(obj, stackTrace: stack);
  });
}

startApp() async {
  FlutterBase.init(core: 1);
  FlutterBase.setDioProxy(Config.PROXY, Config.PROXY_URL);
  // GoogleFonts.zcoolKuaiLe();
  GlobalStore.store;

  FlutterAlipay.setIosUrlSchema(Config.IOS_SCHEMES);
  await SpUtil.getInstance();
  final isAmericaZone = await TimeZoneTool.isAmericaZone();


  PaintingBinding.instance.imageCache.maximumSize = 3000;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 600 << 20;

  initFreshFps();

  if (isAmericaZone && Platform.isIOS) {
    runApp(configRefreshApp(MaterialApp(
      theme: ThemeData(),
      debugShowCheckedModeBanner: true,
      home: TFWidget(),
    )));
  } else {
    runApp(DevicePreview(
        // enabled: !kReleaseMode,
        enabled: false,
        builder: (context) => configRefreshApp(InitedApp())));

    //InitedApp());
  }
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}




void initFreshFps() async{
  ///...///

  try {


    dynamic modes = await FlutterDisplayMode.supported;


    modes.forEach(print);


    /// This setting is per session.
    /// Please ensure this was placed with `initState` of your root widget.
    await FlutterDisplayMode.setMode(modes[0]);

    /// On OnePlus 7 Pro:
    /// #1 1080x2340 @ 60Hz
    /// #2 1080x2340 @ 90Hz
    /// #3 1440x3120 @ 90Hz
    /// #4 1440x3120 @ 60Hz

    /// On OnePlus 8 Pro:
    /// #1 1080x2376 @ 60Hz
    /// #2 1440x3168 @ 120Hz
    /// #3 1440x3168 @ 60Hz
    /// #4 1080x2376 @ 120Hz
  } on PlatformException catch (e) {
    /// e.code =>
    /// noAPI - No API support. Only Marshmallow and above.
    /// noActivity - Activity is not available. Probably app is in background
  }
}



Widget configRefreshApp(Widget child) {
  return RefreshConfiguration(
    headerBuilder: () => ClassicHeader(

      releaseText: Lang.RELEASE_REFRESH,
      failedText: Lang.REFRESH_FAILED,
      refreshingText: Lang.LOADING,
      textStyle: TextStyle(
          color: AppColors.userPayTextColor,
          fontSize: AppFontSize.fontSize14,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.normal),
      completeText: Lang.REFRESH_SUCCESS,
      idleText: Lang.PULL_DOWN_REFRESH,
    ),
    footerBuilder: () => ClassicFooter(
      loadingText: Lang.LOADING,
      canLoadingText: Lang.RELEASE_LOAD_MORE,
      noDataText: Lang.NO_MORE_DATA,
      idleText: Lang.PULL_UP_LOAD_MORE,
      failedText: Lang.LOADING_FAILED,
      textStyle: TextStyle(
          color: AppColors.userPayTextColor,
          fontSize: AppFontSize.fontSize14,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.normal),
    ),
    child: child,
  );
}

class TFWidget extends StatefulWidget {
  @override
  _TFWidgetState createState() => _TFWidgetState();
}

class _TFWidgetState extends State<TFWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        titleSpacing: 0,
        title: Text("温馨提示"),
      ),
      body: Center(
        child: Text("服务器正在维护，请稍后再试～"),
      ),
    );
  }
}
