import 'package:fish_redux/fish_redux.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/page/home/AVCommentary/bean/a_v_commentary_detail_entity.dart';
import 'package:flutter_app/page/home/AVCommentary/bean/a_v_commentary_entity.dart';
import 'package:flutter_app/page/home/post/ads_banner_widget.dart';
import 'package:flutter_app/page/wallet/my_income/view.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/custom_edge_insets.dart';
import 'package:flutter_app/widget/dialog/confirm_dialog.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/array_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'AVCommenaryDetail/AVCommentaryDetailPage.dart';
import 'a_v_commentary_action.dart';
import 'a_v_commentary_state.dart';

Widget buildView(AVCommentaryState state, Dispatch dispatch, ViewService viewService) {

  return AVCommentaryPages();
}


class AVCommentaryPages extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AVCommentaryPagesState();
  }

}


class _AVCommentaryPagesState extends State<AVCommentaryPages>{


  SwiperController swiperController;

  List<String> banners = [
    "https://img0.baidu.com/it/u=3434365774,3342884301&fm=26&fmt=auto&gp=0.jpg",
    "https://img0.baidu.com/it/u=3434365774,3342884301&fm=26&fmt=auto&gp=0.jpg",
    "https://img0.baidu.com/it/u=3434365774,3342884301&fm=26&fmt=auto&gp=0.jpg",
    "https://img0.baidu.com/it/u=3434365774,3342884301&fm=26&fmt=auto&gp=0.jpg",
    "https://img0.baidu.com/it/u=3434365774,3342884301&fm=26&fmt=auto&gp=0.jpg",
    "https://img0.baidu.com/it/u=3434365774,3342884301&fm=26&fmt=auto&gp=0.jpg",
  ];

  AVCommentaryData avCommentaryEntity;

  RefreshController refreshController ;

  int page = 1;

  List<AVCommentaryDataList> xList = [];


  List<AdsInfoBean> adsList = [];




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    swiperController = SwiperController();
    refreshController = new RefreshController();

    initData(false);
    getAds();
  }

  Future<dynamic> initData(bool isLoading) async{
    dynamic model = await netManager.client.getAVData(page);
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

  getAds() async{
    //var list = await getAdsByType(AdsType.avCommentary);
  }

  ///获取某一个广告数据
  Future<List<AdsInfoBean>> getAdsByType(AdsType adsType) async {
    if (null == adsType) return null;
    List<AdsInfoBean> resultList = await LocalAdsStore().getAllAds();
    if (ArrayUtil.isEmpty(resultList)) return <AdsInfoBean>[];

    //List<AdsInfoBean> newList = resultList?.where((it) => it.position == adsType.index)?.toList();

    adsList = resultList?.where((it) => it.position == adsType.index)?.toList();

    setState(() {

    });

    return adsList;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("AV解说",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(right: AppPaddings.appMargin),
                child: svgAssets(AssetsSvg.RECORDING, height: Dimens.pt15)),
            onTap: () {
              JRouter().go(AV_COMMENTARY_RECORDING_PAGE);
            },
          ),
        ],
      ),
      body: Container(
          child: Column(children: <Widget>[
            Offstage(
              offstage: adsList.length == 0 ? true : false,
              child: SizedBox(
                height: Dimens.pt25,
              ),
            ),
            Offstage(
              offstage: adsList.length == 0 ? true : false,
              child: Container(
                margin: EdgeInsets.only(left: Dimens.pt16,right: Dimens.pt16,),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  child: Container(
                    height: Dimens.pt180,
                    //margin: EdgeInsets.only(left: Dimens.pt16,right: Dimens.pt16,),
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.all(Radius.circular(6)),
                    ),
                    child: AdsBannerWidget(
                      adsList,
                      width: Dimens.pt360,
                      height: Dimens.pt180,
                      onItemClick: (index) {
                        var ad = adsList[index];
                        JRouter().handleAdsInfo(ad.href, id: ad.id);
                        /*eagleClick(selfId(),
                                sourceId: state.eagleId(context),
                                label: "banner(${ad?.id ?? ""})");*/
                      },
                    ),
                  ),
                ),
              ),
            ),


            SizedBox(
              height: Dimens.pt20,
            ),

            avCommentaryEntity == null ? Center(child: LoadingWidget()) : xList.length == 0 ? Center(child: emptyView()) :

            Expanded(
              child: pullYsRefresh(
                refreshController: refreshController,
                onRefresh: ()
                async {
                   Future.delayed(Duration(milliseconds: 1700),(){
                     page = 1;
                     initData(false);
                     refreshController.refreshCompleted();
                   });
                },
                onLoading: () async{
                  Future.delayed(Duration(milliseconds: 1700),(){
                    page++;
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
                                  child: Text(xList[index].desc,maxLines: 3,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black,fontSize: Dimens.pt12,),),
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


}
