import 'package:flutter/cupertino.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/page/search/search_page/page.dart';
import 'package:flutter_app/page/video/video_publish/page.dart';
import 'package:flutter_app/page/video/video_publish/state.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:get/route_manager.dart' as Gets;


class HjllPublishPostViewWidget extends StatelessWidget {

  HjllPublishPostViewWidget();

  @override
  Widget build(BuildContext context) {
     return Container(
       padding: EdgeInsets.only(top: 17),
       decoration: BoxDecoration(
         borderRadius: BorderRadius.only(topLeft: Radius.circular(7),topRight:  Radius.circular(7)),
         color: Color.fromRGBO(31, 31, 31, 1),
       ),
       child: Column(
         children: [
           Row(
             children:[
               Expanded(child: Stack(
                 alignment: Alignment.center,
                 children: [
                   Text("选择发布类型",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 16),),
                   Positioned(
                     right: 22,
                     top: 0,
                     child: GestureDetector(
                       child: Image.asset("assets/weibo/comment_close.png",width: 24,height: 24,),
                       onTap: (){
                         safePopPage();
                       },
                     ),)
                 ],
               ),)
             ]
           ),
           SizedBox(height: 25,),
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               SizedBox(width: 65,),
               GestureDetector(
                 child:  Column(
                      children: [
                          Image.asset("assets/weibo/icon_post_image.png",width: 40,height: 40,),
                          SizedBox(height: 8),
                          Text("图片",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 14),),
                      ],
                  ),
                 onTap: (){
                   _publishPostEvent(0);
                 },
               ),
               Expanded(child: SizedBox()),
               GestureDetector(
                 child:    Column(
                   children: [
                     Image.asset("assets/weibo/icon_post_video.png",width: 40,height: 40,),
                     SizedBox(height: 8),
                     Text("视频",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 14),),
                   ],
                 ),
                 onTap: (){
                   _publishPostEvent(1);
                 },
               ),
               Expanded(child: SizedBox()),
               GestureDetector(
                 child:  Column(
                   children: [
                     Image.asset("assets/weibo/icon_post_text_image.png",width: 40,height: 40,),
                     SizedBox(height: 8),
                     Text("图文",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 14),),
                   ],
                 ),
                 onTap: (){
                   _publishPostEvent(2);
                 },
               ),
               SizedBox(width: 65,),
             ],
           )
         ],
       ) ,
     );
  }

  _publishPostEvent(int index){
    Map<String, dynamic> map;
    if (index == 0) {
      map = {
        'type': UploadType.UPLOAD_IMG,
        'pageType':0,
      };
    } else if (index == 1) {
      map = {
        'type': UploadType.UPLOAD_VIDEO,
        'pageType':1
      };
    } else {
      map = {
        'type': UploadType.UPLOAD_IMG,
        'pageType':2
      };
    }
    Gets.Get.to(VideoAndPicturePublishPage().buildPage(map), opaque: false).then((value) => safePopPage());
  }
}
