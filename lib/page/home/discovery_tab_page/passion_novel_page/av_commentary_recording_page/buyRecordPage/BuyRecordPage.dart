import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/page/home/AVCommentary/AVCommenaryDetail/AVCommentaryDetailPage.dart';
import 'package:flutter_app/page/home/AVCommentary/bean/a_v_commentary_entity.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/custom_edge_insets.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BuyRecordPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BuyRecordPageState();
  }

}


class _BuyRecordPageState extends State<BuyRecordPage>{

  int pageNumber = 1;
  int pageSize = 10;


  AVCommentaryData avCommentaryEntity;

  List<AVCommentaryDataList> xList = [];

  RefreshController refreshController ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshController = new RefreshController();
    initData(false);
  }

  void initData(bool isLoading) async {
    dynamic model = await netManager.client.getAVCommentaryBuyList(pageNumber, pageSize);

    if(model != null){
      avCommentaryEntity = new AVCommentaryData().fromJson(model);
      if(!isLoading){
        xList.clear();
      }

      if(avCommentaryEntity.xList.length == 0){
        refreshController.loadNoData();
      }else{
        xList.addAll(avCommentaryEntity.xList);
      }


      setState(() {

      });
    }
  }


  ///空数据展示的view
  Widget emptyView() {
    return Container(
        margin: CustomEdgeInsets.only(top: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("暫無數據",
                style: TextStyle(color: Colors.white, fontSize: 15)),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
          child: Column(children: <Widget>[

            SizedBox(
              height: Dimens.pt6,
            ),

            avCommentaryEntity == null ? Center(child: LoadingWidget()) : xList.length == 0 ? Center(child: emptyView()) :

            Expanded(
              child: pullYsRefresh(
                refreshController: refreshController,
                onRefresh: ()
                async {
                  Future.delayed(Duration(milliseconds: 1700),(){
                    pageNumber = 1;
                    pageSize = 10;
                    initData(false);
                    refreshController.refreshCompleted();
                  });
                },
                onLoading: () async{
                  Future.delayed(Duration(milliseconds: 1700),(){
                    pageNumber++;
                    initData(true);
                    refreshController.loadComplete();
                  });
                },
                child: ListView.builder(
                  itemCount: xList.length,
                  shrinkWrap: true,
                  itemBuilder: (context,index) {

                    return GestureDetector(
                      onTap: () async{



                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return AVCommentaryDetailPage(
                              index: index,
                              xList: xList[index],
                            );
                          },
                        )).then((value) {

                        });


                      },
                      child: Column(
                        children: [
                          Container(child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("第  ",style: TextStyle(color: Colors.white,fontSize: Dimens.pt14)),
                              Container(
                                padding: EdgeInsets.only(left: Dimens.pt4,right: Dimens.pt4,),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(xList[index].period.toString(),style: TextStyle(color: Colors.red),),
                              ),
                              Text("  期  " + DateUtil.formatDateStr(xList[index].createdAt,format: "MM月dd日 "),style: TextStyle(color: Colors.white,fontSize: Dimens.pt14)),
                            ],
                          )),


                          SizedBox(
                            height: Dimens.pt8,
                          ),

                          Container(
                            margin: EdgeInsets.only(left: Dimens.pt16,right: Dimens.pt16,bottom: Dimens.pt26,),
                            height: Dimens.pt300,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(Dimens.pt12),bottomRight: Radius.circular(Dimens.pt12),topLeft: Radius.circular(Dimens.pt12),topRight: Radius.circular(Dimens.pt12)),
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimens.pt12),topRight: Radius.circular(Dimens.pt12)),
                                  child: CustomNetworkImage(
                                      imageUrl: xList[index].cover,
                                      height: Dimens.pt180,
                                      fit: BoxFit.cover),
                                ),

                                Container(
                                  padding: EdgeInsets.only(left: Dimens.pt10,top: Dimens.pt10,right: Dimens.pt10,),
                                  alignment: Alignment.centerLeft,
                                  child: Text(xList[index].title,style: TextStyle(color: Colors.black,fontSize: Dimens.pt14,fontWeight: FontWeight.bold),),
                                ),

                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(left: Dimens.pt10,top: Dimens.pt10,right: Dimens.pt10,),
                                  child: Text(xList[index].desc,style: TextStyle(color: Colors.black,fontSize: Dimens.pt12,),),
                                ),

                                Spacer(),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: xList[index].tags.asMap().entries.map((e) {
                                        return Container(
                                          margin: EdgeInsets.only(left: Dimens.pt10),
                                          padding: EdgeInsets.only(left: Dimens.pt10,right: Dimens.pt10,top: Dimens.pt4,bottom: Dimens.pt4),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(Dimens.pt10)),
                                            gradient: LinearGradient(
                                                colors: [
                                                  Color(0xfff5164e),
                                                  Color(0xffff6538),
                                                  Color(0xfff54404),
                                                ],
                                                stops: [0,1,1],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight
                                            ),
                                            boxShadow: [
                                              BoxShadow(color: Color(0xfff82c2c).withOpacity(0.4),
                                                  offset: Offset(0.0, 6),
                                                  blurRadius: 8,
                                                  spreadRadius: 0 )
                                            ],
                                          ),
                                          child: Text(e.value,style: TextStyle(color: Colors.white,fontSize: Dimens.pt10),),
                                        );
                                      }).toList(),
                                    ),
                                    Text("查看  >  ",style: TextStyle(color: Color(0xFFF7264A),fontSize: Dimens.pt12,fontWeight: FontWeight.w600)),
                                  ],
                                ),

                                SizedBox(
                                  height: Dimens.pt12,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ])),
    );
  }

}