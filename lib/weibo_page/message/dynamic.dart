import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_cache_manager.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/weibo_page/community_recommend/detail/community_detail_page.dart';
import 'package:flutter_app/weibo_page/widget/bloggerPage.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as path;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dynamic_entity.dart';
import 'package:get/route_manager.dart' as Gets;

class DynamicPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DynamicPageState();
  }
}

class DynamicPageState extends State<DynamicPage> {
  int pageNumber = 1;
  int pageSize = 16;

  DynamicData dynamicData;

  RefreshController refreshUserController = RefreshController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    refreshUserController?.dispose();
    super.dispose();
  }

  void getData() async {
    try {
      dynamic messageDetail = await netManager.client.getDynamic(
        pageNumber,
        pageSize,
      );

      if (pageNumber > 1) {
        DynamicData dynamicData123 = DynamicData().fromJson(messageDetail);
        dynamicData.xList.addAll(dynamicData123.xList);
        if (dynamicData123.hasNext) {
          refreshUserController.loadComplete();
        } else {
          refreshUserController.loadNoData();
        }
      } else {
        dynamicData = DynamicData().fromJson(messageDetail);

        refreshUserController.refreshCompleted();

        if (dynamicData.hasNext) {
          refreshUserController.loadComplete();
        } else {
          refreshUserController.loadNoData();
        }
      }

      setState(() {});
    } catch (e) {
      //l.e("loadUser", "_onLoadUserInfo()...error:$e");
    }
  }

  Widget getImage(String type, DynamicDataList dataList) {
    switch (type) {
      case "follow_msg":
        return Image.asset(
          dataList.sendGender == null || dataList.sendGender == "female"
              ? "assets/weibo/dynamic_female.png"
              : "assets/weibo/dynamic_follow.png",
          width: 20.w,
          height: 20.w,
          fit: BoxFit.contain,
        );
        break;
      case "like_msg":
        return Image.asset(
          "assets/weibo/dynamic_like.png",
          width: 20.w,
          height: 20.w,
          fit: BoxFit.contain,
        );
        break;
      case "like_msg":
        return Image.asset(
          "assets/weibo/dynamic_like.png",
          width: 20.w,
          height: 20.w,
          fit: BoxFit.contain,
        );
        break;
      case "forward_msg":
        return Image.asset(
          "assets/weibo/dynamic_forward.png",
          width: 20.w,
          height: 20.w,
          fit: BoxFit.contain,
        );
        break;

      case "comment_msg":
        return Image.asset(
          "assets/weibo/dynamic_word.png",
          width: 20.w,
          height: 20.w,
          fit: BoxFit.contain,
        );
        break;

      case "desire_msg":
        return Image.asset(
          "assets/weibo/dynamic_word.png",
          width: 20.w,
          height: 20.w,
          fit: BoxFit.contain,
        );
        break;
      default:
        return Container();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.weiboBackgroundColor,
      appBar: getCommonAppBar("动态"),
      body: dynamicData == null
          ? LoadingWidget()
          : dynamicData.xList == null || dynamicData.xList.length == 0
              ? CErrorWidget("暂无数据")
              : pullYsRefresh(
                  refreshController: refreshUserController,
                  onRefresh: () {
                    pageNumber = 1;
                    getData();
                  },
                  onLoading: () {
                    pageNumber += 1;
                    getData();
                  },
                  child: ListView.builder(
                    itemCount: dynamicData.xList.length,
                    itemBuilder: (context, index) {
                      DynamicDataList model = dynamicData.xList[index];
                      return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: (){
                          String msgType = model.msgType;
                          if ("desire_msg" == msgType) {
                            JRouter()
                                .jumpPage(WISH_DETAILS_PAGE, args: {
                              "wishId": model.objId,
                              "isMyWish": true
                            });
                          } else if ("comment_msg" == msgType
                              || "reply_comment_msg" == msgType
                              || "like_comment_msg" == msgType) {
                            Gets.Get.to(
                                CommunityDetailPage().buildPage({
                                  "videoId":model.objId
                                }),
                                opaque: false);
                          }else {

                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 25.w, left: 30.w),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  getImage(model.msgType,model),
                                  SizedBox(width: 14.w),
                                  ClipOval(
                                    child: GestureDetector(
                                      onTap: () {
                                        Map<String, dynamic> map = {
                                          'uid': model.sendUid,
                                          'uniqueId':
                                          DateTime.now().toIso8601String(),
                                        };
                                        Gets.Get.to(BloggerPage(map),
                                            opaque: false);
                                      },
                                      child: CustomNetworkImage(
                                        width: 43.w,
                                        height: 43.w,
                                        fit: BoxFit.cover,
                                        imageUrl:model.sendAvatar,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  GestureDetector(
                                    onTap: () {
                                      Map<String, dynamic> map = {
                                        'uid': model.sendUid,
                                        'uniqueId':
                                        DateTime.now().toIso8601String(),
                                      };
                                      Gets.Get.to(BloggerPage(map),
                                          opaque: false);
                                    },
                                    child: Text(
                                      model.sendName,
                                      style: TextStyle(
                                          fontSize: 16.nsp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    model.content,
                                    style: TextStyle(
                                        fontSize: 16.nsp,
                                        color: Colors.white.withOpacity(0.6)),
                                  ),
                                ],
                              ),
                              SizedBox(height: 14.w),
                              if(model.objName?.isNotEmpty == true)
                                Container(
                                  color: Colors.transparent,
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(left: 40.w, bottom: 16.w),
                                  child: Text(
                                    model.objName,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14.nsp),
                                  ),
                                ),
                              Container(
                                height: 1.w,
                                margin: EdgeInsets.only(left: 40.w, right: 40.w),
                                color: Color.fromRGBO(39, 39, 39, 1),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
