//file : 全局弹窗工具
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/varibel_config.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/domain_source_model.dart';
import 'package:flutter_app/model/user_info_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/utils/global_variable.dart';
import 'package:flutter_app/widget/dialog/custom_yy_dialog.dart';
import 'package:flutter_app/widget/dialog/newDialog/account_ban_dialog.dart';
import 'package:flutter_app/widget/dialog/newDialog/taken_abnormal_dialog.dart';
import 'package:flutter_app/widget/dialog/share_report_dialog.dart';
import 'package:flutter_app/widget/dialog/update_dialog.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/light_model.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'dart:convert' as convert;

/// 购买视频回调
typedef BuyCallBackType = Function(bool isSuccess, String videoID);

/// 弹窗来源类型
enum FromPageType {
  //[1 推荐， 2 二级播放页面， 3、城市页面, 4、关注页面]
  Recommend,
  Secondary,
  City,
  Follow,
}

/// 弹窗管理
class DialogGlobal {
  factory DialogGlobal() => _getInstance();

  static DialogGlobal get instance => _getInstance();
  static DialogGlobal _instance;

  DialogGlobal._internal();

  static DialogGlobal _getInstance() {
    if (_instance == null) {
      _instance = DialogGlobal._internal();
    }
    return _instance;
  }

  // 打开分享视频��话框（底部）
  void openReportDialog(BuildContext context, VideoModel videoModel) async {
    if (context == null) return;
    List<String> types;
    try {
      types = await netManager.client.getReportList();
    } catch (e) {
      l.e("dialog", "getReportList()...error:$e");
    }
    if (ArrayUtil.isEmpty(types)) {
      showToast(msg: "获取举报类型失败");
      return;
    }
    String val = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ShareReportDialog(reportList: types);
        });
    // val为举报类型，下面发送举报请求或者'cancel'
    if (val != "cancel") {
      UserInfoModel userInfoModel = GlobalStore.getMe();
      int uid = userInfoModel.uid;
      String objType = 'video';
      String objID = videoModel.id;
      String types = val;
      int objUID = videoModel.publisher.uid;
      try {
        await netManager.client.shareReport(objType, objID, types, uid, objUID);
        showToast(msg: Lang.REPORT_SUCCESS);
      } catch (e) {
        l.e('shareReport', e.toString());
        showToast(msg: e.toString());
      }
    }
  }

  /// 账号封禁 全局弹窗  callBack(type)
  void openAccountBan({Function(int) callBack, String tip, int uid}) async {
    var dialog = AccountBanDialog(tip ?? "", uid);
    CustomYYDialog(closeFunc: () async {
      await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }).build(FlutterBase.appContext)
      ..width = double.infinity
      ..borderRadius = 4.0
      ..backgroundColor = Color(0x0)
      ..barrierDismissible = false // 外部不消失
      ..barrierColor = Colors.black.withOpacity(.50) //弹窗外的背景色
      ..widget(ClipRRect(borderRadius: BorderRadius.circular(8), child: dialog))
      ..show();
  }

  /// token异常 全局弹窗  callBack(type)
  void openTakenAbnormalDialog() async {
    try {
      VariableConfig.onMobileLoginView = true;
      final context = FlutterBase.appContext;
      if (context == null) return;
      CustomYYDialog(closeFunc: () {
        VariableConfig.onMobileLoginView = false;
      }).build(context)
        ..width = double.infinity
        ..borderRadius = 4.0
        ..backgroundColor = Color(0x0)
        ..barrierColor = Colors.black.withOpacity(.50) //弹窗外的背景色
        ..widget(ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: TakenAbnormalDialog()))
        ..show();
    } catch (e) {
      VariableConfig.onMobileLoginView = false;
    }
  }

  /// 打开系统弹窗 （图片）
  void openLoadingDialog(BuildContext context) async {
    var wd = SearchLoadingPage();
    CustomYYDialog(closeFunc: () {}).build(context)
      ..width = 40
      ..backgroundColor = Color(0x0)
      ..widget(wd)
      ..show();
  }

  /// 打开版本更新弹窗
  void openUpdateVersionDialog() async {
    List<dynamic> list =
        convert.jsonDecode(await lightKV.getString(Config.UPDATE_INFO));
    String phoneStr;
    if (Platform.isAndroid) {
      phoneStr = "android";
    } else {
      phoneStr = "ios";
    }
    CheckVersionBean phoneBean;
    for (dynamic bean in list) {
      CheckVersionBean checkVersionBean = CheckVersionBean.fromMap(bean);
      if (checkVersionBean.platform.toLowerCase() == phoneStr) {
        phoneBean = checkVersionBean;
        break;
      }
    }

    if (phoneBean == null) {
      return;
    }

    bool isUpdate = await showDialog(
        context: FlutterBase.appContext,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return UpdateDialog(updateInfo: phoneBean);
        });
    if (isUpdate == null) {
      isUpdate = false;
    }

    if (!isUpdate) {
      // 更新操作todo
      //退出应用
      await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      // 退出app
      return;
    }
  }
}

///////=======================================================
class SearchLoadingEvent {
  SearchLoadingEvent();
}

// token异常全局弹窗
class SearchLoadingPage extends StatefulWidget {
  //  TakenAbnormalDialog({Key key}) : super(key: key);
  _SearchLoadingPage createState() => new _SearchLoadingPage();
}

class _SearchLoadingPage extends State<SearchLoadingPage> {
  StreamSubscription searchLoadingEventID;

  @override
  void initState() {
    searchLoadingEventID =
        GlobalVariable.eventBus.on<SearchLoadingEvent>().listen((event) {
      safePopPage();
    });
    super.initState();
  }

  @override
  void dispose() {
    searchLoadingEventID.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return LoadingWidget();
  }

  void close() {
    //    exit(0);
  }
}
