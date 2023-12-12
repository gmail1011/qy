import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/page/search/hot_search_list/hot_model.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    DiscoveryState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
      child: Container(
    margin: EdgeInsets.only(top: AppPaddings.appMargin),
    child: Scaffold(
      // appBar: AppBar(
      //   title: Text(Lang.NAV_DISCOVERY),
      //   automaticallyImplyLeading: false,
      //   centerTitle: true,
      //   actions: [
      //     GestureDetector(
      //       behavior: HitTestBehavior.opaque,
      //       child: Container(
      //           padding: EdgeInsets.only(right: AppPaddings.appMargin),
      //           child: svgAssets(AssetsSvg.IC_SEARCH, height: Dimens.pt15)),
      //       onTap: () {
      //         dispatch(DiscoveryActionCreator.onSearch());
      //       },
      //     )
      //   ],
      // ),
      body: pullYsRefresh(
        refreshController: state.refreshController,
        onLoading: () {
          dispatch(DiscoveryActionCreator.loadMoreData());
        },
        onRefresh: () {
          dispatch(DiscoveryActionCreator.loadData());
        },
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: AppPaddings.appMargin),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  //  crossAxisSpacing: 8,
                  // childAspectRatio: 8 / 3,
                  crossAxisSpacing: 18,
                  childAspectRatio: 154 / 68,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  var model = state.areaList[index];
                  return GestureDetector(
                    onTap: () {
                      /*eagleClick(state.selfId(),
                          sourceId: state.eagleId(viewService.context),
                          label: model.name);*/
                      dispatch(DiscoveryActionCreator.onAreaClick(model));
                    },
                    child: _getAreaItem(dispatch, model, index),
                  );
                }, childCount: state.areaList?.length ?? 0),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(
                top: AppPaddings.appMargin,
                left: AppPaddings.appMargin,
                right: AppPaddings.appMargin,
              ),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 3,
                  crossAxisSpacing: 3,
                  childAspectRatio: 0.75,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  var model = state.findList[index];
                  return GestureDetector(
                    onTap: () {
                      /*eagleClick(state.selfId(),
                          sourceId: state.eagleId(viewService.context),
                          label: model.name);*/
                      dispatch(DiscoveryActionCreator.onFindClick(model));
                    },
                    child: _getWonderfulItem(model),
                  );
                }, childCount: state.findList?.length ?? 0),
              ),
            ),
          ],
        ),
      ),
    ),
  ));
}

Widget _getWonderfulItem(FindModel model) {
  return SizedBox(
    width: Dimens.pt110,
    height: Dimens.pt146,
    child: Stack(
      children: <Widget>[
        // 卡片封面
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Container(
            color: AppColors.videoBackgroundColor,
            child: CustomNetworkImage(
              imageUrl: model.coverImg,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),

        // 标签
        Positioned(
          left: Dimens.pt10,
          bottom: Dimens.pt5,
          // child: Shimmer.fromColors(
          //   baseColor: AppColors.primaryRaised,
          //   highlightColor: Colors.yellow,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black.withOpacity(0.3)
                // gradient: LinearGradient(colors: [
                //   Color.fromRGBO(149, 79, 235, 1),
                //   Color.fromRGBO(226, 65, 239, 1),
                // ]),
                ),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text.rich(
              TextSpan(
                  style: TextStyle(color: Colors.white),
                  text: "",
                  children: <TextSpan>[
                    TextSpan(
                        text: '#',
                        style: TextStyle(
                            color: Color(0xFFFF2183),
                            fontSize: Dimens.pt16,
                            fontWeight: FontWeight.normal)),
                    TextSpan(
                        text: model.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimens.pt15,
                        )),
                  ]),
            ),
          ),
        ),
        // ),
      ],
    ),
  );
}

///获取精选专区Item
Widget _getAreaItem(Dispatch dispatch, AreaModel areaModel, int index) {
  return Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
        image: DecorationImage(
            image: ExactAssetImage(getBg(index)), fit: BoxFit.fitHeight)),
    // child: Text(
    //   areaModel.name,
    //   // style: GoogleFonts.zcoolKuaiLe(
    //   style: TextStyle(
    //     fontSize: Dimens.pt26,
    //     color: Colors.white,
    //   ),
    // ),
  );
}

// String getBg(int index) {
//   var number = index + 1;
//   var image = AssetsImages.ICON_FIND_BG1;
//   switch ((number % 4)) {
//     case 0:
//       image = AssetsImages.ICON_FIND_BG4;
//       break;
//     case 1:
//       image = AssetsImages.ICON_FIND_BG1;
//       break;
//     case 2:
//       image = AssetsImages.ICON_FIND_BG2;
//       break;
//     case 3:
//       image = AssetsImages.ICON_FIND_BG3;
//       break;

//     default:
//       image = AssetsImages.ICON_FIND_BG1;
//   }
//   return image;
// }
String getBg(int index) {
  var number = index + 1;
  var image = AssetsImages.ICON_FIND_BG2_1;
  switch ((number % 4)) {
    case 0:
      image = AssetsImages.ICON_FIND_BG2_4;
      break;
    case 1:
      image = AssetsImages.ICON_FIND_BG2_1;
      break;
    case 2:
      image = AssetsImages.ICON_FIND_BG2_2;
      break;
    case 3:
      image = AssetsImages.ICON_FIND_BG2_3;
      break;

    default:
      image = AssetsImages.ICON_FIND_BG2_1;
  }
  return image;
}
