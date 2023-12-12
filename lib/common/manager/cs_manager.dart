import 'dart:convert';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:chat_online_customers/chat_widget/chat_core/network/connection/socket_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_model/userModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart'
    hide ImgType;
import 'package:flutter_app/common/image/image_cache_manager.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/common/provider/msg_count_model.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/services_model.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/widget/common_widget/LoadingWidget.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:provider/provider.dart';

final csManager = CSManager();

/// 客服管理类
class CSManager {
  Future<void> init(BuildContext context) async {
    var model = await _getServices(context);

    if (model == null) {
      showToast(msg: Lang.GET_CUSTOMER_INFO_FAILED);
      return;
    }
    var user = GlobalStore.getMe();
    var base64 = '';
    try {
      //正加载一次  确保能在缓存中读到数据，待优化
      var imgPath =
          getImagePath(user.portrait, false, false, width: 100, height: 100);
      // ImageLoader.withP(ImageType.IMAGE_NETWORK_HTTP, address: imgPath).load();
      // var imgPath = path.join(Address.baseImagePath, user.portrait);
      // var a = await ImageCacheManager().getFileFromCache(imgPath ?? '');
      var f = await ImageCacheManager().getSingleFile(imgPath);
      List<int> imageBytes = await f.readAsBytes();
      base64 = base64Encode(imageBytes);
    } catch (e) {
      l.e("csManager", "e:$e");
    }

    //"https://zsjs.qyukwnk.com"
    var url = Address.baseHost + model?.sign ?? '';
    // var url = "https://qhapi.5igww.cn/kefu/customer/im?sign=b2b37f2e09b525ba3f80349871be3cefe7ddbc3ca8a6565ea2f02485a97f8f395c3bac3e8df826fb906ca3d1c6b3431f2a793b362817b8ec80b179fc001ad7a5d50adb4d18f6b7c8b796bf4613a91d6cf8d858e89903700fa0c6a7316d0ef01668f8e1d07324e4278981699468af0e855e284ff5bcea00adb0bdaa4e50bcb6065be2a7675b8a796bccff3cc059a83f913b0cac63d47645093a4bb1a4fb6b6e8c43bd803dc02cdd2825b11461f5c8cf7c&appId=8818714660&theme=theme1";
    var baseUrl = Address.baseHost;
    // var url = "https://zsjs.qyukwnk.com" + model?.sign ?? '';
    // var baseUrl = "https://zsjs.qyukwnk.com";

    // var url = 'http://183.61.126.215:9090/customer/im?sign=346de818698fed14e44cc49a9a2d19a7243a809a261bb81485f99ac354e1f8ddc0800fb1fb821997af1a4ba290e7f6beb07d3e55a5b15e9db2ac6bd1cb1447635c727be5e58c4e36e9834980c18f10cb&appId=9189155602&protoType=1&pType=201';
    // var url = 'http://163.53.216.122:8081/kefu/customer/im?sign=346de818698fed14e44cc49a9a2d19a7243a809a261bb81485f99ac354e1f8ddc0800fb1fb821997af1a4ba290e7f6beb07d3e55a5b15e9db2ac6bd1cb1447635c727be5e58c4e36e9834980c18f10cb&appId=9189155602&protoType=1&pType=201';
    // var baseUrl = 'http://183.61.126.215:8080';
    print("socket拼接地址:" + url);
    var param = KefuUserModel(
        userId: user?.uid?.toString(),
        username: user?.name ?? '',
        baseUrl: baseUrl,
        isVoice: model?.isVoiceActive,
        connectUrl: url,
        backgroundColor: Colors.white,
        avatar: base64,
        faqApi: model?.faq,
        appBarColor: AppColors.primaryColor,
        faqHeadImgPath: AssetsSvg.MESSAGE_IC_ONLINE_CUSTOMER_SERVICE,
        primaryColor: Colors.red,
        checkConnectApi: model?.check ?? "/kefu/api/play/unread");
    SocketManager().model = param;
    SocketManager().getMsg = (int count) {
      l.d("object-----", "-----------------------$count");
      Future.delayed(Duration(milliseconds: 200), () {
        // var context = FlutterBase.appContext;
        // Provider.of<MsgCountModel>(context, listen: false).setCount(count);
      });
    };
    SocketManager().requestIsConnect();
  }

  Future<ServicesModel> _getServices(context) async {
    LoadingWidget loadingWidget;
    try {
      if (loadingWidget == null) {
        loadingWidget = LoadingWidget(title: "加载中...");
      }
      loadingWidget.show(context);
      var model = await netManager.client.getServices();
      loadingWidget.cancel();
      return model;
    } catch (e) {
      loadingWidget.cancel();
      l.d("_________________________---getServices", e);
      return null;
    }
  }

  Future openServices(BuildContext context) async {
    if (null == SocketManager().model) {
      await init(context);
    }
    return SocketManager().jumpToChatWidget(context).then((value) {
      if(Config.isGameSurface){
        bus.emit(EventBusUtils.showFloating,true);
        AutoOrientation.landscapeAutoMode();
        if(Config.webView != null){
          Config.webView.android.resume();
        }
      }
    });
  }
}
