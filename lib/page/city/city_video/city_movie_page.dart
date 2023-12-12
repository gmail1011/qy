import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/nearby_bean.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video/video_cell_widget.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CityMoviePage extends StatefulWidget {
  final String city;

  const CityMoviePage({Key key, this.city}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CityMoviePageState();
  }
}

class _CityMoviePageState extends State<CityMoviePage> with AutomaticKeepAliveClientMixin {
  NearbyBean nearbyLongBean;
  RefreshController refreshController = RefreshController();
  int pageNumber = 1;

  @override
  bool get wantKeepAlive => true;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadDataEvent(page: 1);
    });
  }


  void _loadDataEvent({int page = 1}) async {
    try {
      var nearBean = await netManager.client
          .getCityVideoList(page, 20, widget.city, "MOVIE");
      pageNumber = page;
      if(page == 1){
        nearbyLongBean = nearBean;
      }else {
        nearbyLongBean.vInfo?.addAll(nearBean.vInfo ?? []);
      }
      refreshController.refreshCompleted();
      if (nearbyLongBean.hasNext) {
        refreshController.loadComplete();
      } else {
        refreshController.loadNoData();
      }
    } catch (e) {
      nearbyLongBean ??= NearbyBean();
      refreshController.refreshCompleted();
      if (nearbyLongBean.hasNext) {
        refreshController.loadComplete();
      } else {
        refreshController.loadNoData();
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _onLoadMoreEvent() {
    _loadDataEvent(page: pageNumber + 1);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (nearbyLongBean == null) {
      return LoadingWidget();
    } else {
      if (nearbyLongBean.vInfo == null || nearbyLongBean.vInfo.length == 0) {
        return CErrorWidget("暂无数据");
      }
      return SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        enablePullDown: false,
        onRefresh: _loadDataEvent,
        onLoading: _onLoadMoreEvent,
        child: GridView.builder(
          padding: EdgeInsets.only(top: 6.w),
          itemCount: nearbyLongBean.vInfo.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, //横向数量
            crossAxisSpacing: 10, //间距
            mainAxisSpacing: 10, //行距
            childAspectRatio:  190 / 132,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Map<String, dynamic> maps = Map();
                maps["videoId"] = nearbyLongBean.vInfo[index].id;
                //  maps["sectionID"] = nearbyLongBean.vInfo[index].sectionID;
                JRouter().go(FILM_TV_VIDEO_DETAIL_PAGE, arguments: maps);
              },
              child: VideoCellWidget(
                  textLine: 1, videoModel: nearbyLongBean.vInfo[index]),
            );
          },
        ),
      );
    }
  }


}
