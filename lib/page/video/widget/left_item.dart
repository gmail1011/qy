import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/provider/countdown_update_model.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/user/member_centre_page/vip/vip_countdown_widget.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/weibo_page/widget/word_rich_text.dart';
import 'package:flutter_app/widget/custom_label_widget.dart';
import 'package:flutter_app/widget/shadow_text.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

/// 首页搜索按钮视图
class LeftItem extends StatefulWidget {
  final VideoModel videoModel;
  final int index;

  /// 是否显示视频发布时间，目前只有（推荐）不显示
  final bool isDisplayTime;

  /// 点击标签
  final ValueChanged<int> onTag;
  final VoidCallback onCity;
  final VoidCallback onBuy;
  final VoidCallback onBuyVip;

  LeftItem(this.videoModel, this.index, this.isDisplayTime, this.onTag,
      this.onCity, this.onBuy, this.onBuyVip,
      {Key key})
      : super(key: key);

  @override
  _LeftItemState createState() => new _LeftItemState();
}

class _LeftItemState extends State<LeftItem> {
  bool visible = true;
  bool isShowBuy = false;

  ///判断是否需要购买

  @override
  void initState() {
    super.initState();

    bus.on(EventBusUtils.buySuccess, (arg) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///标签列表
    var tagItem = (widget.videoModel?.tags?.length ?? 0) == 0
        ? Container()
        : Padding(
            padding: EdgeInsets.only(top: 6),
            child: getTagItem(),
          );

    ///作者名称
    Widget authorItem;
    if ((widget.videoModel?.publisher?.name ?? "").isNotEmpty) {
      authorItem = Padding(
        padding: EdgeInsets.only(top: 6),
        child: getAuthorItem(),
      );
    }

    ///内容
    Widget contentItem;
    if ((widget.videoModel?.title ?? "").isNotEmpty) {
      contentItem = Padding(
        padding: EdgeInsets.only(top: 6),
        child: getContentItem(),
      );
    }

    ///金币视频
    Widget buyItem;

    /// 有价格 且 不是自己的作品
    if (!GlobalStore.isMe(widget.videoModel.publisher?.uid) &&
        (widget.videoModel.originCoins ?? 0) > 0 &&
        widget.videoModel.vidStatus?.hasPaid == false) {
      isShowBuy = true;
    }

    if (Config.videoId.contains(widget.videoModel.id)) {
      isShowBuy = false;
    }

    ///需要购买的提示
    if (isShowBuy == true) {
      buyItem = Padding(
        padding: EdgeInsets.only(top: 10),
        child: Row(
          children: [
            if (!GlobalStore.isVIP()) _buildBuyItemByVip(),
            getBuyItem(),
          ],
        ),
      );
    } else {
      ///提示已购买完整版
      if (widget.videoModel.vidStatus?.hasPaid ?? false) {
        buyItem = Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Color(0xff1b1c21).withOpacity(0.27),
              border: Border.all(color: Colors.white, width: 0.5)),
          margin: EdgeInsets.only(
            top: 6.w,
          ),
          child: Text(
            "已购买完整版",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      } else {
        ///不需要购买视频-不是VIP的判断-是否我自己的视频
        if (!GlobalStore.isVIP() &&
            !GlobalStore.isMe(widget.videoModel?.publisher?.uid)) {
          buyItem = _buildItemByVip();
        }
      }
    }

    ///倒计时
    // 有条件 add item
    var itemList = <Widget>[];

    if (buyItem != null) {
      itemList.add(buyItem);
    }
    if (authorItem != null) {
      itemList.add(authorItem);
    }
    if (contentItem != null) {
      itemList.add(contentItem);
    }

    itemList.add(tagItem);

    itemList.add(_buildCountDownUI());

    /// 左下角控件
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: itemList,
      ),
    );
  }

  Widget _buildCountDownUI() {
    return Consumer<CountdwonUpdate>(builder: (context, value, Widget child) {
      Countdown countdown = value.countdown;
      if (countdown?.countdownSec == 0) {
        return Container();
      }
      return Container(
        margin: EdgeInsets.only(top: Dimens.pt6),
        padding: EdgeInsets.only(left: Dimens.pt26, right: Dimens.pt26),
        height: Dimens.pt30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient:
                LinearGradient(colors: [Color(0xfff7d599), Color(0xfff5b771)])),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${(countdown?.copywriting ?? "").isNotEmpty ? countdown?.copywriting : "新人限时"}",
              style: TextStyle(
                color: Color(0xff333333),
                fontSize: Dimens.pt15,
              ),
            ),
            SizedBox(width: Dimens.pt8),
            VIPCountDownWidget(
              fontSize: Dimens.pt15,
              color: Color(0xff333333),
              seconds: countdown.countdownSec ?? 0,
              countdownEnd: () {},
              countdownChange: (_seconds) {
                countdown.countdownSec = _seconds;
                Provider.of<CountdwonUpdate>(context, listen: false)
                    .setCountdown(countdown);
              },
            ),
          ],
        ),
      );
    });
  }

  /// 最热视频
  Widget getHotItem() {
    var rank = 13;
    var playCount = 12;
    var title = "今日最热视频NO.$rank | 今日播放$playCount";
    return Container(
      padding: EdgeInsets.only(bottom: 0),
      width: screen.screenWidth - Dimens.pt10,
      height: Dimens.pt30,
      decoration: BoxDecoration(
        color: Color(0x55E9E9E9), // 半透明底色
        borderRadius: BorderRadius.circular((4.0)), // 圆角度
      ),
      child: Stack(
        children: <Widget>[
          Row(
            children: <Widget>[
              svgAssets(AssetsSvg.RECD_RANK_1),
              Padding(
                  padding: EdgeInsets.only(left: Dimens.pt6),
                  child: ShadowText(
                    title,
                    maxLines: 1,
                    fontSize: Dimens.pt13,
                    color: Color(0XFFFFCA00),
                  )),
            ],
          ),
          Positioned(
            right: 0,
            child: GestureDetector(
              child: Container(
                padding: EdgeInsets.only(right: 10),
                child: svgAssets(AssetsSvg.RECD_ARROW_YR),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 购买模块
  Widget getBuyItem() {
    bool isBuy = widget.videoModel?.vidStatus?.hasPaid ?? false;
    int vipPrice = widget.videoModel?.originCoins ?? 0;
    if((widget.videoModel?.coins ?? 0) > 0){
      vipPrice = widget.videoModel?.coins ?? 0;
    }
    var buyItem = GestureDetector(
        onTap: () {
          if (!isBuy) widget.onBuy?.call();
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Color(0xff1b1c21).withOpacity(0.27),
              border: Border.all(color: Colors.white, width: 0.5)),
          child: Text(
            "${GlobalStore.isVIP() ? vipPrice : widget.videoModel?.originCoins}金币购买",
            style: TextStyle(color: Colors.white, fontSize: 14.w),
          ),
        ));
    return Visibility(
      visible: isBuy ? false : true,
      child: Container(
        child: Row(
          children: <Widget>[buyItem],
        ),
      ),
    );
  }

  ///提示开通VIP 的金币价格
  Widget _buildBuyItemByVip() {
    bool isBuy = widget.videoModel?.vidStatus?.hasPaid ?? false;
    int vipCoins = widget.videoModel?.coins ?? 0;
    if(vipCoins <= 0){
      vipCoins = widget.videoModel?.originCoins ?? 0;
    }
    var buyItem = GestureDetector(
        onTap: () {
          if (!isBuy) widget.onBuyVip?.call();
        },
        child: Container(
          margin: EdgeInsets.only(right: 10),
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Color(0xff1b1c21).withOpacity(0.27),
              border: Border.all(color: Colors.white, width: 0.5)),
          child: Text(
            "开通VIP $vipCoins金币",
            style: TextStyle(color: Colors.white, fontSize: 14.w),
          ),
        ));
    return Visibility(
      visible: isBuy ? false : true,
      child: Container(
        child: Row(
          children: <Widget>[buyItem],
        ),
      ),
    );
  }

  /// 模块3-buy Vip
  Widget _buildItemByVip() {
    var buyItem = GestureDetector(
        onTap: () {
          widget.onBuyVip?.call();
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Color(0xff1b1c21).withOpacity(0.27),
              border: Border.all(color: Colors.white, width: 0.5)),
          child: Text(
            "开通VIP观看完整版",
            style: TextStyle(color: Colors.white, fontSize: 14.w),
          ),
        ));
    return Container(
      child: Row(
        children: <Widget>[buyItem],
      ),
    );
  }

  /// 视频内容
  Widget getContentItem() {
    // 数据
    String content = widget.videoModel.title ?? "";
    return Container(
        width: Dimens.pt274,
        child: ShadowText(
          content,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          maxLines: 1,
          fontSize: 16.w,
          color: Colors.white,
        ));
  }

  /// 视频作者
  Widget getAuthorItem() {
    String author = "@${widget.videoModel.publisher?.name}  ";
    return ShadowText(author,
        maxLines: 1,
        fontSize: 18.w,
        color: Colors.white,
        fontWeight: FontWeight.bold);
  }

  /// [你的关注] 字
  Widget getYouFollowItem() {
    return Container(
      child: svgAssets(AssetsSvg.RECOMMEND_YOU_FOLLOW,
          width: Dimens.pt70, height: Dimens.pt20),
    );
  }

  /// 标签模块
  Widget getTagItem() {
    List<String> data1 = []; // [ "激情口爆", "户外野战", "蜜桃翘臀", "高跟蕾丝", "蜜汁美乳", ];
    for (var item in( widget.videoModel.tags ?? [])) {
      data1.add(item.name);
    }
    return CustomLabelWidget(list: data1, fontSize: 16.w, onTag: widget.onTag);
  }

  /// 城市模块
  Widget getCityItem() {
    // 数据
    String cityName = widget.videoModel.location?.city ?? "";

    var cityTitle = ShadowText(
      cityName,
      fontSize: 14.w,
      color: Colors.white,
    );

    return Container(
      child: GestureDetector(
        onTap: () {
          widget.onCity();
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding:
                  EdgeInsets.only(right: 8.w, top: 4.w, left: 8.w, bottom: 4.w),
              decoration: BoxDecoration(
                color: AppColors.black28, // 半透明底色
                borderRadius: BorderRadius.circular((4)), // 圆角度
              ),
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/weibo/video_location.png",
                      width: 16.w,
                      height: 16.w,
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    cityTitle
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
