import 'package:flutter/material.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'SinglePicItem.dart';
import 'SingleVideoItem.dart';

class VideoAndPicSwiperPage extends StatefulWidget{
  List<SwiperMediaData> datas;
  int currentIndex;
  VideoAndPicSwiperPage(this.datas,this.currentIndex);
  @override
  State<StatefulWidget> createState() {

    return VideoAndPicSwiperPageState();
  }


}

class VideoAndPicSwiperPageState extends State<VideoAndPicSwiperPage>{

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Swiper(
              key: UniqueKey(),
              itemCount: widget.datas.length,
              itemWidth: MediaQuery.of(context).size.width,
              loop: true,
              itemHeight: MediaQuery.of(context).size.height,
              index: widget.currentIndex,
              itemBuilder: (c,i){
                SwiperMediaData data = widget.datas[i];
                if(data.isVideo){
                  return SingleVideoItem(videoUrl: data.url);
                }
              return SinglePicItem(data.url,key: GlobalKey(),);
            },
              pagination: new SwiperCustomPagination(
                builder:(BuildContext context, SwiperPluginConfig config){
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width:Dimens.pt44,
                      height: Dimens.pt18,

                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(right: 16,top: 50),
                      child: Text("${config.activeIndex+1}/${widget.datas.length}",style: TextStyle(
                          fontSize: Dimens.pt12,
                          color: Colors.white,
                      ),),
                    ),
                  );
                },

              ),
            ),
            Positioned(
                top: 50,
                left: 16,
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Image.asset(
                      "assets/images/app_back.png",
                      width: Dimens.pt30,
                      height: Dimens.pt30,fit: BoxFit.fill),
                ))

          ],
        ),
      ),
    );
  }






}

class SwiperMediaData{
  bool isVideo;
  String url;
  String cover;

}