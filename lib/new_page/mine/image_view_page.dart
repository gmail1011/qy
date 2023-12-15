import 'package:flutter/material.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/custom_network_image_new.dart';
import 'package:flutter_app/new_page/mine/floating_cs_view.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_screenutil/screen_util.dart';

///帮助反馈
class ImageViewPage extends StatefulWidget {
  List<String> seriesCover;
  int realDataIndex=0;
  ImageViewPage(this.seriesCover,this.realDataIndex);
  @override
  State<StatefulWidget> createState() {
    return _ImageViewPageState();
  }
}

class _ImageViewPageState extends State<ImageViewPage> {
  List<String> listdata = [""];
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int indexs = 1;
    int mx = listdata.length;
    return FullBg(
      child: Scaffold(
        appBar: CustomAppbar(title: ""),
        body:

            //定义两个全局变量indexs为当前页数    mx 为最大页数
            Stack(
          alignment: const FractionalOffset(0.9, 0.95), //调整位置
          children: <Widget>[
            Container(
              height: ScreenUtil().setHeight(428.0),
              width: ScreenUtil().setWidth(343.0),
              child: PageView(
                onPageChanged: (index) {
                  //index为当前是第几个
                  setState(() {
                    indexs = index + 1;
                  });
                },
                controller: _pageController,
                children: listdata.map((e) => _image()).toList(), //写图片组件
              ),
            ),
            Positioned(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black45,
                        offset: Offset(0.0, 0.0), //阴影xy轴偏移量
                        blurRadius: 1.0, //阴影模糊程度
                        spreadRadius: 2.0 //阴影扩散程度
                        )
                  ],
                  borderRadius: BorderRadius.circular(5.0),
                ),
                alignment: Alignment.center,
                width: ScreenUtil().setWidth(50.0),
                height: ScreenUtil().setHeight(20.0),
                child: Text(
                  '$indexs/' + '$mx',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getItem(context, item) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            item["question"],
            style: const TextStyle(
                color: const Color(0xffc6c6c6),
                fontWeight: FontWeight.w700,
                fontSize: 16.0),
          ),
          SizedBox(height: 5),
          Text(
            item["answer"],
            style: const TextStyle(
                color: const Color(0xff808080),
                fontWeight: FontWeight.w400,
                fontSize: 14.0),
          ),
        ]));
  }

  _image() {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      child: Stack(
        fit: StackFit.expand,
        alignment: AlignmentDirectional.center,
        children: [
          CustomNetworkImageNew(
            width: double.maxFinite,
            height: 344,
            imageUrl: getImagePath(widget.seriesCover[widget.realDataIndex], true, false),
            fit: BoxFit.cover,
            useQueue: true,
          ),
        ],
      ),
    );
  }
}
