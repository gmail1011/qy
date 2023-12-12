import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/image_manager_new.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/film_tv_video/TagsVideoDataModel.dart';
import 'package:flutter_app/model/liao_ba_tags_detail_entity.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/home/post/MySliverDelegate.dart';
import 'package:flutter_app/utils/cache_util.dart';
import 'package:flutter_app/weibo_page/widget/wordImageWidgetForHjll.dart';
import 'package:flutter_app/widget/LoadingWidget.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HjllCommunityListPage extends StatefulWidget {

  final String videoTagId;

  HjllCommunityListPage({Key key, this.videoTagId});

  @override
  State<HjllCommunityListPage> createState() => _HjllCommunityListPageState();
}

class _HjllCommunityListPageState extends State<HjllCommunityListPage> {
  RefreshController refreshController = RefreshController();
  int pageNumber = 1;
  int currentIndex = 0;
  List<LiaoBaTagsDetailDataVideos> videoList;

  int get moduleSort {
    //1、最新，2、最热，3、最多播放量或者推荐，4、十分钟以上视频，5、精华，6、视频
    if(currentIndex == 0){
      return 3;
    }else if(currentIndex == 1){
      return 1;
    }else if(currentIndex == 2){
      return 2;
    }else if(currentIndex == 3){
      return 5;
    }else if(currentIndex == 4){
      return 6;
    }else {
      return 3;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData(currentIndex);
    });
  }

  _loadData(int requestIndex, {int page = 1, int pageSize = 10}) async {
    try {
      TagsVideoDataModel tagsVideoDataModel =
          await netManager.client.getTagsDetails(widget.videoTagId, pageSize, page, moduleSort);
      if(requestIndex != currentIndex) return;
      videoList ??= [];
      pageNumber = page;
      if (page == 1) {
        videoList?.clear();
      }
      if (tagsVideoDataModel.allVideoInfo != null) {
        videoList?.addAll(tagsVideoDataModel.allVideoInfo);
      }
      if (tagsVideoDataModel.hasNext == true) {
        refreshController.loadComplete();
      } else {
        refreshController.loadNoData();
      }
    } catch (e) {
      if(requestIndex != currentIndex) return;
      videoList ??= [];
      refreshController.loadComplete();
    }
    refreshController.refreshCompleted();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {

    List<Widget> menuItems = [];
    for(int i = 0; i < Config.communityVideType.length; i++){
      menuItems.add(_buildMenuItem(i,Config.communityVideType[i], currentIndex == i));
    }

    return pullYsRefresh(
      refreshController: refreshController,
      enablePullUp: videoList != null,
      enablePullDown: videoList != null,
      onLoading: () => _loadData(currentIndex, page: pageNumber + 1),
      onRefresh: () => _loadData(currentIndex),
      child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            key: ValueKey(currentIndex),
            pinned: true,
            floating: true,
            delegate: MySliverDelegate(
              maxHeight: 40,
              minHeight: 40,
              child: Container(
                  width: screen.screenWidth,
                  height: 40,
                  color: Color.fromRGBO(13, 14, 31, 1),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: menuItems,
                  ),
              ),
            ),
          ),
          _buildTableView(),
        ],

      ),
    );
  }

  Widget _buildTableView() {
    if(videoList == null){
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 200,
          child: LoadingWidget(),
        ),
      );
    }else if(videoList.isEmpty){
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 200,
          child: CErrorWidget("暂无数据"),
        ),
      );
    }else {
      return SliverPadding(
        padding: EdgeInsets.only(top: 10),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              LiaoBaTagsDetailDataVideos liaoBaTagsDetailDataVideos = videoList[index];
              VideoModel _realModel = VideoModel.fromJson(liaoBaTagsDetailDataVideos.toJson());
              return WordImageWidgetForHjll(
                padding: EdgeInsets.only(left: 10, right: 10, top: 12),
                videoModel: _realModel,
                showTopInfo: false,
                isHaiJiaoLLDetail: false,
                tagColor: Color(0xff74b7f1),
              );
            },
            childCount: videoList?.length ?? 0,
          ),
        ),
      );
    }
  }

  Widget _buildMenuItem(int index, String title, bool isSelected) {
    return InkWell(
      onTap: (){
        if(currentIndex != index){
          currentIndex = index;
          videoList = null;
          _loadData(currentIndex);
          setState(() {});
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xff1f2030) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          "  $title  ",
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Color.fromRGBO(153, 153, 153, 1),
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    clearAllCache();
  }
}
