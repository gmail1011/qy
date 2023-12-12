library image_loader;

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/image/image_cache_manager.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_base/player/player_util.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'custom_network_image.dart';

/// 加载图片和svg的处理函数
enum ImageType {
  IMAGE_FILE,
  IMAGE_ASSETS,
  IMAGE_SVG,
  IMAGE_NETWORK_HTTP,
  IMAGE_NETWORK_SOCKET, // 使用IMsocket下载网络图片
  IMAGE_PHOTO,
  IMAGE_PRECACHE_SVG_ASSETS, // 预加载asset下面的svg图片;
}

class ImageLoader {
  ImageLoader.withP(
    this.type, {
    @required this.address,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.placeholder,
  });

  final String address;
  final double width;
  final double height;
  final BoxFit fit;
  final Color color;
  final ImageType type;
  final Widget placeholder;

  Widget load() {
    switch (this.type) {
      case ImageType.IMAGE_FILE:
        if (TextUtil.isNotEmpty(address)) {
          // precacheImage();
          return Image.file(
            File(address),
            width: width,
            height: height,
            fit: fit,
            color: color,
          );
        }
        break;
      case ImageType.IMAGE_ASSETS:
        if (TextUtil.isNotEmpty(address)) {
          return Image.asset(
            address,
            width: width,
            height: height,
            fit: fit,
            color: color,
          );
        }
        break;
      case ImageType.IMAGE_NETWORK_HTTP:
        if (TextUtil.isNotEmpty(address)) {
          return CustomNetworkImage(
            imageUrl: address,
            width: width,
            height: height,
            placeholder: placeholder,
            fit: fit,
            // imageBuilder: imageBuilder,
          );
        }
        break;
      case ImageType.IMAGE_NETWORK_SOCKET:
        break;
      case ImageType.IMAGE_SVG:
        if (TextUtil.isNotEmpty(address)) {
          // SvgPicture.string(bytes);
          // var ai =   AssetImage('asset/test.svg');
          return SvgPicture.asset(
            address,
            width: width,
            height: height,
            fit: fit,
            // placeholderBuilder: (context) =>
            //     SpinKitFadingCircle(size: width, color: Colors.black),
            color: color,
          );
        }
        break;
      case ImageType.IMAGE_PHOTO:
        break;
      default:
        break;
    }
    return null;
  }

  /// 预加载图片
  preload(BuildContext context) {
    switch (type) {
      case ImageType.IMAGE_PRECACHE_SVG_ASSETS:
        var picProvider = ExactAssetPicture(
            SvgPicture.svgStringDecoder, address,
            colorFilter: getColorFilter(color, BlendMode.srcIn));
        precachePicture(picProvider, context);
        break;
      default:
        break;
    }
  }

  static preloadVideoImg(VideoModel videoModel) async {
    if (TextUtil.isEmpty(videoModel?.cover)) return;
    var resolution = configVideoSize(screen.screenWidth, screen.screenHeight,
        videoModel.resolutionWidth(), videoModel.resolutionHeight(), true);
    var remoteImgUrl = getImagePath(
      videoModel.cover,
      false,
      false,
      width: resolution.videoWidth ?? double.infinity,
      height: resolution.videoHeight ?? double.infinity,
    );
//    l.i("preload", "开始缓存网络图片url:$remoteImgUrl");
    ImageCacheManager().getSingleFile(remoteImgUrl).then((f) {
//      l.i("preload",
//          "preloadVideoImg()...缓存网络图片成功url:$remoteImgUrl ==> ${f.path}");
    }).catchError((e) {
//      l.e("preload", "preloadVideoImg()...缓存网络图片失败url:$remoteImgUrl ==> $e");
    });
  }
}

ColorFilter getColorFilter(Color color, BlendMode colorBlendMode) =>
    color == null
        ? null
        : ColorFilter.mode(color, colorBlendMode ?? BlendMode.srcIn);
