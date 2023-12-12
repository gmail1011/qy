import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/tags_detail_entity.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video/video_cell_widget.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video_detail/page.dart';
import 'package:flutter_app/page/tag/liaoba_tag_detail/page.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart' as Gets;

final _bigVideoItemHeight = (screen.screenWidth - 32) / 1.78;
final _subItemHeight = ((screen.screenWidth - 32 - 14) / 2) / 1.78;
final _subItemWidth = ((screen.screenWidth - 32 - 14) / 2);

class TVItemTableView extends StatefulWidget {
  final TagsDetailDataSections item;
  final Dispatch dispatch;
  final ViewService viewService;

  const TVItemTableView({Key key, this.item, this.dispatch, this.viewService})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TVItemTableViewState();
  }
}

class _TVItemTableViewState extends State<TVItemTableView> {
  TagsDetailDataSections get item => widget.item;

  List<TagsDetailDataSectionsVideoInfo> get list => item.videoInfo;

  // 0 一大四小, 1 一大两小, 2横版小横屏, 3大横屏, 4竖版小横屏
  int get sortType => item.sortType ?? 0;

  int get videoCount => list?.length ?? 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (item.isRandomAd()) {
      AdsInfoBean adModel = item.randomAdsInfo;
      return Container(
        margin: EdgeInsets.fromLTRB(16.w, 12, 16.w, 0),
        child: InkWell(
          onTap: () {
            JRouter().handleAdsInfo(adModel.href, id: adModel.id);
          },
          child: CustomNetworkImage(
            width: screen.screenWidth-32.w,
            height: (screen.screenWidth-32.w) * 150/720,
            fit: BoxFit.fill,
            imageUrl: adModel.cover,
          ),
        ),
      );
    }
    if (videoCount == 0) {
      return Container();
    }
    return Container(
      color: AppColors.userMakeBgColor,
      child: Column(
        children: <Widget>[
          Container(
            color: AppColors.weiboBackgroundColor,
            height: 9,
            width: screen.screenWidth,
          ),
          ///title
          Container(
            padding: EdgeInsets.only(right: 16.w, top: 12.w),
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12.0)),
            child:  GestureDetector(
              onTap: () {
                ///进入标签页
                if (list != null &&
                    list[0] != null &&
                    list[0].tags != null) {
                  Map<String, dynamic> maps = Map();
                  maps['tagId'] = item.sectionID;
                  maps['title'] = item.sectionName;
                  Gets.Get.to(() => LiaoBaTagDetailPage().buildPage(maps),
                      opaque: false);
                }
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(top: 6.w),
                child: Row(
                  children: <Widget>[
                    svgAssets(AssetsSvg.ICON_WITHDRAW_RECTANGLE,
                        width: 6.w, height: 19.w),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        (item.sectionName),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: AppFontSize.fontSize16,
                            fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      Lang.MORE,
                      style: TextStyle(
                          color: AppColors.withdrawsubTextColor,
                          fontSize: AppFontSize.fontSize13),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 16.w),
          //// 0 一大四小, 1 一大两小, 2横版小横屏, 3大横屏, 4竖版小横屏
          if (sortType == 0)
            _buildOneLargeAndSmall(4)
          else if (sortType == 1)
            _buildOneLargeAndSmall(2)
          else if (sortType == 2)
            _buildSmallHorizontalScroller()
          else if (sortType == 3)
            _buildBigHorizontalScroller()
          else if (sortType == 4)
            _buildSmallHorizontalUpVScroller()
          else
            _buildOneLargeAndSmall(4),
          SizedBox(height: 8.w),
        ],
      ),
    );
  }

  // 1 一大两小/四小
  Widget _buildOneLargeAndSmall(int smallCount) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          //大图1
          onTap: () {
            Map<String, dynamic> maps = Map();
            maps["videoId"] = list[0]?.id;
            maps['sectionID'] = item.sectionID;
            // maps["sectionId"] = list[0].;
            Gets.Get.to(() => FilmTvVideoDetailPage().buildPage(maps),
                opaque: false);
          },
          child: Container(
            margin: EdgeInsets.only(left: 16.w, right: 16.w),
            height: _bigVideoItemHeight + 24,
            child: (list==null || list.length==0)?SizedBox():VideoCellWidget(
              videoInfo: list[0],
              textLine: 1,
            ),
          ),
        ),
        SizedBox(height: 12.w),
        if (videoCount > 1)
          Container(
            margin: EdgeInsets.only(left: 16.w, right: 16.w),
            child: MediaQuery.removePadding(
              removeTop: true,
              context: widget.viewService.context,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 14.0,
                    childAspectRatio: _subItemWidth / (_subItemHeight + 40)),
                itemCount:
                videoCount > (smallCount + 1) ? smallCount : videoCount - 1,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Map<String, dynamic> maps = Map();
                      maps["videoId"] = list[index + 1]?.id;
                      maps['sectionID'] = item.sectionID;
                      Gets.Get.to(() => FilmTvVideoDetailPage().buildPage(maps),
                          opaque: false);
                    },
                    child: (list==null || list.length <= (index + 1))?SizedBox():VideoCellWidget(
                      videoInfo: list[index + 1],
                      textLine: 2,
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
//2 横版小横屏
  Widget _buildSmallHorizontalScroller() {
    return Container(
      height: 121,
      padding: EdgeInsets.only(left: 16.w),
      child: ListView.builder(
        itemCount: videoCount,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              Map<String, dynamic> maps = Map();
              maps["videoId"] = list[index]?.id;
              maps['sectionID'] = item.sectionID;
              Gets.Get.to(() => FilmTvVideoDetailPage().buildPage(maps),
                  opaque: false);
            },
            child: Container(
              padding: EdgeInsets.only(right: 10),
              child: SizedBox(
                width: 171,
                height: 121,
                child: VideoCellWidget(
                  videoInfo: list[index],
                  textLine: 1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  // 3 大横屏
  Widget _buildBigHorizontalScroller() {
    return Container(
      height: 177,
      width: screen.screenWidth,
      padding: EdgeInsets.only(left: 16.w),
      child: ListView.builder(
        itemCount: videoCount,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              Map<String, dynamic> maps = Map();
              maps["videoId"] = list[index]?.id;
              maps['sectionID'] = item.sectionID;
              Gets.Get.to(() => FilmTvVideoDetailPage().buildPage(maps),
                  opaque: false);
            },
            child: Container(
              padding: EdgeInsets.only(right: 10),
              child: SizedBox(
                width: 271,
                height: 177,
                child: VideoCellWidget(
                  videoInfo: list[index],
                  textLine: 1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  //4竖版小横屏
  Widget _buildSmallHorizontalUpVScroller() {
    double width = (screen.screenWidth - 16 - 10*2)/2.5;
    double height = width*240/147;
    return Container(
      height: height,
      padding: EdgeInsets.only(left: 16.w),
      child: ListView.builder(
        itemCount: videoCount,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              Map<String, dynamic> maps = Map();
              maps["videoId"] = list[index]?.id;
              maps['sectionID'] = item.sectionID;
              Gets.Get.to(() => FilmTvVideoDetailPage().buildPage(maps),
                  opaque: false);
            },
            child: Container(
              padding: EdgeInsets.only(right: 10),
              child: SizedBox(
                width: width,
                height: height,
                child: VideoCellWidget(
                  videoInfo: list[index],
                  textLine: 1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  // 小横屏-四宫格
  Widget _buildSmallFourGrid() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 14.0,
          childAspectRatio: _subItemWidth / (_subItemHeight + 40)),
      itemCount: videoCount > 4 ? 4 : videoCount,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Map<String, dynamic> maps = Map();
            maps["videoId"] = list[index]?.id;
            maps['sectionID'] = item.sectionID;
            Gets.Get.to(() => FilmTvVideoDetailPage().buildPage(maps),
                opaque: false);
          },
          child: VideoCellWidget(
            videoInfo: list[index],
            textLine: 2,
          ),
        );
      },
    );
  }

  Widget _buildPlaceholderUI(
          {double width, double height, double borRadius = 0}) =>
      ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(borRadius)),
        child: Image(
          image: AssetImage("assets/weibo/loading_horizetol.png"),
          width: width ?? double.infinity,
          height: height ?? double.infinity,
          fit: BoxFit.fill,
        ),
      );
}
