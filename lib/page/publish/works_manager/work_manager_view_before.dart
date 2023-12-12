import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/page/publish/works_manager/work_spread_share_page.dart';
import 'package:flutter_app/page/publish/works_manager/work_video_unit_page.dart';
import 'package:flutter_app/page/publish/works_manager/works/page.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_app/widget/keep_alive_widget.dart';
import 'package:flutter_app/widget/round_under_line_tab_indicator.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';

import 'action.dart';
import 'state.dart';

class WorkManagerView extends StatefulWidget {
  final WorksManagerState state;
  final Dispatch dispatch;
  final ViewService viewService;

  const WorkManagerView({Key key, this.state, this.dispatch, this.viewService})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WorkManagerViewState();
  }
}

class _WorkManagerViewState extends State<WorkManagerView> {
  WorksManagerState get state => widget.state;

  Dispatch get dispatch => widget.dispatch;

  ViewService get viewService => widget.viewService;
  //var _myTabs = ["已发布", "审核中", "未过审"];
  var _myTabs = ["已发布", "推广", "合集"];
  @override
  Widget build(BuildContext context) {
    return FullBg(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => safePopPage(),
          ),
          title:
              Text("作品管理", style: TextStyle(fontSize: AppFontSize.fontSize18)),
          actions: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  child: Visibility(
                    visible: state.isEditModel ?? false,
                    child: GestureDetector(
                      onTap: () => viewService
                          .broadcast(WorksManagerActionCreator.notifyDel()),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: svgAssets(AssetsSvg.ICON_MINE_EDIT,
                            width: 16, height: 16),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  child: Visibility(
                    visible: true,
                    child: GestureDetector(
                      onTap: () => {
                        JRouter().jumpPage(PUBLISH_HELP_PAGE),
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: svgAssets(AssetsSvg.ICON_HELP,
                            width: 16, height: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(25),
            child: commonTabBar(
              TabBar(
                controller: state.tabBarController,
                tabs: _myTabs.map((e) => Text(e)).toList(),
                indicator: RoundUnderlineTabIndicator(
                  borderSide: BorderSide(color: AppColors.weiboColor, width: 2),
                ),
                indicatorWeight: 4,
                unselectedLabelColor: Color.fromRGBO(115, 122, 139, 1),
                labelColor: Colors.white,
                labelStyle: TextStyle(fontSize: Dimens.pt16),
                unselectedLabelStyle: TextStyle(fontSize: Dimens.pt16),
                isScrollable: true,
                labelPadding: EdgeInsets.symmetric(horizontal: 30),
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: state.tabBarController,
          children: [
            KeepAliveWidget(WorksListPage().buildPage({"worksType": 0})),
          //  KeepAliveWidget(WorksListPage().buildPage({"worksType": 1})),
           // KeepAliveWidget(WorksListPage().buildPage({"worksType": 2})),
            KeepAliveWidget(WorkSpreadSharePage()),
            KeepAliveWidget(WorkVideoUnitPage()),
          ],
        ),
      ),
    );
  }
}
