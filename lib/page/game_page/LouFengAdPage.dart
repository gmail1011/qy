import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/Adv.dart';
import 'package:flutter_app/model/HappyModel.dart';
import 'package:flutter_app/model/ShuApp.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LouFengAdPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LouFengAdPageState();
  }
}

class _LouFengAdPageState extends State<LouFengAdPage> {
  RefreshController controller = RefreshController();
  HappyModel dataModel;

  bool get isEmptyData {
    return (dataModel?.adv?.isNotEmpty != true) && (dataModel?.shuApp?.isNotEmpty != true);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData();
    });
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
      return pullYsRefresh(
        refreshController: controller,
        enablePullUp: false,
        enablePullDown: false,
        onRefresh: _loadData,
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                if ((dataModel?.adv?.length ?? 0) > 3)
                  Container(
                    height: 300,
                    child: ListView.builder(
                      padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
                      itemCount: dataModel?.adv?.length ?? 0,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _buildAdImageItem(dataModel.adv[index]);
                      },
                    ),
                  )
                else
                  ListView.builder(
                    padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
                    itemCount: dataModel?.adv?.length ?? 0,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _buildAdImageItem(dataModel.adv[index]);
                    },
                  ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 22,
                  child: Row(
                    children: [
                      Container(
                        height: 22,
                        width: 8,
                        decoration: BoxDecoration(
                          gradient: AppColors.linearBackGround,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(4),
                            bottomRight: Radius.circular(4),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      const Text(
                        "推荐-热门",
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 6),
                ListView.builder(
                  padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
                  itemCount: dataModel?.shuApp?.length ?? 0,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return _buildAdAppItem(dataModel.shuApp[index]);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildAdImageItem(Adv model) {
    return Container(
      padding: EdgeInsets.only(top: 12),
      child: InkWell(
        onTap: () {
          netManager.client.recreationList(model.id ?? "", "adv");
          JRouter().handleAdsInfo(
            model.url,
            id: model.id,
          );
        },
        child: AspectRatio(
          aspectRatio: 720 / 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CustomNetworkImage(
              borderRadius: 12,
              imageUrl: model.image,
            ),
          ),
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
          SizedBox(height: 10),
          SizedBox(
            height: 56,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: CustomNetworkImage(
                    imageUrl: model.icon,
                    width: 56,
                    height: 56,
                  ),
                ),
                SizedBox(width: 6),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model?.name ?? "",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "下载次数：${model.getDownLoadNumDesc()}",
                        style:  TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 24,
                  width: 72,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    //order: Border.all(color: const Color.fromRGBO(238, 126, 139, 1),width: 1),
                    gradient: AppColors.linearBackGround,
                    borderRadius: const BorderRadius.all(Radius.circular(14)),
                  ),
                  child:  Text(
                    "立即下载",
                    style: TextStyle(color: Color(0xff333333), fontSize: 12),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 1,
            color: const Color(0xffdedede).withOpacity(0.14),
          ),
        ],
      ),
    );
  }
}
