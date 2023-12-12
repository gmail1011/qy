import 'package:flutter/material.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/guess_like_entity.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///设置换一换UI
class CommunityChangeUI extends StatefulWidget {
  final List<GuessLikeDataList> changeDataList;
  final int changeDataIndex;
  final VoidCallback onChangeTap;
  final ValueChanged<dynamic> toBloggerTap;
  final ValueChanged<int> flollowTap;

  CommunityChangeUI({
    this.changeDataList,
    this.changeDataIndex,
    this.onChangeTap,
    this.toBloggerTap,
    this.flollowTap,
  });

  @override
  State<StatefulWidget> createState() => _CommunityChangeState();
}

class _CommunityChangeState extends State<CommunityChangeUI> {
  @override
  void dispose() {
    ImageCache _imageCache = PaintingBinding.instance.imageCache;
    _imageCache.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 185.w,
      color: Color(0xff1e1e1e),
      margin: EdgeInsets.only(bottom: 16.w),
      padding: EdgeInsets.only(bottom: 16.w),
      child: Column(
        children: [
          Container(
            height: 45.w,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "热门UP主",
                  style: TextStyle(
                      fontSize: 17.w,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: () {
                    //widget.onChangeTap?.call();

                    bus.emit(EventBusUtils.closeActivityFloating);

                    JRouter().go(HOMEPAGE_HOT_BLOGGER_DETAIL);
                  },
                  child: Text(
                    '更多',
                    style: TextStyle(
                      color: Color.fromRGBO(126, 160, 190, 1),
                      fontSize: Dimens.pt13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 16.w, left: 16.w),
              child: ListView.builder(
                  //padding: EdgeInsets.symmetric(horizontal: 8.w),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return _buildChangeFuncItemUINew(
                        widget.changeDataList[index], widget.changeDataIndex);
                  },
                  itemCount: widget.changeDataList?.length ?? 0),
            ),
          )
        ],
      ),
    );
  }

  ///换一换 item UI
  Widget _buildChangeFuncItemUI(GuessLikeDataList item, int changeDataIndex) {
    return Container(
      width: 147.w,
      height: 191.w,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 13.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9.w),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 18.w),
          GestureDetector(
            onTap: () async {
              widget.toBloggerTap?.call(item);
            },
            child: HeaderWidget(
              headPath: item?.portrait ?? "",
              level: (item.superUser ??false) ? 1 : 0,
              headWidth: 62.w,
              headHeight: 62.w,
            ),
          ),
          SizedBox(height: 10.w),
          Text(
            item?.name ?? "",
            maxLines: 1,
            style: TextStyle(
                fontSize: 16.w,
                color: (item?.isVip ?? false)
                    ? Color.fromRGBO(246, 197, 89, 1)
                    : Colors.white),
          ),
          SizedBox(height: 4.w),
          Text(
            item?.summary ?? "",
            maxLines: 1,
            style:
                TextStyle(fontSize: 14.w, color: Colors.white.withOpacity(0.5)),
          ),
          Spacer(),
          GestureDetector(
            onTap: () async {
              if (item?.hasFollow ?? false) {
                return;
              }
              widget.flollowTap?.call(item?.uid);
            },
            child: Visibility(
              visible: true,
              child: (item.hasFollow || item.uid == GlobalStore.getMe().uid)
                  ? Container(
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 9),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Color(0xffffffff).withOpacity(0.1),
                      ),
                      child: Text(
                        "已关注",
                        style:
                            TextStyle(color: Color(0xffd3d3d3), fontSize: 15.w),
                      ),
                    )
                  : Image.asset(
                      "assets/weibo/guanzhu.png",
                      width: 68.w,
                      height: 26.w,
                    ),
            ),
          ),
          SizedBox(height: 19.w),
        ],
      ),
    );
  }

  Widget _buildChangeFuncItemUINew(
      GuessLikeDataList item, int changeDataIndex) {
    return Container(
      width: 70.w,
      margin: EdgeInsets.only(right: 12.w),
      //padding: EdgeInsets.symmetric(horizontal: 13.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 5.w),
          GestureDetector(
            onTap: () async {
              widget.toBloggerTap?.call(item);
            },
            child: HeaderWidget(
              headPath: item?.portrait ?? "",
              level: (item.superUser??false )? 1 : 0,
              headWidth: 62.w,
              headHeight: 62.w,
            ),
          ),
          SizedBox(height: 10.w),
          Container(
            alignment: Alignment.center,
            child: Text(
              item?.name ?? "",
              maxLines: 1,
              style: TextStyle(
                  fontSize: 16.w,
                  color: (item?.isVip ?? false)
                      ? Color.fromRGBO(246, 197, 89, 1)
                      : Colors.white),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 6.w),
            alignment: Alignment.center,
            child: Text(
              item?.upTag ?? "",
              maxLines: 1,
              style: TextStyle(
                  fontSize: 10.w,
                  color:  Color(0xff7c879f)),
            ),
          ),
          SizedBox(height: 4.w),
        ],
      ),
    );
  }
}
