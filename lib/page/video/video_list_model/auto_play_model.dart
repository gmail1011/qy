import 'package:flutter/cupertino.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_base/ext_core/dart_stack.dart';
import 'package:flutter_base/player/ijk_base_video_controler.dart';
import 'package:flutter_base/player/player_single_ctrl.dart';
import 'package:flutter_base/utils/log.dart';

/// 视频列表播放类型(NORMAL)关注，推荐和二级播放页面
enum VideoListType { NONE, FOLLOW, RECOMMEND, SECOND }

const KEY_VIDEO_LIST_TYPE = "_key_video_list_type";

final AutoPlayModel autoPlayModel = AutoPlayModel();

class ExtVideoListType {
  VideoListType type;
  String uniqueId;
  ExtVideoListType(this.type, [this.uniqueId]);
}

///推荐界面播放控制器
class AutoPlayModel with ChangeNotifier {
  static AutoPlayModel _sInstance;
  factory AutoPlayModel() {
    if (null == _sInstance) _sInstance = AutoPlayModel._();
    return _sInstance;
  }
  AutoPlayModel._() {
    _stack.push(ExtVideoListType(VideoListType.RECOMMEND));
  }

  // 当前播放控制器
  IjkBaseVideoController _curPlayCtrl;
  // 设置非home enable限制
  bool _enable = true;

  /// 为了二级播放页面可以有多层翻动，是用栈最多支持20层
  var _stack = DartStack<ExtVideoListType>(20);

  //是否当前一个播放的是广告
  bool isAd = false;

  IjkBaseVideoController get curPlayCtrl => _curPlayCtrl;

  setCurPlayCtrl(IjkBaseVideoController ctrl) {
    _curPlayCtrl = ctrl;
    if (null == ctrl) return;
    if (ctrl.srcModel is VideoModel &&
        extVideoListType.type == VideoListType.RECOMMEND) {
      var curVideo = ctrl.srcModel as VideoModel;
      if (isAd != curVideo.isAd()) {
        isAd = curVideo.isAd();
        // 通知右边滑动进入广告模式
        notifyListeners();
      }
    }
  }

  // 停止其他播放列表列表开始这个播放列表，一般这个和生命周期挂钩
  registVideoListType(ExtVideoListType type) {
    l.i("VideoListTypeModel", "registVideoListType()...${type.type}");
    if (type.type == VideoListType.SECOND) {
      _stack.push(type);
    } else {
      _stack.clearAndPush(type);
    }
  }

  popVideoListType() {
    //二级播放列表可以一直叠加在上面
    if (_stack.top?.type == VideoListType.SECOND) _stack.pop();
  }

  // 当前播放列表的类型
  ExtVideoListType get extVideoListType => _stack.top;

  //home 设置enable限制,enable 只对一级播放列表有效
  setEnable(bool enable) {
    this._enable = enable;
  }

  // 二级播放页面不受主页homeindex切换的影响；
  bool enable() {
    VideoListType curType = extVideoListType.type;
    // 扩展首页的下面几个tab到二级页面
    l.i("autoPlayModel", "enable()...curtype:$curType");
    var extEnable = (_enable || curType == VideoListType.SECOND);
    return extEnable;
  }

  ///此时自动显示播放器，这个是自主控制
  void startAvailblePlayer() {
    if (enable()) {
      notifyListeners();
      // curPlayCtrl.notifyListeners();
      // 控制播放器是否显示的UI
       //curPlayCtrl?.start();
    }
  }

  addExListener(BuildContext ctx, VoidCallback listener) {
    if (null == listener) return;
    addListener(listener);
  }

  removeExListener(BuildContext ctx, VoidCallback listener) {
    if (null == listener) return;
    removeListener(listener);
  }

  /// 用户主动刷新播放器，比如用户是否购买成功s
  // void refreshPlayer() {
  //   if (null != curPlayCtrl) {
  //     curPlayCtrl?.refresh();
  //   } else {
  //     l.e("autoPlayModel", "refreshPlayer()... 没有找到当前的播放器");
  //   }
  // }

  /// 获取正在播放的uniqueId
  String get curUniqueId => curPlayCtrl?.uniqueId;

  /// 获取这在播放的本地地址127.0.0.xxx/sadlkf.ts
  String get curDataSource => curPlayCtrl?.sourceUrl;

   /// 暂停所有页面
   void pauseAll() {
     // 将所有的播放ctrl控制器弄成pause
     l.i("autoPlayModel",
         "开始暂停播放器:${curPlayCtrl?.sourceUrl} status:${curPlayCtrl?.getStatus()}");
     if (curPlayCtrl?.isPlaying ?? false) curPlayCtrl?.pause();
   }

  /// 暂停所有页面
  void playAll() {
    // 将所有的播放ctrl控制器弄成pause
    l.i("autoPlayModel",
        "开始暂停播放器:${curPlayCtrl?.sourceUrl} status:${curPlayCtrl?.getStatus()}");
    if (curPlayCtrl?.isPlaying ?? false) curPlayCtrl?.start();
  }

     /// 暂停所有页面
   void playIfNeed() {
     // 将所有的播放ctrl控制器弄成pause
     l.i("autoPlayModel",
         "开始播放播放器:${curPlayCtrl?.sourceUrl} status:${curPlayCtrl?.getStatus()}");
      if (curPlayCtrl?.isPlayable() ?? false) curPlayCtrl?.start();
   }

  // 释放所有播放器
  void disposeAll() {
    if (curPlayCtrl?.isPlaying ?? false) curPlayCtrl?.pause();
    l.i("autoPlayModel", "disposeAll()...");
    disposePlayCtrl(curPlayCtrl, false);
  }
}
