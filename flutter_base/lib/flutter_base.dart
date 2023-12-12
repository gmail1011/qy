library flutter_base;

import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/utils/light_model.dart';
import 'package:my_worker_manager/my_worker_manager.dart';

export 'package:flutter_base/utils/log.dart';
export 'package:flutter_base/utils/dimens.dart';
export 'package:flutter_base/utils/screen.dart';
export 'package:flutter_base/utils/text_util.dart';
export 'package:flutter_base/utils/array_util.dart';
export 'package:flutter_base/utils/toast_util.dart';
export 'package:flutter_base/utils/light_model.dart';
export 'package:flutter_base/utils/file_util.dart';
export 'package:flutter_base/utils/click_util.dart';
export 'package:flutter_base/flutter_sdk/drawer_scaffold.dart';
// export 'package:flutter_app/common/image/image_loader.dart';
export 'package:flutter_base/net/dio_cli.dart';
export 'package:flutter_base/utils/navigator_util.dart';
export 'package:flutter_base/net/e_data.dart';
export 'package:flutter_base/ext_core/dart_stack.dart';
export 'package:flutter_base/flutter_sdk/flutter_page_router.dart';
export 'package:flutter_base/task_manager/base_task.dart';
export 'package:flutter_base/task_manager/task_manager.dart';
export 'package:flutter_base/task_manager/task_state.dart';

export 'package:flutter_base/eagle/eagle_helper.dart';
export 'package:flutter_base/eagle/umeng_util.dart';
export 'package:flutter_base/utils/page_intro_helper.dart';

//player
export 'package:flutter_base/player/single_player.dart';
export 'package:flutter_base/player/player_single_ctrl.dart';
export 'package:flutter_base/player/ijk_base_video_controler.dart';
export 'package:flutter_base/player/player_util.dart';
export 'package:flutter_base/player/h_player.dart';
export 'package:flutter_base/player/v_player.dart';
export 'package:flutter_base/player/video_progress_colors.dart';
export 'package:flutter_base/task_manager/dialog_manager.dart';
export 'package:flutter_base/utils/date_util.dart';

export 'package:flutter_base/net/http_dns.dart';

class FlutterBase {
  static bool isRelease = true;
  static const String basePkgName = "flutter_base";
  static bool proxyEnable = false;
  //"PROXY 192.168.1.150:8888"
  static String proxyUrl = "";
  static final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  /// [core] 核心线程数量 -1,不创建携程;0,跟随系统cpu数量创建
  static Future init({int core = -1}) async {
    isRelease = const bool.fromEnvironment("dart.vm.product");
    await lightKV.init();
    FijkLog.setLevel(FijkLogLevel.Silent);
    if (-1 != core) {
      await Executor().warmUp(processorsNumber: core);
    }
  }

  /// 获取顶层BuildContext
  static BuildContext get appContext =>
      navigatorKey?.currentState?.overlay?.context;

  ///[url] "PROXY 192.168.1.150:8888"
  static setDioProxy(bool enable, String url) {
    proxyEnable = enable;
    proxyUrl = url;
  }
}
