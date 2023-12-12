import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/image/image_cache_manager.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:path/path.dart' as path;

class BigImageViewPage extends StatefulWidget {
  String imageUrl;
  BigImageViewPage({this.imageUrl});

  @override
  State<BigImageViewPage> createState() => _BigImageViewPageState();
}

class _BigImageViewPageState extends State<BigImageViewPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       appBar: getCommonAppBar("查看大图"),
       body: Container(
         width: screen.screenWidth,
         height: screen.screenHeight,
         child:  CachedNetworkImage(
           imageUrl: path.join(
               Address.baseImagePath ?? '',
               widget.imageUrl),
           fit: BoxFit.fitWidth,
           cacheManager: ImageCacheManager(),
         ),
       ),
    );
  }
}
