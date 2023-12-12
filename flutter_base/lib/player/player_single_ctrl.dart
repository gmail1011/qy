///全局播放器，用于预览视频；当av和原创播放的时候，要过来释放这个控制器
import 'package:flutter/material.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/local_server/local_server.dart';
import 'package:flutter_base/player/ijk_base_video_controler.dart';
import 'package:flutter_base/utils/log.dart';

///播放器的单一控制器
///连接播放器和localserver的部分
IjkBaseVideoController _curPlayCtrl;

/// 获取播放器控制器
IjkBaseVideoController getCtrl(String url, String uniqueId,
    {var srcModel,
    ValueChanged<IjkBaseVideoController> updateCallBack,
    ValueChanged<IjkBaseVideoController> onComplete,
    ValueChanged<IjkBaseVideoController> onRelease,
    bool loop,String realUrl}) {
  IjkBaseVideoController curPlayCtrl = _curPlayCtrl;
  assert(TextUtil.isNotEmpty(url));
  var localUrl = CacheServer().getLocalUrl(url);
  //重复地址直接返回
  if (curPlayCtrl != null &&
      !curPlayCtrl.isDisposed &&
      localUrl == curPlayCtrl.sourceUrl &&
      curPlayCtrl.uniqueId == uniqueId) {
    l.i("getCtrl",
        "相同地址播放器不需要释放:${curPlayCtrl?.sourceUrl} uniqueId:${curPlayCtrl?.uniqueId}");
    return curPlayCtrl;
  }

  //释放上一个控制器
  disposePlayCtrl(curPlayCtrl);
  curPlayCtrl = IjkBaseVideoController.network(realUrl, uniqueId,
      srcModel: srcModel,
      onCompleted: onComplete,
      onRelease: onRelease,
      updateCallBack: updateCallBack,
      loop: loop);
  _curPlayCtrl = curPlayCtrl;
  l.i("getCtrl",
      "新建播放器:${curPlayCtrl?.sourceUrl} uniqueId:${curPlayCtrl?.uniqueId}");
  return curPlayCtrl;
}

/// 手动释放播放器
/// [controller] 要释放的播放器
/// [inner] 是否从UI内部释放，如果是
void disposePlayCtrl(IjkBaseVideoController controller, [bool inner = true]) {
  // if (controller != null && !controller.isDisposed) {
  //   controller.preDisposeDel?.call();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     l.i("disposeCurCtrl", "手动释放预览播放器：${controller?.dataSource}");
  //     controller?.dispose();
  //     controller = null;
  //   });
  // }

  //释放上一个控制器
  if (controller != null && !controller.isDisposed) {
    if (inner) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          l.i("getCtrl",
              "inner释放播放器:${controller?.sourceUrl} uniqueId:${controller?.uniqueId}");
          // autoPlayModel.curPlayCtrl = null;
          controller?.dispose();
          controller = null;
        });
      });
    } else {
      // autoPlayModel.setCurPlayCtrl(null);
      _curPlayCtrl = null;
      try {
        l.i("getCutl",
            "手动释放预览播放器:${controller?.dataSource} uniqueId:${controller?.uniqueId}");
        controller?.dispose();
        controller = null;
      } catch (e) {
        l.e("getCutl", "disposePlayCtrl()...e:$e");
      }
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   l.i("getCutl",
      //       "手动释放预览播放器:${controller?.sourceUrl} uniqueId:${controller?.uniqueId}");
      //   controller?.dispose();
      //   controller = null;
      // });
    }
  }
}
