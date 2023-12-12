import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/Adv.dart';
import 'package:flutter_app/model/HappyModel.dart';
import 'package:flutter_app/model/ShuApp.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/page/game_page/text_bg_indicator.dart';
import 'package:flutter_app/page/home/post/ads_banner_widget.dart';
import 'package:flutter_app/widget/LoadingWidget.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LouFengAdNewPage extends StatefulWidget {
  final bool showAppbar;

  const LouFengAdNewPage({Key key, this.showAppbar}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LouFengAdNewPageState();
  }
}

class _LouFengAdNewPageState extends State<LouFengAdNewPage> {
  RefreshController controller = RefreshController();
  static HappyModel dataModel;
  TabController tabController = TabController(length: 2, vsync: ScrollableState());
  List<AdsInfoBean> advApply = [];
  List<AdsInfoBean> advGame = [];

  bool get isEmptyData {
    return (dataModel?.adv?.isNotEmpty != true) && (dataModel?.shuApp?.isNotEmpty != true) && (dataModel?.shuApp?.isNotEmpty != true);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getAdvList();
      if (isEmptyData) {
        _loadData();
      }
    });
  }

  void _getAdvList() async {
    advApply = await getAdvByType(200);
    advGame = await getAdvByType(201);
    setState(() {});
  }

  void _loadData() async {
    try {
      dataModel = await netManager.client.happyList();
    } catch (e) {
      debugPrint(e.toString());
    }
    dataModel ??= HappyModel();
    controller.refreshCompleted();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppbar == true ? getCommonAppBar("娱乐") : null,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (dataModel == null) {
      return LoadingWidget();
    } else if (isEmptyData) {
      return CErrorWidget(
        "暂无数据",
        retryOnTap: () {
          dataModel = null;
          setState(() {});
          _loadData();
        },
      );
    } else {
      return Column(
        children: [
          Container(
            width: screen.screenWidth,
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(0, 6, 0, 12),
            child: TextBgIndicator(
              controller: tabController,
              titleArr: ["应用", "游戏"],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                _buildApplyView(advApply),
                _buildGameView(advGame),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _buildApplyView(List<AdsInfoBean> adsList) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 12),
          if (adsList.isNotEmpty == true)
            Container(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 18),
              child: AspectRatio(
                aspectRatio: 720 / 300,
                child: AdsBannerWidget(
                  adsList,
                  width: screen.screenWidth - 16 * 2,
                  height: (screen.screenWidth - 16 * 2) * 300 / 720,
                  mainAxisAlignment: MainAxisAlignment.end,
                  onItemClick: (index) {
                    var ad = adsList[index];
                    JRouter().handleAdsInfo(ad.href, id: ad.id);
                  },
                ),
              ),
            ),
          _buildOfficalWidget(),
          _buildHotApplyWidget(),
        ],
      ),
    );
  }

  Widget _buildOfficalWidget() {
    if (dataModel?.hengApp?.isNotEmpty != true) {
      return SizedBox();
    }
    return Column(
      children: [
        SizedBox(height: 12),
        SizedBox(
          height: 22,
          child: Row(
            children: [
              Container(
                height: 22,
                width: 8,
                decoration: BoxDecoration(
                  color: AppColors.primaryTextColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(width: 12),
              const Text(
                "官方推荐",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        GridView.builder(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: dataModel?.hengApp?.length ?? 0,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1 / 1.3,
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10, //横轴三个子widget/宽高比为1时，子widget
          ),
          itemBuilder: (context, index) {
            ShuApp appInfo = dataModel?.hengApp[index];
            return InkWell(
              onTap: () {
                netManager.client.recreationList(appInfo.id ?? "", "app");
                JRouter().handleAdsInfo(
                  appInfo.url,
                  id: appInfo.id,
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: CustomNetworkImage(
                      imageUrl: appInfo.icon,
                    ),
                  ),
                  Text(
                    appInfo.name,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHotApplyWidget() {
    if (dataModel?.shuApp?.isNotEmpty != true) {
      return SizedBox();
    }
    return Column(
      children: [
        SizedBox(height: 12),
        SizedBox(
          height: 22,
          child: Row(
            children: [
              Container(
                height: 22,
                width: 8,
                decoration: BoxDecoration(
                  color: AppColors.primaryTextColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(width: 12),
              const Text(
                "热门应用",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: dataModel?.shuApp?.length ?? 0,
          itemBuilder: (context, index) {
            ShuApp appInfo = dataModel?.shuApp[index];
            return _buildAdAppItem(appInfo);
          },
        ),
      ],
    );
  }

  Widget _buildGameView(List<AdsInfoBean> adsList) {
    return Column(
      children: [
        SizedBox(height: 12),
        if (adsList.isNotEmpty == true)
          Container(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 18),
            child: AspectRatio(
              aspectRatio: 720 / 300,
              child: AdsBannerWidget(
                adsList,
                width: screen.screenWidth - 16 * 2,
                height: (screen.screenWidth - 16 * 2) * 300 / 720,
                onItemClick: (index) {
                  var ad = adsList[index];
                  JRouter().handleAdsInfo(ad.href, id: ad.id);
                },
              ),
            ),
          ),
        SizedBox(
          height: 22,
          child: Row(
            children: [
              Container(
                height: 22,
                width: 8,
                decoration: BoxDecoration(
                  color: AppColors.primaryTextColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(width: 12),
              const Text(
                "热门推荐",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
            itemCount: dataModel?.adv?.length ?? 0,
            itemBuilder: (context, index) {
              return _buildAdImageItem(dataModel.adv[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAdImageItem(Adv model) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
      child: InkWell(
        onTap: () {
          netManager.client.recreationList(model.id ?? "", "adv");
          JRouter().handleAdsInfo(
            model.url,
            id: model.id,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 720 / 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CustomNetworkImage(
                  imageUrl: model.image,
                ),
              ),
            ),
            SizedBox(height: 6),
            Text(
              model.name,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdAppItem(ShuApp model) {
    return InkWell(
      onTap: () {
        netManager.client.recreationList(model?.id ?? "", "app");
        JRouter().handleAdsInfo(
          model.url,
          id: model.id,
        );
      },
      child: Column(
        children: [
          SizedBox(height: 15),
          SizedBox(
            height: 50,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CustomNetworkImage(
                    imageUrl: model.icon,
                    width: 50,
                    height: 50,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    model?.name ?? "",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 28,
                  width: 72,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(14)),
                    color: AppColors.primaryTextColor,
                  ),
                  child: const Text(
                    "立即下载",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            height: 1,
            color: const Color(0xff333333),
          ),
        ],
      ),
    );
  }
}
