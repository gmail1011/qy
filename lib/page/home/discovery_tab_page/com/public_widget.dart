import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/audiobook_list_model.dart';
import 'package:flutter_app/model/audiobook_model.dart';
import 'package:flutter_app/model/novel_model.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/dialog/vip_level_dialog.dart';
import 'package:flutter_app/widget/round_under_line_tab_indicator.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/light_model.dart';

enum NOVEL_SEARCH_PAGE_TYPE {
  PAGE_NOVEL,
  PAGE_AUDIOBOOK,
}

/// 激情小说列表入口类型
enum NOVEL_ENTRANCE {
  /// 主页
  MAIN,

  /// 浏览记录
  BROWSE,

  /// 收藏记录
  COLLECT,

  /// 搜索页面
  SEARCH,
}

/// 热门小说item
Widget hotItem(int index, dynamic item, {VoidCallback onClick}) {
  return GestureDetector(
    onTap: () {
      if (onClick != null) {
        onClick();
      }
    },
    child: Container(
      padding: EdgeInsets.symmetric(
        vertical: 3,
        horizontal: AppPaddings.appMargin,
      ),
      child: Text(
        '${index + 1}、${item.title}',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          color: Colors.white,
          fontSize: Dimens.pt10,
        ),
      ),
    ),
  );
}

/// 添加浏览过的有声小说
void setAudioBookBrowse(AudioBook item, [int maxCacheNum = 500]) async {
  item.anchor = item.anchorInfo.name;
  String str = await lightKV.getString('audio_book_list');
  AudioBookListModel novelModel;
  // 缓存中是否有该项
  if (TextUtil.isEmpty(str)) {
    novelModel = AudioBookListModel(list: []);
  } else {
    var map = jsonDecode(str);
    novelModel = AudioBookListModel.fromJson(map);
    for (var i = 0; i < novelModel.list.length; i++) {
      var oldItem = novelModel.list[i];
      if (oldItem.id == item.id) {
        novelModel.list.remove(oldItem);
        break;
      }
    }
  }
  novelModel.list.insert(0, item);
  int length = novelModel.list.length;
  if (length > maxCacheNum) {
    novelModel.list.removeRange(maxCacheNum, length);
  }
  String novelModelJson = jsonEncode(novelModel.toJson());
  lightKV.setString('audio_book_list', novelModelJson);
}

/// 获取浏览过的有声小说
Future<AudioBookListModel> getAudioBookBrowse(
    int pageNumber, int pageSize) async {
  String str = await lightKV.getString('audio_book_list');
  AudioBookListModel novelModel;
  if (TextUtil.isEmpty(str)) {
    novelModel = AudioBookListModel(list: []);
    novelModel.hasNext = false;
  } else {
    var map = jsonDecode(str);
    novelModel = AudioBookListModel.fromJson(map);
    var list = novelModel.list;
    bool hasNext = list.length > pageSize * pageNumber;
    int start = (pageNumber - 1) * pageSize;
    int end = hasNext ? pageNumber * pageSize : list.length;
    novelModel.list = list.sublist(start, end);
    novelModel.hasNext = hasNext;
  }
  return novelModel;
}

/// 添加浏览过的激情小说
void setBrowseRecording(NoveItem item, [int maxCacheNum = 500]) async {
  String str = await lightKV.getString('browse_list');
  NovelModel novelModel;
  // 缓存中是否有该项
  if (TextUtil.isEmpty(str)) {
    novelModel = NovelModel(list: []);
  } else {
    var map = jsonDecode(str);
    novelModel = NovelModel.fromJson(map);
    for (var i = 0; i < novelModel.list.length; i++) {
      var oldItem = novelModel.list[i];
      if (oldItem.id == item.id) {
        novelModel.list.remove(oldItem);
        break;
      }
    }
  }
  novelModel.list.insert(0, item);
  int length = novelModel.list.length;
  if (length > maxCacheNum) {
    novelModel.list.removeRange(maxCacheNum, length);
  }
  String novelModelJson = jsonEncode(novelModel.toJson());
  lightKV.setString('browse_list', novelModelJson);
}

/// 获取浏览过的激情小说
Future<NovelModel> getBrowseRecording(int pageNumber, int pageSize) async {
  String str = await lightKV.getString('browse_list');
  NovelModel novelModel;
  if (TextUtil.isEmpty(str)) {
    novelModel = NovelModel(list: []);
    novelModel.hasNext = false;
  } else {
    var map = jsonDecode(str);
    novelModel = NovelModel.fromJson(map);
    var list = novelModel.list;
    bool hasNext = list.length > pageSize * pageNumber;
    int start = (pageNumber - 1) * pageSize;
    int end = hasNext ? pageNumber * pageSize : list.length;
    novelModel.list = list.sublist(start, end);
    novelModel.hasNext = hasNext;
  }
  return novelModel;
}

/// 下划线TabBar
// ignore: must_be_immutable
class UnderLineTabBar extends StatelessWidget {
  final List<String> tabs;
  final TabController tabController;
  final double insetsBottom;
  final ValueChanged<int> onTab;
  double fontSize;

  UnderLineTabBar({
    Key key,
    @required this.tabs,
    @required this.tabController,
    this.fontSize,
    this.insetsBottom = -4,
    this.onTab,
  }) : super(key: key) {
    if (fontSize == null) fontSize = Dimens.pt15;
  }
  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: true,
      controller: tabController,
      tabs: tabs
          .map(
            (text) => Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),
          )
          .toList(),
      onTap: (index) {
        if (onTab != null) {
          onTab(index);
        }
      },
      unselectedLabelColor: Colors.white,
      labelColor: Color(0xffFF84C3),
      indicator: RoundUnderlineTabIndicator(
        insets: EdgeInsets.only(bottom: insetsBottom),
        borderSide: BorderSide(
          width: 2,
          color: Color(0xffFF84C3),
        ),
      ),
    );
  }
}

/// 渐变线条
class ColorLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff2F2F5F),
            Colors.white,
            Color(0xff2F2F5F),
          ],
        ),
      ),
    );
  }
}

/// 激情小说item
Widget passionItem(NoveItem item,
    [ValueChanged<NoveItem> waitCb, EagleHelper helper, BuildContext ctx]) {
  return GestureDetector(
    onTap: () async {
      if (null != helper && null != ctx) {
        /*eagleClick(helper.selfId(),
            sourceId: helper.eagleId(ctx),
            label: "novel:${GlobalStore.isVIP()}");*/
      }
      if (!GlobalStore.isVIP()) {
        showVipLevelDialog(
          FlutterBase.appContext,
          Lang.VIP_LEVEL_DIALOG_MSG2,
        );
        return;
      }
      int countCollect =
          await JRouter().go(PAGE_NOVEL_PLAYER, arguments: {'id': item.id});
      if (waitCb != null) {
        if (countCollect != null) {
          item.countCollect = countCollect;
        }
        item.countBrowse += 1;
        waitCb(item);
      }
      setBrowseRecording(item);
    },
    child: Container(
      margin: EdgeInsets.symmetric(vertical: Dimens.pt5),
      padding: EdgeInsets.all(Dimens.pt10),
      decoration: BoxDecoration(
        color: Color(0xff292970),
        borderRadius: BorderRadius.circular(Dimens.pt5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontSize: Dimens.pt16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: Dimens.pt16),
            child: ColorLine(),
          ),
          Text(
            item.summary,
            overflow: TextOverflow.ellipsis,
            maxLines: 5,
            style: TextStyle(
              fontSize: Dimens.pt11,
              color: Colors.white60,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: Dimens.pt16),
            child: ColorLine(),
          ),
          Row(
            children: [
              Row(
                children: [
                  svgAssets(
                    AssetsSvg.IC_EYE,
                    height: Dimens.pt10,
                    color: Colors.white60,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: Dimens.pt4),
                    margin: EdgeInsets.only(right: Dimens.pt16),
                    child: Text(
                      '${(item.countBrowse ?? 0) == 0 ? Lang.BROWSE : getShowCountStr(item.countBrowse)}',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: Dimens.pt10,
                      ),
                    ),
                  ),
                ],
              ),
              // 收藏
              Row(
                children: [
                  svgAssets(
                    AssetsSvg.NO_COLLECTION,
                    height: Dimens.pt10,
                    color: Colors.white60,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: Dimens.pt4),
                    margin: EdgeInsets.only(right: Dimens.pt10),
                    child: Text(
                      '${(item.countCollect ?? 0) == 0 ? Lang.COLLECT : getShowCountStr(item.countCollect)}',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: Dimens.pt10,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
