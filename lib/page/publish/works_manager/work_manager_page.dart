import 'dart:ui';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/page/publish/works_manager/work_spread_share_page.dart';
import 'package:flutter_app/page/publish/works_manager/work_video_unit_page.dart';
import 'package:flutter_app/page/publish/works_manager/works/work_table_view.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_app/widget/keep_alive_widget.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'state.dart';

class WorkUnitManagerPage extends StatefulWidget {
  final WorksManagerState state;
  final Dispatch dispatch;
  final ViewService viewService;

  const WorkUnitManagerPage(
      {Key key, this.state, this.dispatch, this.viewService})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WorkUnitManagerPageState();
  }
}

class _WorkUnitManagerPageState extends State<WorkUnitManagerPage> {
  WorksManagerState get state => widget.state;

  ViewService get viewService => widget.viewService;

  //var _myTabs = ["已发布", "审核中", "未过审"];
  int currentIndex = 0;
  int selectStatusIndex = 0;
  List<String> statusArr = [
    "全部",
    "已通过",
    "审核中",
    "未通过",
  ];
  GlobalKey _globalKey = GlobalKey();
  GlobalKey _stackKey = GlobalKey();
  double menuPosX = 0;
  double menuPosY = 0;
  double menuWidth = 88;
  double menuHeight = 124;
  bool isShowMenu = false;
  bool isEditStatus = false;

  @override
  void initState() {
    super.initState();
    if(state.position != null) {
      selectStatusIndex = state.position;
    }
    state.tabBarController.addListener(() {
      currentIndex = state.tabBarController.index;
      setState(() {});
    });
  }

  void _selectMenu(int index) {
    int preIndex = currentIndex;
    currentIndex = index;
    state.tabBarController.index = index;
    setState(() {});
    if (currentIndex == 0 && preIndex == 0) {
      RenderBox renderBox = _globalKey.currentContext.findRenderObject();
      var size = renderBox.size;
      Offset offset = renderBox.localToGlobal(Offset.zero,
          ancestor: _stackKey.currentContext.findRenderObject());
      menuPosX = offset.dx + size.width / 2 - menuWidth / 2;
      menuPosY = offset.dy + size.height - 10;
      isShowMenu = true;
      setState(() {});
    }
  }

  void _selectStatusIndex(int index) {
    selectStatusIndex = index;
    isShowMenu = false;
    setState(() {});
  }

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
                if (currentIndex == 0)
                  Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        isEditStatus = !isEditStatus;
                        setState(() {});
                      },
                      child: Image.asset(
                        "assets/images/edit_unit.png",
                        width: 18,
                      ),
                    ),
                  ),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: (){
                    JRouter().jumpPage(PUBLISH_HELP_PAGE);
                  },
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.center,
                    child: Image.asset("assets/images/help_white.png",width: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Stack(
          key: _stackKey,
          // fit:StackFit.expand,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: () => _selectMenu(0),
                      child: _buildAllButton(
                          statusArr[selectStatusIndex], currentIndex == 0),
                    ),
                    SizedBox(width: 20),
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: () => _selectMenu(1),
                      child: _buildTextButton("推广", currentIndex == 1),
                    ),
                    SizedBox(width: 20),
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: () => _selectMenu(2),
                      child: _buildTextButton("合集", currentIndex == 2),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: state.tabBarController,
                    children: [
                      // KeepAliveWidget(WorksListPage().buildPage({"worksType": selectStatusIndex - 1})),
                      //  KeepAliveWidget(WorksListPage().buildPage({"worksType": 1})),
                      // KeepAliveWidget(WorksListPage().buildPage({"worksType": 2})),
                      KeepAliveWidget(
                        WorkTableView(
                          key: ValueKey(selectStatusIndex),
                          status: selectStatusIndex - 1,
                          isEditStatus: isEditStatus,
                        ),
                      ),
                      KeepAliveWidget(WorkSpreadSharePage()),
                      KeepAliveWidget(WorkVideoUnitPage()),
                    ],
                  ),
                ),
              ],
            ),
            if (isShowMenu)
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  isShowMenu = false;
                  setState(() {});
                },
                child: Stack(
                  children: [
                    Positioned(
                      top: menuPosY,
                      left: menuPosX,
                      child: Container(
                        width: menuWidth,
                        height: menuHeight,
                        decoration: BoxDecoration(
                          color: Color(0xff272727),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: ListView.builder(
                          itemCount: statusArr.length,
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                _selectStatusIndex(index);
                              },
                              child: Container(
                                height: menuHeight / statusArr.length,
                                child: Column(
                                  children: [
                                    if (index != 0)
                                      Container(
                                        color: Color(0xff38393b),
                                        height: 1,
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 2),
                                      ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          statusArr[index],
                                          style: TextStyle(
                                            color: Color(0xffdbdbdb),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllButton(String title, bool isSelected) {
    return Container(
      key: _globalKey,
      padding: EdgeInsets.only(bottom: 12, right: 12, left: 12, top: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w300,
                  color: isSelected ? Colors.white : Color(0xff747a89),
                ),
              ),
              SizedBox(width: 1),
              Icon(
                isShowMenu
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 14,
                color: isSelected ? Colors.white : Color(0xff747a89),
              ),
            ],
          ),
          SizedBox(height: 1),
          Container(
            width: 16,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: isSelected ? Color(0xffeb8737) : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextButton(String title, bool isSelected) {
    return Container(
      padding: EdgeInsets.only(bottom: 12, right: 12, left: 12, top: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w300,
              color: isSelected ? Colors.white : Color(0xff747a89),
            ),
          ),
          SizedBox(height: 1),
          Container(
            width: 16,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: isSelected ? Color(0xffeb8737) : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
