import 'package:flutter/material.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';

import 'ai_face_record_page.dart';
import 'ai_record_page.dart';

class AITotalPage extends StatefulWidget{


  int selectIndex = 0 ;

  AITotalPage(this.selectIndex);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AITotalPageState();
  }

}

class _AITotalPageState extends State<AITotalPage>{

  TabController tabController;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tabController = TabController(length: 3, vsync: ScrollableState(),initialIndex: widget.selectIndex);
    tabController.addListener(() {
      widget.selectIndex = tabController.index;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      // appBar: AppBar(
      //
      //   elevation: 0,
      //   centerTitle: true,
      //   titleSpacing: .0,
      //   title: TabBar(
      //     isScrollable: true,
      //     indicatorSize: TabBarIndicatorSize.label,
      //     indicatorColor: Colors.white,
      //     //indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
      //     labelStyle: TextStyle(
      //       fontSize: Dimens.pt18,
      //     ),
      //     unselectedLabelStyle: TextStyle(
      //       fontSize: Dimens.pt18,
      //     ),
      //     indicator: const BoxDecoration(),
      //     controller: tabController,
      //     unselectedLabelColor: Color.fromRGBO(204, 204, 204, 1),
      //     labelColor: Colors.white,
      //     tabs: Lang.AI_TABS.map((it) => Tab(text: it))?.toList(),
      //   ),
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back_ios),
      //     onPressed: () {
      //       safePopPage();
      //     },
      //   ),
      //
      // ),

      appBar:getCommonAppBar("AI科技"),
      body:Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10,bottom: 10,left: 5,right: 5),
            alignment: Alignment.center,
            height: 40,
            width: screen.screenWidth,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  child: Container(
                      margin: EdgeInsets.only(left: 5),
                      child: GestureDetector(
                        onTap: (){
                          if(widget.selectIndex!=index){
                            widget.selectIndex=index;
                            tabController.animateTo(index);
                            setState(() {

                            });
                          }
                        },
                        child:Container(
                          padding: EdgeInsets.only(left: 8,right: 8),
                          height: 40,
                          alignment: Alignment.center,
                          decoration: new BoxDecoration(
                              color: widget.selectIndex==index?Color.fromRGBO(0, 214, 190, 1):Color.fromRGBO(255, 255, 255, 0.1),
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: Row(
                            children: [
                              Image.asset(index==0?"assets/weibo/hjll_ai_address.png":index==1?"assets/weibo/hjll_ai_video_face.png":"assets/weibo/hjll_ai_pic_face.png",width: 30,height: 30,),
                              Text(index==0?"AI脱衣":index==1?"AI视频换脸":"AI图片换脸",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),)
                            ],
                          ),
                        ),
                      )
                  ),
                );
              },
            ),
          ),
          Expanded(child:  TabBarView(

            controller: tabController,

            children: [

              AiRecordPage(position: 0,),
              AiRecordPage(position: 1,),
              AiRecordPage(position: 2,),

            ],
          ),)
        ],
      ),

    );
  }

}