import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/model/agent_girl_list_entity.dart';
import 'package:flutter_app/model/lou_feng_model.dart';
import 'package:flutter_app/page/home/yue_pao_page/com/public.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/pull_refresh_view.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_app/common/net2/net_manager.dart';

class Agent extends StatefulWidget{

  AgentInfo agentInfo;

  Agent(this.agentInfo);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AgentState();
  }

}

class AgentState extends State<Agent>{

  PullRefreshController pullController = PullRefreshController();

  LouFengModel louFengModel;

  int pageNum = 1;
  int pageSize = 16;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

     initData(false);
  }

  void initData(bool isLoading) async{
    try {

      LouFengModel louFengModelTemp = await netManager.client.getLouFengAgentList(pageNum, pageSize,widget.agentInfo.name);

      if(isLoading){
        louFengModel.hasNext = louFengModelTemp.hasNext;
        louFengModel.list.addAll(louFengModelTemp.list);
        if(louFengModelTemp.hasNext){
          pullController.refreshController.loadComplete();
        }else{
          pullController.refreshController.loadNoData();
        }
      }else{
        louFengModel = louFengModelTemp;
      }

      pullController.requestSuccess(isFirstPageNum: true,hasMore: louFengModel.hasNext);

      setState(() {

      });

    } catch (e) {
      l.e('getLouFengList=>', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return louFengModel == null ? Center(child: LoadingWidget(),) : SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
          return <Widget>[
            SliverAppBar(
              //floating: true,
              // snap: true,
              pinned: false,
              // stretch: true,
              automaticallyImplyLeading: false,
              expandedHeight: Dimens.pt170,
              flexibleSpace: FlexibleSpaceBar(
                // title: contain,
                background: StatefulBuilder(
                  builder: (contexts, setStates) {
                    return Container(
                      height: Dimens.pt200,
                      decoration: BoxDecoration(
                        image: DecorationImage(fit: BoxFit.cover,image: AssetImage("assets/images/agent_background.png")),
                      ),
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                            Padding(
                              padding: EdgeInsets.only(right: Dimens.pt26),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  child: ClipOval(
                                    child: CustomNetworkImage(
                                      height: Dimens.pt60,
                                      width: Dimens.pt60,
                                      fit: BoxFit.cover,
                                      imageUrl: widget.agentInfo.avatar,
                                    ),
                                  ),
                                  decoration: ShapeDecoration(
                                    shape: CircleBorder(
                                      side: BorderSide(
                                        width: 0.5,
                                        color: Colors.white,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),


                          Padding(
                            padding: EdgeInsets.only(left: Dimens.pt26,top: Dimens.pt16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: Dimens.pt210,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.agentInfo.name,style: TextStyle(color: Colors.white,fontSize: Dimens.pt18),),

                                    SizedBox(height: Dimens.pt10,),

                                    Text(widget.agentInfo.introduce,style: TextStyle(color: Colors.white,fontSize: Dimens.pt14),),

                                    SizedBox(height: Dimens.pt18,),

                                    Visibility(
                                      visible: widget.agentInfo.deposit == 0 ? false : true,
                                      child: Row(

                                        crossAxisAlignment: CrossAxisAlignment.baseline,
                                        children: [
                                          Image.asset("assets/images/agent_bao.png",width: Dimens.pt24,height: Dimens.pt24,),

                                          SizedBox(width: Dimens.pt8,),

                                          Container(
                                            alignment: Alignment.centerLeft,
                                            margin: EdgeInsets.only(bottom: Dimens.pt14),
                                            padding: EdgeInsets.only(left: Dimens.pt8,right: Dimens.pt8,top: Dimens.pt4,bottom: Dimens.pt4),
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(254, 243, 226, 1),
                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                            ),
                                            child: Text(
                                              "已缴纳${widget.agentInfo.deposit}元保证金",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: Dimens.pt12,
                                                color: Color.fromRGBO(245, 68, 4, 1),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),



                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

          ];
        },
          body: Material(
            color: AppColors.primaryColor,
            child: Container(
              color: AppColors.primaryColor,
              margin: EdgeInsets.symmetric(horizontal: AppPaddings.appMargin),
              padding: EdgeInsets.only(top: Dimens.pt10),
              child: PullRefreshView(
                onLoading: () {
                  //dispatch(YuePaoIndexTabViewActionCreator.loadMoreData(true));

                  pageNum += 1;
                  initData(true);
                },
                onRefresh: () {
                  //dispatch(YuePaoIndexTabViewActionCreator.loadRefresh(false));

                  pageNum = 1;
                  initData(false);
                },
                retryOnTap: () {
                  //dispatch(YuePaoIndexTabViewActionCreator.loadMoreData(false));
                },
                controller: pullController,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    childAspectRatio: 0.6,
                  ),
                  itemCount: louFengModel.list.length,
                  itemBuilder: (context,index){
                    LouFengItem item = louFengModel.list[index];
                    if (item.loufengType == 'ad') {
                      return adItemBuilderView(item);
                    }
                    return itemBuilderView1(item,pageTitle: 2, click: () async {
                      LouFengItem louFengItem = await JRouter().go(YUE_PAO_DETAILS_PAGE, arguments: {'id': item.id,"pageTitle" : 0,});
                      if (louFengItem != null) {
                        //dispatch(YuePaoIndexTabViewActionCreator.onChangeItem(louFengItem));
                      }
                    });
                  },
                ),
              ),
            ),
          ),
      ),
    );
  }

}