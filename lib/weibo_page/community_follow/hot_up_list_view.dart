import 'package:flutter/material.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/local_router/jump_router.dart';
import '../../common/local_router/route_map.dart';
import '../../common/net2/net_manager.dart';
import '../../utils/EventBusUtils.dart';
import '../../widget/common_widget/header_widget.dart';
import '../community_recommend/search/guess_like_entity.dart';

class HotUpListView extends StatefulWidget {
  final ValueChanged<dynamic> toBloggerTap;

  HotUpListView({
    this.toBloggerTap,
  });

  @override
  State<StatefulWidget> createState() {
    return _HotUpListViewState();
  }
}

class _HotUpListViewState extends State<HotUpListView> {
  List<GuessLikeDataList> changeDataList = [];

  @override
  void initState() {
    super.initState();
    getGuessLikeList();
  }

  @override
  void dispose() {
    ImageCache _imageCache = PaintingBinding.instance.imageCache;
    _imageCache.clear();
    super.dispose();
  }

  void getGuessLikeList() async {
    changeDataList = await netManager.client.getRecommendChangeFuncList();
    setState(() {});
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
                    return _buildChangeFuncItemUINew(changeDataList[index]);
                  },
                  itemCount: changeDataList?.length ?? 0),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildChangeFuncItemUINew(GuessLikeDataList item) {
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
              style: TextStyle(fontSize: 10.w, color: Color(0xff7c879f)),
            ),
          ),
          SizedBox(height: 4.w),
        ],
      ),
    );
  }
}
