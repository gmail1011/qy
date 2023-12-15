import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageFalleryView extends StatefulWidget{
  PageController pageController  =PageController();
  List<String> bigImageList=[""];
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
  
  
}
class ImageFalleryViewState extends State<ImageFalleryView>{
  int index;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return PhotoViewGallery.builder(
     scrollPhysics: BouncingScrollPhysics(), // 滑动到边界的交互 默认Android效果
     scrollDirection: Axis.vertical,//是否逆转滑动的阅读顺序方向 默认false,true水平的话，图片从右向左滑动
     builder: _buildItem,// 图片构造器
     itemCount: widget.bigImageList.length,  // 图片数量

     backgroundDecoration:// 背景样式自定义
         BoxDecoration(color: Colors.black87),
     scaleStateChangedCallback: (photoViewScaleState){
       // 用户双击图片放大缩小时的回调
     },
     enableRotation:false,//是否支持手势旋转图片

     customSize: MediaQuery.of(context).size, //定义图片默认缩放基础的大小,默认全屏 MediaQuery.of(context).size
     // allowImplicitScrolling: true,//是否允许隐式滚动 提供视障人士用的一个字段 默认false
     pageController: widget.pageController, // 切换图片控制器
     onPageChanged: (index) {
       // 图片切换回调
       setState(() {
         this.index = index + 1;
       });
     },
   );


  }
  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final String item = widget.bigImageList[index];
    return PhotoViewGalleryPageOptions(
      // 图片加载器 支持本地、网络
      imageProvider: NetworkImage(item),
      // 初始化大小 全部展示
      initialScale: PhotoViewComputedScale.contained,
      // 最小展示 缩放最小值
      minScale: PhotoViewComputedScale.contained * 0.5,
      // 最大展示 缩放最大值
      maxScale: PhotoViewComputedScale.covered * 4,
    );
  }

}