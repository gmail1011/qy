import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:path/path.dart' as path;
import 'package:visibility_detector/visibility_detector.dart';

import 'image_cache_manager.dart';

enum ImgType { avatar, cover, common, audiobook, vertical }

class CustomNetworkImage extends CachedNetworkImage {
  CustomNetworkImage({
    @required String imageUrl,
    double width,
    double height,
    BoxFit fit,
    Widget placeholder,
    Widget errorWidget,
    ImgType type,
    bool fullImg = false,
    bool isGauss = false,
    bool isCliecp = false,
    double borderRadius,
  }) : super(
            cacheManager: ImageCacheManager(),
            imageUrl: getImagePath(
              imageUrl,
              fullImg,
              isGauss,
              width: width ?? double.infinity,
              height: height ?? double.infinity,
            ),
            imageBuilder: (context, imageProvider) => () {
                  if (imageUrl == null ||
                          imageUrl.isEmpty /* ||
                      HttpManager().networkResult == ConnectivityResult.none*/
                      ) {
                    return placeholder ??
                        // placeHolder(
                        //     type, width, height, isCliecp, borderRadius);
                        placeHolderNew(width, height, type );
                  }

                  ImageCacheManager image = new ImageCacheManager();

                  return Stack(
                    children: <Widget>[
                      TextUtil.isEmpty(imageUrl)
                          ? placeholder ??
                              // placeHolder(
                              //     type, width, height, isCliecp, borderRadius)
                              placeHolderNew(width, height, type)
                          : VisibilityDetector(
                              key: Key(imageUrl),
                              onVisibilityChanged: (visibleInfo) {
                                if (visibleInfo.visibleFraction == 0) {
                                  //  image.store.emptyMemoryCache();
                                  // evictImage(imageUrl);

                                  //PaintingBinding.instance.imageCache.clear();

                                  CachedNetworkImage.evictFromCache(
                                          getImagePath(imageUrl, fullImg, isGauss, width: width ?? 0, height: height ?? 0))
                                      .then((value) {
                                    if (value) {}
                                  });
                                }
                              },
                              child: Image(
                                image: CachedNetworkImageProvider(
                                  getImagePath(imageUrl, fullImg, isGauss, width: width ?? 0, height: height ?? 0),
                                  cacheManager: image,
                                ),
                                fit: fit ?? BoxFit.cover,
                                width: width ?? double.infinity,
                                height: height ?? double.infinity,
                              ),
                            )
                    ],
                  );
                }(),
            placeholder: (context, url) => placeholder ?? placeHolderNew(width, height, type),
            // placeHolder(type, width, height, isCliecp, borderRadius),
            width: width ?? double.infinity,
            height: height ?? double.infinity,
            placeholderFadeInDuration: Duration(milliseconds: 500),
            fit: fit ?? BoxFit.fitWidth,
            fadeInCurve: Curves.linear,
            fadeOutCurve: Curves.linear,
            //memCacheWidth: ,
            fadeInDuration: Duration(milliseconds: 100),
            fadeOutDuration: Duration(milliseconds: 100),
            errorWidget: (context, url, error) => () {
                  return (errorWidget ?? placeholder) ??
                      // placeHolder(type, width, height, isCliecp, borderRadius);
                      placeHolderNew(width, height, type);
                }());
}

void evictImage(String url) {
  //String urls =  CacheServer().getLocalUrl(url);
  final CachedNetworkImageProvider provider = CachedNetworkImageProvider(url);
  provider.evict().then<void>((bool success) {
    if (success) debugPrint('removed image!');
  });
}

String getImagePath(String imgPath, bool fullImg, bool isGauss, {double width, double height}) {
  if (TextUtil.isEmpty(imgPath)) {
    //l.e("image", "getImagePath()...imgPath is empty",
    // stackTrace: StackTrace.current);
    return "";
  }
  if (imgPath.startsWith("http") || imgPath.startsWith("https")) {
    return imgPath;
  }

  ///需要大图且不高斯
  if (fullImg && !isGauss) {
    imgPath = path.join(Address.baseImagePath, imgPath);
    return imgPath;
  }
  String rootPath = path.join(Address.baseImagePath, "imageView/1");
  if (!fullImg && !width.isInfinite && !width.isNaN && height.isNaN && height.isInfinite) {
    rootPath = path.join(rootPath, "w/$width/h/$height");
  }
  if (isGauss) {
    rootPath = path.join(rootPath, "s/${Config.GAUSS_VALUE}");
  }
  rootPath = path.join(rootPath, imgPath);
  return rootPath;
}

// Widget placeHolder(
//   ImgType type,
//   double width,
//   double height,
//   bool isCliecp,
//   double borRadius,
// ) {
//   type == null ? type = ImgType.cover : type = type;
//
//   return isCliecp
//       ? ClipRRect(
//           borderRadius: BorderRadius.all(Radius.circular(borRadius)),
//           child: Image(
//             image: () {
//               if (type != null && type == ImgType.cover) {
//                 return AssetImage("assets/weibo/loading_horizetol.png");
//               } else if (type != null && type == ImgType.avatar) {
//                 return AssetImage("assets/weibo/loading_normal.png");
//               } else if (type != null && type == ImgType.audiobook) {
//                 return AssetImage(AssetsImages.AUDIOBOOK_DF);
//               } else if (type != null && type == ImgType.vertical) {
//                 return AssetImage("assets/weibo/loading_vertical.png");
//               }
//               return AssetImage("assets/weibo/loading_horizetol.png");
//             }(),
//             width: width ?? double.infinity,
//             height: height ?? double.infinity,
//             fit: BoxFit.fitWidth,
//           ),
//         )
//       : Image(
//           image: () {
//             if (type != null && type == ImgType.cover) {
//               return AssetImage("assets/weibo/loading_horizetol.png");
//             } else if (type != null && type == ImgType.avatar) {
//               return AssetImage("assets/weibo/loading_normal.png");
//             } else if (type != null && type == ImgType.audiobook) {
//               return AssetImage(AssetsImages.AUDIOBOOK_DF);
//             } else if (type != null && type == ImgType.vertical) {
//               return AssetImage("assets/weibo/loading_vertical.png");
//             }
//             return AssetImage("assets/weibo/loading_horizetol.png");
//           }(),
//           width: width ?? double.infinity,
//           height: height ?? double.infinity,
//           fit: BoxFit.fitWidth,
//         );
// }

Widget placeHolderNew(double width, double height, ImgType type,) {
  if(type == ImgType.avatar){
    return Container(
      alignment: Alignment.center,
      child: Image.asset(
        "assets/images/avatar.png",
        width: width ?? 24,
        height: width ?? 24,
      ),
    );
  }else {
    return Container(
      alignment: Alignment.center,
      child: Image.asset(
        "assets/weibo/loading_normal.png",
        width: width == null ? 53 : (width / 2),
        height: width == null ? 43 : (width / 2) * (285 / 235),
      ),
    );
  }
}
