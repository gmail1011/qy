import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/domain_source_model.dart';
import 'package:flutter_app/page/home/post/ads_banner_widget.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 系统公告--图片公告
class RecommendApplication extends StatelessWidget {
  final List<AdsInfoBean> officeConfigList;
  final List<AdsInfoBean> adsList;

  RecommendApplication({Key key, this.officeConfigList,this.adsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (adsList==null || adsList.length==0)?Container():
              Container(
                margin: EdgeInsets.only(bottom: Dimens.pt29),
                child:   AdsBannerWidget(
                  adsList,
                  width: Dimens.pt329,
                  height: Dimens.pt88,
                  onItemClick: (index) {
                    var ad =  adsList[index];
                    JRouter().handleAdsInfo(ad.href, id: ad.id);
                  },
                ),
              ),
              GridView.builder(
                  itemCount: min(9, officeConfigList.length),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, //每行三列
                    crossAxisSpacing:0,
                    mainAxisSpacing: 0,
                    childAspectRatio: 92 / 120, //显示区域宽高相等
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        String url = officeConfigList[index].href ?? "";
                        JRouter().go(url);
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 92.w,
                            height: 92.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9.w)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(9.w),
                              child: CustomNetworkImage(
                                imageUrl: officeConfigList[index].cover,
                                // width: Dimens.pt300,
                                // height: Dimens.pt400,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          SizedBox(height: 14.w),
                          Container(
                            width: 76.w,
                            height: 26.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: AppColors.primaryTextColor,
                                borderRadius: BorderRadius.circular(13.w)),
                            child: Text(
                              '立即下载',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    );
                  }),
              GestureDetector(
                onTap: () {
                  safePopPage(false);
                },
                child: svgAssets(AssetsSvg.CLOSE_BTN,
                    width: Dimens.pt35, height: Dimens.pt35),
              )
            ],
          ),
        ));
  }
}
