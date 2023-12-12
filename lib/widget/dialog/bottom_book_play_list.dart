import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/local_store/local_audio_store.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/audiobook_model.dart';
import 'package:flutter_app/utils/asset_util.dart';
import 'package:flutter_app/widget/dialog/vip_level_dialog.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';

/// 有声小说播放列表弹框
Future<int> showBookPlayListDialog(
  BuildContext context,
  AudioBook model, {
  int playIndex = 0,
  ValueChanged<int> onClickList,
}) async {
  return await showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) {
      return BookPlayList(
          model: model, playIndex: playIndex, onClickList: onClickList);
    },
  );
}

/// 有声小说播放列表
class BookPlayList extends StatefulWidget {
  final AudioBook model;
  final int playIndex;

  /// 选集
  final ValueChanged<int> onClickList;

  const BookPlayList(
      {Key key, @required this.model, this.playIndex, this.onClickList})
      : super(key: key);

  @override
  _BookPlayListState createState() => _BookPlayListState();
}

class _BookPlayListState extends State<BookPlayList> {
  AudioBook model;

  /// 当前播放位置
  int playIndex;

  /// 当前播放列表contentSet
  List<EpisodeModel> list;

  /// 对应缓存列表
  List<AudioEpisodeRecord> cacheList = [];

  /// 用户是不是会员
  bool isVip = GlobalStore.isVIP();

  /// 控制器
  ScrollController controller;

  /// 是否显示购买组件
  bool showBuyWidget = false;

  @override
  void initState() {
    model = widget.model;
    playIndex = widget.playIndex;
    list = model?.contentSet ?? [];
    showBuyWidget =
        (list[playIndex].listenPermission == 1) && !list[playIndex].isBrought;
    controller = ScrollController(initialScrollOffset: getScrollOffset());
    getPlayList();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  /// 获取缓存列表
  void getPlayList() async {
    /// 缓存列表
    List<AudioEpisodeRecord> playList = [];
    for (var i = 0; i < list.length; i++) {
      EpisodeModel item = list[i];
      AudioEpisodeRecord audioEpisodeRecord =
          await LocalAudioStore().getRecord(model.id, item.episodeNumber);
      if (audioEpisodeRecord == null) {
        audioEpisodeRecord = AudioEpisodeRecord(model, item, 0, 1);
      }
      playList.add(audioEpisodeRecord);
    }
    setState(() {
      cacheList = playList;
    });
  }

  /// 获取初始化滚动位置
  double getScrollOffset() {
    if (playIndex == 0) {
      return 0;
    }
    return (playIndex - 1) * Dimens.pt40;
  }

  /// 点击播放列表
  void clickList(EpisodeModel item, int index) {
    switch (item.listenPermission) {
      // 会员
      case 0:

        /// 用户是会员
        if (isVip) {
          widget.onClickList?.call(index);
          setState(() {
            playIndex = index;
            showBuyWidget = false;
          });
        } else {
          //用户不是会员
          safePopPage();
          showVipLevelDialog(
            context,
            Lang.VIP_LEVEL_DIALOG_MSG1,
          );
        }
        break;
      // 金币
      case 1:
        // 用户是否购买
        bool isBrought = item.isBrought ?? false;
        if (!isBrought) {
          showToast(msg: '购买之后才能收听哦');
        } else {
          widget.onClickList?.call(index);
        }
        setState(() {
          playIndex = index;
          showBuyWidget = !isBrought;
        });
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimens.pt5),
          topRight: Radius.circular(Dimens.pt5),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: Dimens.pt40,
            padding: EdgeInsets.symmetric(horizontal: AppPaddings.appMargin),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xffD9D9D9),
                  width: .5,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    model.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: Dimens.pt12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: controller,
              itemBuilder: (BuildContext context, int index) {
                var item = list[index];
                var cacheItem = cacheList[index];

                /// 是否需要金币购买(listenPermission为1代表需要金币购买，isBrought为false即是还没有购买)
                // item.listenPermission = 1;
                // item.isBrought = false;

                /// 是否是播放当前item
                bool isCurrent = (index == playIndex);

                return GestureDetector(
                  /// 点击播放列表
                  onTap: () {
                    clickList(item, index);
                  },
                  child: _BookPlayListItem(
                      item: item,
                      isCurrent: isCurrent,
                      progress: cacheItem.progress),
                );
              },

              /// 用缓存数组长度 避免还为取到缓存值就刷新问题
              itemCount: cacheList.length,
            ),
          ),
          Visibility(
            visible: showBuyWidget,
            child: GestureDetector(
              onTap: () => safePopPage(playIndex),
              child: Container(
                height: Dimens.pt40,
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 10, left: 40, right: 40),
                padding: EdgeInsets.symmetric(horizontal: Dimens.pt30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xff2A72E3), Color(0xff0057BB)]),
                  borderRadius: BorderRadius.circular(Dimens.pt20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text.rich(
                        TextSpan(
                          text: '${list[playIndex].price}',
                          style: TextStyle(fontSize: Dimens.pt18),
                          children: [
                            TextSpan(
                              text: '金币  ',
                              style: TextStyle(
                                fontSize: Dimens.pt10,
                              ),
                            ),
                            TextSpan(
                              text: '${list[playIndex].name}',
                              style: TextStyle(
                                  fontSize: Dimens.pt8, color: Colors.white60),
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      '单集购买',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimens.pt16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 全部购买
          Visibility(
            visible: model.originalPrice != 0,
            child: Container(
              margin: EdgeInsets.only(bottom: 20, top: 16),
              child: GestureDetector(
                onTap: () => safePopPage(-1),
                child: Stack(
                  overflow: Overflow.visible,
                  children: [
                    Container(
                      height: Dimens.pt40,
                      padding: EdgeInsets.symmetric(horizontal: Dimens.pt30),
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimens.pt20),
                        color: Color(0xffE51F1F),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                                                      child: Text.rich(
                              TextSpan(
                                text: '${model.discountPrice}',
                                style: TextStyle(fontSize: Dimens.pt18),
                                children: [
                                  TextSpan(
                                    text: '金币  ',
                                    style: TextStyle(
                                      fontSize: Dimens.pt10,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '总价 ${model.originalPrice}金币',
                                    style: TextStyle(
                                      fontSize: Dimens.pt8,
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.white60,
                                    ),
                                  ),
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            '全集购买',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimens.pt16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -Dimens.pt8,
                      left: Dimens.pt3 + 40,
                      child: assetsImg(
                        AssetsImages.BENEFIT,
                        height: Dimens.pt25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _getStr(type, int price, bool isBrought) {
  String str = '';
  switch (type) {
    case 0:
      str = '会员';
      break;
    case 1:
      str = isBrought ? '已购买' : '${price ?? 0}金币';
      break;
    default:
  }
  return str;
}

/// 列表item
class _BookPlayListItem extends StatelessWidget {
  final EpisodeModel item;

  /// 当前是否播放
  final bool isCurrent;

  /// 进度
  final double progress;

  const _BookPlayListItem(
      {Key key,
      @required this.item,
      @required this.isCurrent,
      this.progress = 0})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimens.pt40,
      padding: EdgeInsets.symmetric(horizontal: AppPaddings.appMargin),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xffD9D9D9),
            width: .5,
          ),
        ),
      ),
      child: Row(
        children: [
          Flexible(
            child: Row(
              children: [
                Visibility(
                  visible: isCurrent,
                  child: Container(
                    margin: EdgeInsets.only(right: Dimens.pt20),
                    child: assetsImg(AssetsImages.ARTICLE, height: Dimens.pt12),
                  ),
                ),
                Flexible(
                  child: Text(
                    '${item.name}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: Dimens.pt10,
                      color: isCurrent ? Color(0xffCE3636) : Colors.black87,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: Dimens.pt10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  visible: progress != 0,
                  child: Text(
                    '已播${((progress * 10000).floor()) / 100}%      ',
                    style: TextStyle(
                      fontSize: Dimens.pt10,
                      color: isCurrent ? Color(0xffCE3636) : Color(0xffBB8D2F),
                    ),
                  ),
                ),
                Text(
                  _getStr(item.listenPermission, item.price, item.isBrought),
                  style: TextStyle(
                    fontSize: Dimens.pt10,
                    color: isCurrent ? Color(0xffCE3636) : Color(0xffBB8D2F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
