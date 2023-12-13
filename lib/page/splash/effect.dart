import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flustars/flustars.dart' hide TextUtil;
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/goim/local_notification.dart';
import 'package:flutter_app/common/image/image_cache_manager.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/local_store/cached_video_store.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/common/manager/ad_Insert_manager.dart';
import 'package:flutter_app/common/manager/detect_line_manager.dart';
import 'package:flutter_app/common/net2/api_exception.dart';
import 'package:flutter_app/common/net2/http_signature_interceptor.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/common/provider/can_play_count_model.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/cut_info.dart';
import 'package:flutter_app/model/local_video_model.dart';
import 'package:flutter_app/model/watch_count_model.dart';
import 'package:flutter_app/page/video/video_list_model/recommend_list_model.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/utils/version_util.dart';
import 'package:flutter_app/widget/dialog/confirm_dialog.dart';
import 'package:flutter_app/widget/dialog/loading_dialog.dart';
import 'package:flutter_app/widget/dialog/no_permission_dialog.dart';
import 'package:flutter_app/widget/dialog/update_dialog.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/local_server/local_server.dart';
import 'package:flutter_base/local_server/local_server_guard.dart';
import 'package:flutter_base/local_server/video_cache_manager.dart';
import 'package:flutter_base/utils/array_util.dart';
import 'package:flutter_base/utils/light_model.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

import '../../common/config/config.dart';
import '../../common/config/varibel_config.dart';
import '../../common/net2/net_manager.dart';
import '../../model/domain_source_model.dart';
import '../../model/user_info_model.dart';
import 'action.dart';
import 'state.dart';

LocalServerGuard localServerGuard;

Effect<SplashState> buildEffect() {
  return combineEffects(<Object, Effect<SplashState>>{
    Lifecycle.initState: _onInitData,
    SplashAction.jumpHomePage: _jumpHomePage,
    SplashAction.onAdvTag: _onAdvTag,
    Lifecycle.dispose: _dispose,
  });
}

///是否可进入首页
bool _canEntryHomePage = false;

///定时器
Timer _timer;

///正在进行跳转则不可再次执行
bool _jumping = false;

///初始化数据
void _onInitData(Action action, Context<SplashState> ctx) async {
  _doInit(action, ctx); // 异步，防止阻塞UI
}

Future _getNewDomain(Action action, Context<SplashState> ctx) async {
  //获取域名，如果本地不包含域名，则把本地域名更换一个
  var newDomain =
      await DetectLineManager().getDnsAddress(Config.GET_DOMAIN_URL);
  if (!Config.DEBUG &&
      TextUtil.isNotEmpty(newDomain) &&
      !Config.LINE_LIST.contains(newDomain)) {
    Config.LINE_LIST.removeAt(0);
    Config.LINE_LIST.add(newDomain);
    Config.DNS_CUSTOM = false;
    Config.DNS_IP = "";
    Config.DNS_ALREADY_USE_NEWDOMAIN = true;
    _doInit(action, ctx);
  }
}

/// 做初始化
void _doInit(Action action, Context<SplashState> ctx) async {
  /// 清除老的ua
  netManager.clearUserAgent();

  // 展示以前的广告数据，如果有的话
  _showPreviousAds(ctx);

  // 一直检查权限，
  await _checkPermissionAlways(ctx.context);
  // 一直检查网络，必须
  var line = await _checkNetAlways(action, ctx);
  assert(TextUtil.isNotEmpty(line));
  // 初始化网络层
  _initNetManager(line);

  Future.delayed(Duration(milliseconds: 200), () {
    /// 友盟埋点初始化
    if (Platform.isIOS) {
      initLocalNotification();
    }
    FijkLog.setLevel(FijkLogLevel.Silent);
  });

  // token或者设备id登陆,先登录，后升级，不然渠道一升级就没有量了
  UserInfoModel userInfo = await _devLogin(ctx.context);
  Config.lfCheatGuide = userInfo.lfCheatGuide;

  // 获取远程配置
  List<CheckVersionBean> listVersion = await _getRemoteConfig(ctx);



  // 检查更新
  await _checkUpdate(ctx.context, listVersion);
  //获取红点信息
  // Config.newMessageTip =  await netManager.client.checkMessageTip();
  // token或者设备id登陆，
  if (null != userInfo && userInfo?.uid != null) {
    ctx.state.loginSuccess = true;

    //开始定时器
    _startTimer(ctx);
    // 初始化localserver缓存
    _initLocalServer();
    await _playCount(ctx);
    await _pullRecommendVideo();

    //获取社区推荐标签列表
    _initCommunityRecommendTagList(ctx);
    // 获取撩吧数据
    //_initFuckIt(ctx);

    // 获取发现数据
    _initFind(ctx);

    _onGetTagsList(action, ctx);
  }
}

_initCommunityRecommendTagList(Context<SplashState> ctx) async {
  try {
    var model = await netManager.client.getTags(1);
    ctx.dispatch(SplashActionCreator.onCommunityList(model?.community ?? []));
  } catch (e) {
    l.d("_initCommunityRecommendTagList", "$e");
  }
}

///获取标签列表
Future _onGetTagsList(Action action, Context<SplashState> ctx) async {
  try {
    dynamic specialModel = await netManager.client.getTagsMarkList();
    dynamic tags = await netManager.client.getTagsList();
    await netManager.client.getAwVip();
  } catch (e) {
    l.d("getGroup", e);
  }
}

/// 初始化发现数据
void _initFind(Context<SplashState> ctx) async {
  try {
    var model = await netManager.client.getGoldCoinAreaList();
    ctx.dispatch(SplashActionCreator.onAreaList(model.list ?? []));
  } catch (e) {
    l.d("getGoldCoinAreaList", e.toString());
  }

  try {
    var findModel = await netManager.client.getFindWonderfulList(1, 10);
    ctx.dispatch(SplashActionCreator.onFindList(findModel.list ?? []));
  } catch (e) {
    l.d("getFindWonderfulList111", e.toString());
  }
}

/// 初始化撩吧数据
void _initFuckIt(Context<SplashState> ctx) async {
  try {
    // 获取标签页推荐数据
    // String reqDate;
    // try {
    //   reqDate = (await netManager.client.getReqDate()).sysDate;
    // } catch (e) {
    //   l.d("tag", "_onRefresh()...error:$e");
    // }
    // if (TextUtil.isEmpty(reqDate)) {
    //   // showToast(msg: "getDate fialed");
    //   reqDate = (netManager.getFixedCurTime()).toString();
    //   // return;
    // }
    // CommonPostRes commonPostRes =
    //     await netManager.client.getPostList(1, 20, '1', '0', reqDate);
    // List<VideoModel> list = commonPostRes.list ?? [];
    // ctx.dispatch(SplashActionCreator.onFuckIt(list));
  } catch (e) {}
}

//广告信息配置
Future _configAdsInfo(List<AdsInfoBean> adsList) async {
  adsList?.forEach((model) {
    if (model.cover != null) if (model.cover.startsWith("http")) {
      Uri uri = Uri.tryParse(model.cover);
      model.cover = path.join(Address.baseImagePath, uri.path);
    } else {
      model.cover = path.join(Address.baseImagePath, model.cover);
    }
  });
  return LocalAdsStore().setAdsList(adsList);
}

// 会员弹窗
Future _configPops(List<PopsBean> pops) async {
  pops?.forEach((model) {
    if (model.popBackgroundImage != null) if (model.popBackgroundImage
        .startsWith("http")) {
      Uri uri = Uri.tryParse(model.popBackgroundImage);
      model.popBackgroundImage = path.join(Address.baseImagePath, uri.path);
    } else {
      model.popBackgroundImage =
          path.join(Address.baseImagePath, model.popBackgroundImage);
    }
  });
  Config.pops = pops;
  // return LocalAdsStore().setAdsList(adsList);
}

_initNetManager(String host) {
  Address.baseHost = host;
  Address.baseApiPath = path.join(Address.baseHost, Address.API_PREFIX);
  Address.h5Url = path.join(Address.baseHost, Address.H5_SUFFIX);
  netManager.init(Address.baseApiPath);
}

///一直检查网络直到成功
Future<String> _checkNetAlways(Action action, Context<SplashState> ctx) async {
  // while (true) {
  var result = await new Connectivity().checkConnectivity();
  // 有网络,开始选线
  if (result != ConnectivityResult.none) {
    var line = await DetectLineManager().detectLineOnce();
    loadingDialog.dismiss();
    if (TextUtil.isNotEmpty(line)) return line;
  }
  //使用自定义阿里云DNS解析服务
  if (!Config.DNS_CUSTOM && !Config.DNS_ALREADY_USE_NEWDOMAIN) {
    Config.DNS_IP = "223.5.5.5";
    Config.DNS_CUSTOM = true;
    netManager.reset();
    return _checkNetAlways(action, ctx);
  } else {
    //自定义阿里云DNS仍然不行，弹框进入群聊
    await showDialog(
      barrierDismissible: false,
      context: ctx.context,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: AppColors.primaryColor,
              ),
              child: Container(
                margin: EdgeInsets.only(
                  left: Dimens.pt20,
                  right: Dimens.pt20,
                  top: Dimens.pt10,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("系统提示",style: TextStyle(color: Colors.white,fontSize: 18),),
                    SizedBox(height: 12),
                    Container(color: Colors.white.withOpacity(0.1), height: 1,),
                    SizedBox(height: 16),
                    EasyRichText(
                      "APP线路检测失败\n\n解决方案: \n\n"
                          "1.请检测您的网络是否正常，手机是否开了VPN或10分钟后再尝试访问。"
                          "\n2.前往官网地址 uapp.bio 下载最新版。"
                          "\n3.官方邮箱：qiyoushequ@gmail.com"
                          "\n4.前往Telegram海角社区官方交流群",
                      defaultStyle:TextStyle(
                          color: Colors.white
                      ),
                      patternList: [
                        EasyRichTextPattern(
                          targetString: EasyRegexPattern.webPattern,
                          urlType: 'web',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.white,
                          ),
                        ),
                        EasyRichTextPattern(
                          targetString: 'haijiao.fm',
                          urlType: 'web',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.white,
                          ),
                        ),
                        EasyRichTextPattern(
                          targetString: 'haijiao9999@gmail.com',
                          urlType: 'email',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.white,
                          ),
                        ),
                        EasyRichTextPattern(
                          targetString: 'APP线路检测失败',
                          urlType: '',
                          style: TextStyle(
                            //decoration: TextDecoration.underline,
                            color: Colors.white,
                          ),
                        ),
                        EasyRichTextPattern(
                          targetString: '解决方案',
                          urlType: '',
                          style: TextStyle(
                            //decoration: TextDecoration.underline,
                            color: Colors.white,
                            fontSize: Dimens.pt16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              safePopPage();
                              loadingDialog.show(ctx.context,
                                  message: "线路选择中...");
                              await _getNewDomain(action, ctx);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                                  color: Colors.white.withOpacity(0.3)
                              ),
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Text(
                                "切换线路",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Dimens.pt10,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              launchUrl("https://t.me/qiyoushequ");
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                                gradient: AppColors.linearBackGround,
                              ),
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Text(
                                "前往群聊",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  // }
}

/// 一������查权限如果用户没有同意
Future _checkPermissionAlways(BuildContext context) async {
  if (!Platform.isAndroid) return;
  while (true) {
    var status = await Permission.storage.request();

    if (status.isGranted) return;
    // 展示无权限，去设置的对话框
    bool val = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return NoPermissionDialog();
        });
    if (val ?? false) {
      // 跳转到应用配置界面
      openAppSettings();
    }
  }
}

/// 开启定时器
_startTimer(Context<SplashState> ctx) {
  const oneSec = const Duration(seconds: 1);
  var callback = (timer) => {
        if (ctx.state.countdownTime == 0)
          timer.cancel()
        else
          {
            ctx.state.countdownTime = ctx.state.countdownTime - 1,
            ctx.dispatch(
                SplashActionCreator.onCountDownTime(ctx.state.countdownTime))
          }
      };
  _timer = Timer.periodic(oneSec, callback);
}

///取出上次展示的广告
bool _isInAd = false;

_showPreviousAds(Context<SplashState> ctx) async {
  if (_isInAd) return;
  print("_showPreviousAds()....=======>in");
  _isInAd = true;
  List<AdsInfoBean> adsList = await getAdvByType(1);
  if (ArrayUtil.isNotEmpty(adsList)) {
    var index = Random().nextInt(adsList.length);
    print(
        "_showPreviousAds()....=======>begin show ad:${adsList[index]?.cover ?? ""}");
    ctx.dispatch(SplashActionCreator.showAds(adsList[index]));
    await ImageCacheManager().getSingleFile(adsList[index]?.cover ?? "");
  }
  _isInAd = false;
  print("_showPreviousAds()....=======>out");
}

///获取远程配置信息
Future<List<CheckVersionBean>> _getRemoteConfig(
    Context<SplashState> ctx) async {
  List<CheckVersionBean> checkVersionList;
  while (true) {
    if (checkVersionList != null) {
      break;
    }
    try {
      DomainSourceModel domainSourceModel =
          await netManager.client.getRemoteConfig(1, 50);

      Config.playGame = domainSourceModel.playGame ?? true;

      await _updateDomainInfo(ctx, domainSourceModel);
      await _configAdsInfo(domainSourceModel?.ads?.adsInfoList);
      await _configPops(domainSourceModel?.pops);

      ///配置公告
      Config.announcesMarqueeList = domainSourceModel.systemConfigList;
      Config.officeConfigLists = domainSourceModel.officeConfigLists;
      Config.rewardMoney = domainSourceModel.rewardMoney;
      Config.releaseMoney = domainSourceModel.releaseMoney;
      Config.userAwards = domainSourceModel.userAwards;
      Config.productBenefits = domainSourceModel.productBenefits;
      Config.hotPush = domainSourceModel.hotPush ?? [];
      Config.quickSearch = domainSourceModel.quickSearch ?? [];
      Config.aiUndressPrice = domainSourceModel.aiUndressPrice;
      Config.followNewsStatus = domainSourceModel.followNewsStatus;
      Config.messageNewsStatus = domainSourceModel.messageNewsStatus;
      Config.sendMsgPrice = domainSourceModel.sendMsgPrice;
      domainSourceModel.ads.adsInfoList.forEach((element) {
        if (element.position == 0) {
          Config.splashAds = element;
        }
      });

      /// 会员弹窗
      // Config.pops = domainSourceModel.pops;
      if (null == ctx.state.adsBean) {
        await _showPreviousAds(ctx);
      }
      checkVersionList = domainSourceModel.ver;
    } catch (e) {
      l.d('getRemoteConfig', e.toString());
      var result = await showConfirm(ctx.context,
          content: "获取配置信息失败${(e is ApiException) ? e.code : 1500}，是否重试?",
          showCancelBtn: true);
      if (!result) {
        break;
      }
    }
  }
  return checkVersionList;
}

///更新
_updateDomainInfo(
    Context<SplashState> ctx, DomainSourceModel domainSourceModel) async {
  //域名列表信息
  VariableConfig.totalWatch = domainSourceModel.totalWatch;
  VariableConfig.louFengH5 = domainSourceModel.louFengH5;

  VariableConfig.luckyDrawH5 = domainSourceModel.luckyDrawH5;
  VariableConfig.videoCollectionPrice = domainSourceModel.videoCollectionPrice;
  AdInsertManager.randomAds = domainSourceModel.ads.adsRandomList;
  AdInsertManager.randomVerAds = domainSourceModel.ads.adsVerRandomList;
  AdInsertManager.randomCommunityAds = domainSourceModel.ads.adsCommunityList;
  AdInsertManager.randomVideoTabAds = domainSourceModel.ads.adsVideoTabList;

  if (domainSourceModel.domainBuried.isNotEmpty == true) {
    Config.dataBuriedPoint = domainSourceModel.domainBuried;
  }

  String value = await lightKV.getString(Config.KEY_SERVER_DOMAIN) ?? "";
  if (value != null && value.isNotEmpty) {
    List<dynamic> localDomainList = convert.jsonDecode(value);
    for (String value in domainSourceModel.domain) {
      if (!localDomainList.contains(value)) {
        localDomainList.add(value);
      }
    }
    lightKV.setString(
        Config.KEY_SERVER_DOMAIN, convert.jsonEncode(localDomainList));
  } else {
    lightKV.setString(
        Config.KEY_SERVER_DOMAIN, convert.jsonEncode(domainSourceModel.domain));
  }
  //本地资源地址配置
  List<SourceBeanList> sourceList = domainSourceModel.sourceList;
  if (domainSourceModel.sourceList?.isEmpty ?? true) {
    String source = await lightKV.getString(Config.SOURCE_INFO) ?? "";
    if (source.isNotEmpty) {
      sourceList = convert.jsonDecode(source);
    }
  }
  for (SourceBeanList sourceBean in sourceList) {
    switch (sourceBean.type) {
      case "IMAGE":
        Address.baseImagePath = sourceBean.domain.first.url;
        break;
      // case "GROUP":
      //   Address.baseGroupUrl = sourceBean.domain.first.url;
      //   break;
      case "VID":
        if (Config.DEBUG && Config.OPEN_SOURCE) {
          Address.cdnAddress = Config.SOURCE_URL;
        } else {
          if(sourceBean.domain!=null){
            Address.cdnAddress = sourceBean.domain.first.url;
          }
        }
        if(sourceBean.domain!=null){
          Address.cdnAddressLists = sourceBean.domain;
          Address.currentDomainInfo = sourceBean.domain.first;
        }
        break;
      case "GUIDE":
        Address.groundURl = sourceBean.domain.first.url;
        break;
      case "PROXYRULE": //代理规则
        Address.proxyRuleUrl = sourceBean.domain.first.url;
        break;
      case "FAQ": //常见问题
        Address.commonQuestion = sourceBean.domain.first.url;
        break;
      case "ACT": //常见问题
        Address.activityUrl = sourceBean.domain.first.url;
        break;
      case "LAND": //落地页地址
        Address.landUrl = sourceBean.domain.first.url;
        break;
      case "AppStore": //福利中心应用中心
        Address.appCenterUrl = sourceBean.domain.first.url;
        break;
      case "GROUPEMAIl": // 邮箱
        Address.groupEmail = sourceBean.domain.first.url;
        break;
      case "BusinessCooperation": //商务合作
        Address.businessCooperation = sourceBean.domain.first.url;
        break;
      case "TitleTag": //精选标签随机选择
        Config.POST_TAG_RANDOM = sourceBean.domain.first.url.split(",");
        break;
      case "GROUP": //商务合作
        Config.groupTomato = sourceBean.domain.first.url;
        break;
      case "TELEGRAM": //精选标签随机选择
        Config.groupTelegram = sourceBean.domain.first.url;
        break;
    }
  }

  ///公告信息存储 只支持一个
  /*AdsBean adsBean = domainSourceModel.ads;
  if (adsBean?.announInfo?.isNotEmpty ?? false) {
    lightKV.setString(
        Config.ANNOUNCEMENT_INFO, convert.jsonEncode(adsBean.announInfo));
  } else {
    lightKV.setString(Config.ANNOUNCEMENT_INFO, "");
  }*/

  AdsBean adsBean = domainSourceModel.ads;
  if (adsBean?.announList?.isNotEmpty ?? false) {
    lightKV.setString(
        Config.ANNOUNCEMENT_INFO, convert.jsonEncode(adsBean.announList));
  } else {
    lightKV.setString(Config.ANNOUNCEMENT_INFO, "");
  }
}

///检查是否需要更新
Future _checkUpdate(
    BuildContext context, List<CheckVersionBean> versionList) async {
  if (versionList?.isEmpty ?? true) return;

  //存储更新信息,然后检测
  lightKV.setString(Config.UPDATE_INFO, convert.jsonEncode(versionList));

  String phoneStr = Platform.operatingSystem;
  CheckVersionBean phoneBean;
  for (CheckVersionBean bean in versionList) {
    if (bean.platform.toLowerCase() == phoneStr) {
      phoneBean = bean;
      break;
    }
  }
  if (phoneBean == null) return;
  //是否需要更新
  Map<String, dynamic> map = await checkUpdate();
  bool isNeedUpdate = map['isNeedUpdate'] ?? false;
  if (isNeedUpdate) {
    // 用户是否点了更新
    bool update = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return UpdateDialog(updateInfo: phoneBean);
        });
    if (!(update ?? false) && phoneBean.forcedUpdate) {
      await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      return;
    }
  }
}

///登录
Future<UserInfoModel> _devLogin(BuildContext context) async {
  String cutInfos = "";
  try {
    var channel = await getChannel();
    if (TextUtil.isNotEmpty(channel)) {
      // await showConfirm(context, title: "检测到渠道号:$channel");
      CutInfo cutInfo = CutInfo()..dc = channel;
      cutInfos = json.encode(cutInfo.toJson());
    } else {
      ClipboardData clipboardData =
          await Clipboard.getData(Clipboard.kTextPlain);
      if (TextUtil.isNotEmpty(clipboardData?.text)) {
        cutInfos = clipboardData.text;
      }
    }
  } catch (e) {
    l.d('getChannel', e.toString());
  }
  String deviceId = await getDeviceId();
  await netManager.userAgent(deviceId);

  UserInfoModel userInfo;
  while (true) {
    if (userInfo != null) {
      break;
    }

    userInfo = await GlobalStore.loginByDevice(deviceId, cutInfos);
    if (userInfo == null) {
      var result = await showConfirm(context,
          content: "登录失败，是否重试?", showCancelBtn: true);
      if (!result) {
        // 点了取消退出循环
        break;
      }
    }
  }
  return userInfo;
}

///非VIP用户 播放次数控制
_playCount(Context<SplashState> ctx) async {
  ///获取播放次数
  if (TextUtil.isNotEmpty(GlobalStore.getMe()?.vipExpireDate) ?? false) {
    DateTime dateTime = DateTime.parse(GlobalStore.getMe()?.vipExpireDate);
    if (dateTime.isAfter(netManager.getFixedCurTime())) {
      return;
    }
  }
  // BaseResponse response = await getPlayStatus();
  try {
    WatchCount watchObj = await netManager.client.getPlayStatus();
    // Provider.of<PlayCountModel>(ctx.context, listen: false)
    //     .setPlayCnt();
    playCountModel.setPlayCnt(watchObj?.watchCount ?? 0);
    String result = await lightKV.getString(Config.LOOKED_VIDEO_LIST);
    if (result != null && result.isNotEmpty) {
      List<dynamic> lookedVideoList = convert.jsonDecode(result);
      int day = (netManager.getFixedCurTime()).day;
      lookedVideoList.forEach((model) {
        LocalVideoModel localVideoModel = LocalVideoModel.fromMap(model);
        if (localVideoModel.day == day) {
          VariableConfig.playedVideoList.add(localVideoModel);
        }
      });
      lightKV.setString(Config.LOOKED_VIDEO_LIST,
          convert.jsonEncode(VariableConfig.playedVideoList));
    }
  } catch (e) {
    l.d('getPlayStatus', e.toString());
    showToast(msg: Lang.COUNT_GET_ERROR);
  }
}

///header动态配置
Future<Map<String, dynamic>> _headerBuilder(Uri uri) async {
  Map<String, String> header = {};
  header["Authorization"] = await netManager.getToken();
  header["User-Agent"] = await netManager.userAgent();
  header['x-api-key'] = await SignatureInterceptor.sign(uri.path);
  return header;
}

///处理secret文件加密的密钥
_handleTTLSec(HttpRequest request) async {
  if (VariableConfig.secContent != null) {
    request.response.add(VariableConfig.secContent);
    await request.response.flush();
    await request.response.close();
    return;
  }
  String requestPath = "${Address.baseApiPath}${Address.SECRET_SUFFIX}";
  final ret = await DioCli().getBytes(requestPath);
  if (ret.err != null) {
    try {
      request.response.statusCode = HttpStatus.internalServerError;
    } catch (e) {
      l.d("error", e);
    }
    await request.response.close();
    return;
  }
  final response = ret.data;
  if (response.statusCode == HttpStatus.ok) {
    VariableConfig.secContent = response.data;
    request.response.add(VariableConfig.secContent);
    await request.response.flush();
  } else {
    request.response.statusCode = HttpStatus.internalServerError;
  }
  await request.response.close();
}

///拉取推荐视频
_pullRecommendVideo() async {
  //清除视频缓存
  var list = await recommendListModel.refreshList();
  _canEntryHomePage = true;
}

/// 初始��本地服务
Future _initLocalServer() async {
  //启动本地服务并配置registry
  CacheServer cacheServer =
      CacheServer(cacheManager: VideoCacheManager(), openSubManager: true);
  // 启动localserver守护进程
  localServerGuard = LocalServerGuard(cacheServer);
  await localServerGuard.run();
  // Uri uri = Uri.tryParse(Address.baseHost);
  // String m3u8host = "${uri.scheme}://${uri.host}:${uri.port}";
  // m3u8过滤,设置请求地址
  cacheServer.addReqFilter(LOCAL_M3U8_FILTER, Address.baseHost,
      pathPrefix: Address.API_PREFIX + Address.VIDEO_SUFFIX,
      hb: _headerBuilder);
  // ts 过滤，设置ts请求地址
  cacheServer.addReqFilter(LOCAL_TS_FILTER, Address.cdnAddress);
  //其余任意文件拦截
  cacheServer.addReqFilter(LOCAL_ALL_FILTER, Address.baseImagePath);
  cacheServer.registerErrCallBack(failedCallback);
  // cacheServer.addReqFilter(".mp3", Address.cdnAddress);
  // 设置闲时缓存回调函数
  cacheServer.onLocalServerIdel = recommendListModel.getNeedCachedUrl;
  cacheServer.onJoinSubCache = CachedVideoStore().inCachedList;
  // 这个ttl是m3u8列表里面的一个加密的key，要放到外面请求
  cacheServer.addCustomResponse(Config.M3U8_KEY_SECRET, _handleTTLSec);
}

int _failedCnt = 0;

failedCallback(dynamic d) {
  _failedCnt++;
  if (_failedCnt == 6) {
    _failedCnt = 0;

    ///同一个IP不停重试弹出提示太多，先注释
    //showToast(msg: "数据请求失败的次数过多:$e");
  }
}

///跳转到主页面
_jumpHomePage(Action action, Context<SplashState> ctx) async {
  if (!_canEntryHomePage || _jumping || (ctx.state.countdownTime ?? 3) > 0) {
    return;
  }
  _jumping = true;
  Map<String, dynamic> arguments = {
    'list': ctx.state.community,
    'findList': ctx.state.findList,
    'areaList': ctx.state.areaList,
  };
  Navigator.of(ctx.context).popAndPushNamed(PAGE_HOME, arguments: arguments);
}

///跳转外部浏览器
_onAdvTag(Action action, Context<SplashState> ctx) async {
  AdsInfoBean adsInfoBean = action.payload;
  JRouter().handleAdsInfo(adsInfoBean.href, id: adsInfoBean.id);
}

_dispose(Action action, Context<SplashState> ctx) {
  ctx.state.swipeController?.dispose();
  if (_timer?.isActive ?? false) {
    _timer?.cancel();
  }
}
