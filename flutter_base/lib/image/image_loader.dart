// import 'dart:io';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_base/utils/text_util.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// /// 加载图片和svg的处理函数
// enum ImageType {
//   IMAGE_FILE,
//   IMAGE_ASSETS,
//   IMAGE_SVG,
//   IMAGE_NETWORK_HTTP,
//   IMAGE_NETWORK_SOCKET, // 使用IMsocket下载网络图片
//   IMAGE_PHOTO,
//   IMAGE_PRECACHE_SVG_ASSETS, // 预加载asset下面的svg图片;
// }

// class ImageLoader {
//   static BaseCacheManager _defCacheManager;
//   static LoadingErrorWidgetBuilder _errorWidget;
//   static PlaceholderWidgetBuilder _placeholder;
//   ImageLoader.withP(
//     this.type, {
//     this.package,
//     this.address,
//     this.width,
//     this.height,
//     this.fit = BoxFit.cover,
//     this.color,
//     this.placeholder,
//     this.colorBlendMode,
//   });

//   /// 初始化ImageLoader需要的cacheManager
//   static void init(BaseCacheManager cacheManager,
//       [PlaceholderWidgetBuilder placeholder,
//       LoadingErrorWidgetBuilder errorWidget]) {
//     _defCacheManager = cacheManager;
//     _placeholder = placeholder;
//     _errorWidget = errorWidget;
//   }

//   final String address;
//   final double width;
//   final double height;
//   final BoxFit fit;
//   final Color color;
//   final ImageType type;
//   final PlaceholderWidgetBuilder placeholder;
//   final String package;
//   final BlendMode colorBlendMode;

//   Widget load() {
//     switch (this.type) {
//       case ImageType.IMAGE_FILE:
//         if (TextUtil.isNotEmpty(address)) {
//           return Image.file(
//             File(address),
//             width: width,
//             height: height,
//             fit: fit,
//             color: color,
//           );
//         }
//         break;
//       case ImageType.IMAGE_ASSETS:
//         if (TextUtil.isNotEmpty(address)) {
//           return Image.asset(
//             address,
//             width: width,
//             height: height,
//             fit: fit,
//             color: color,
//             package: package,
//           );
//         }
//         break;
//       case ImageType.IMAGE_NETWORK_HTTP:
//         if (TextUtil.isNotEmpty(address)) {
//           return CachedNetworkImage(
//             errorWidget: _errorWidget ??
//                 (context, url, error) => Icon(
//                       Icons.error,
//                     ),
//             cacheManager: _defCacheManager,
//             imageUrl: address,
//             width: width,
//             height: height,
//             fit: fit,
//             color: color,
//             colorBlendMode: colorBlendMode ?? BlendMode.srcIn,
//             fadeOutDuration: Duration(milliseconds: 100),
//             placeholder: placeholder ?? _placeholder,
//             // placeholder: (context, url) => SpinKitFadingCircle(
//             //   size: width,
//             //   color: Colors.black,
//             // ),
//           );
//         }
//         break;
//       case ImageType.IMAGE_NETWORK_SOCKET:
//         break;
//       case ImageType.IMAGE_SVG:
//         if (TextUtil.isNotEmpty(address)) {
//           // SvgPicture.string(bytes);
//           // var ai =   AssetImage('asset/test.svg');
//           return SvgPicture.asset(
//             address,
//             width: width,
//             height: height,
//             fit: fit,
//             // placeholderBuilder: (context) =>
//             //     SpinKitFadingCircle(size: width, color: Colors.black),
//             color: color,
//           );
//         }
//         break;
//       case ImageType.IMAGE_PHOTO:
//         break;
//       default:
//         break;
//     }
//     return Container();
//   }

//   /// 预加载svg 图片
//   preload(BuildContext context) {
//     switch (type) {
//       case ImageType.IMAGE_PRECACHE_SVG_ASSETS:
//         var picProvider = ExactAssetPicture(
//             SvgPicture.svgStringDecoder, address,
//             colorFilter:
//                 getColorFilter(color, colorBlendMode ?? BlendMode.srcIn));
//         precachePicture(picProvider, context);
//         break;
//       default:
//         break;
//     }
//   }
// }

// ColorFilter getColorFilter(Color color, BlendMode colorBlendMode) =>
//     color == null
//         ? null
//         : ColorFilter.mode(color, colorBlendMode ?? BlendMode.srcIn);
