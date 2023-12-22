import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/page/video/video_publish/rule/example_dialog_bean.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/dialog/newdialog/rule_image_dialog.dart';
import 'package:flutter_app/widget/dialog/newdialog/system_image_dialog.dart';
import 'package:flutter_base/task_manager/dialog_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RulePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RulePageState();
  }
}

class RulePageState extends State<RulePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: getCommonAppBar("发布规则"),
        backgroundColor: AppColors.weiboBackgroundColor,
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "欢迎优秀的您加入51乱伦，我们珍视每一位UP主，始终致力于为大家带来最优质的产品与服务。您的作品在51乱伦的售卖无时间、次数限制，销售的次数越多，获得的收入就会越多。无论您是在睡觉还是在工作，它们都将持续为您带来源源不断的收入。",
                  style: _contentTextStyle,
                ),
                const SizedBox(height: 16),
                const Text("上传规则", style: _titleTextStyle),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  "1.UP主及普通用户上传收费视频比例为2:1，即上传2个免费视频才可上传1个收费视频。"
                  "\n2.原创举牌up主上传收费视频比例为1:1，即上传1个免费视频才可上传1个收费视频。"
                  "\n3.视频清晰度需要在360p以上，且时长不小于30秒。"
                  "\n4.套图大于6张才可以设置价格。"
                  "\n5.审核时间为48小时内，请在[创作中心]查收反馈。"
                  "\n6.视频中的当事人须满18岁以上，且当事人同意视频被上传分享。",
                  style: _contentTextStyle,
                ),
                const SizedBox(height: 16),
                const Text("审核规则", style: _titleTextStyle),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  "1.原创拍摄、原创剪辑作品，会更容易通过并获得官方推荐。"
                  "\n2.禁止直接搬运网络视频，重复率高且不容易通过，多次违规将降低账号推荐权重。"
                  "\n3.禁止在视频/图片中添加个人联系方式或插入广告网址将不会通过审核。"
                  "\n4.禁止上传幼女、人兽、真实强奸等侵害他人的视频。"
                  "\n5.加强用户隐私性，允许原创视频为人物面部等重要部分添加遮挡或马赛克。"
                  "\n6.上传的视频内容不符合上传要求将不会通过审核，如若退回视频未作修改再次发起审核将禁止上传。",
                  style: _contentTextStyle,
                ),
                const SizedBox(height: 16),
                const Text("定价规则", style: _titleTextStyle),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  "1.发布内容默认为免费，用户可根据作品内容质量调整为金币视频。",
                  style: _contentTextStyle,
                ),

                /*GestureDetector(
                  onTap: () async{

                    List<ExampleDialog> data = [];

                    dynamic commonPostRes = await netManager.client.getExample();

                    commonPostRes.forEach((v) {
                      data.add(ExampleDialog.fromJson(v));
                    });

                    var val = await dialogManager.addDialogToQueue(
                            () => showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return RuleImageDialog(
                                cover: data[0].img,
                              );
                            }),
                        uniqueId: "SystemGameImageDialog");

                  },
                  child: const Text(
                    "2.认证UP主发布原创举牌长视频，建议定价50-200金币",
                    style: TextStyle(
                      color: Color.fromRGBO(255, 127, 15, 1),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),*/

                GestureDetector(
                  onTap: () async {



                    List<ExampleDialog> data = [];

                    dynamic commonPostRes =
                        await netManager.client.getExample();

                    commonPostRes.forEach((v) {
                      data.add(ExampleDialog.fromJson(v));
                    });

                    if(data.length > 0){
                      var val = await dialogManager.addDialogToQueue(
                              () => showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return RuleImageDialog(
                                  cover: data[0].img,
                                );
                              }),
                          uniqueId: "SystemGameImageDialog");
                    }
                  },
                  child: RichText(
                      text: TextSpan(
                          text: '2.',
                          style: TextStyle(fontSize: 16.0, color: Color.fromRGBO(255, 127, 15, 1)),
                          children: <TextSpan>[
                            TextSpan(
                                text: '认证UP主发布原创举牌长视频，',
                                style: TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: Color.fromRGBO(255, 127, 15, 1))),
                            TextSpan(
                                text: '建议定价50-200金币',
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: Colors.white38,
                                )),
                          ]),
                      textAlign: TextAlign.start),
                ),
                const Text(
                  "3.原创举牌作品，建议定价30-50金币"
                  "\n4.原创剪辑作品，建议定价10-20金币"
                  "\n5.非原创短片，建议定价1-10金币",
                  style: _contentTextStyle,
                ),
                const SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const TextStyle _titleTextStyle = TextStyle(
  color: Colors.white54,
  fontSize: 16,
  fontWeight: FontWeight.bold,
);
const TextStyle _contentTextStyle = TextStyle(
  color: Colors.white38,
  fontSize: 14,
  height: 1.5,
);
