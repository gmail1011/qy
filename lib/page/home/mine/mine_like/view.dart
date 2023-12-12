import 'package:cached_network_image/cached_network_image.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_cache_manager.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_app/widget/common_widget/load_more_footer.dart';
import 'package:flutter_app/widget/common_widget/empty_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/time_helper.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    MineLikePostState state, Dispatch dispatch, ViewService viewService) {
  ListAdapter adapter = viewService.buildAdapter();
  return !state.loadComplete
      ? Container(
          child: Center(
          child: LoadingWidget(),
        ))
      : pullYsRefresh(
          refreshController: state.controller,
          enablePullDown: false,
          onLoading: () async {
            if (state.hasNext ?? false) {
              if (state.loadComplete) {
                dispatch(MineLikePostActionCreator.setLoadFinish(false));
                dispatch(MineLikePostActionCreator.onLoadData());
              }
            }
          },
          child: /*SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 0.5,
                crossAxisSpacing: 0.3,
                childAspectRatio: 0.7, //子控件宽高比
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return adapter.itemBuilder(context, index);
              }, childCount: adapter.itemCount),
            ),*/

          StaggeredGridView.countBuilder(
            //controller: state.scrollController,
            crossAxisCount: 4,
            itemCount: adapter.itemCount,
            staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            itemBuilder: ((context, index) {
              return adapter.itemBuilder(context, index);
            }),
          ),
        );
}
