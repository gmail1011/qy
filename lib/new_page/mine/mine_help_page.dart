import 'package:flutter/material.dart';
import 'package:flutter_app/new_page/mine/floating_cs_view.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/full_bg.dart';

///帮助反馈
class MineHelpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MineHelpPageState();
  }
}

class _MineHelpPageState extends State<MineHelpPage> {
  List questionList = [
    {"question": "为什么充值不了？",
      "answer": " 由于网络问题，请尝试其他的充值渠道或重启app再次尝试获取充值链接，如还未解决，请联系客服。"
    },
    {"question": "充值后没到账？",
      "answer": "充值到账会有延迟，正常情况到账时间为1小时内，若超过12小时未到账可联系客服为您加紧处理！(在您反馈时需要上传支付成功的截图哦) 。"},
    {
      "question": "如何分享给好友？",
      "answer": "点击【我的】—【分享好友】即可进入分享界面。\n在分享页面点击【保存图片分享】即可保存图片到相册，要分享时选择相册图片即可；点击【复制分享链接】即可复制文字分享，分享时长按粘贴即可 。"
    },
    {"question": "分享给好友后，没有送VIP ？", "answer": "邀请好友注册后，需查看好友推广码是否有填写为你的分享码，若没有则需手动填写。"},
    {"question": "购买会员/金币支付失败 ？", "answer": "使用支付宝支付失败时，请间隔2分钟重试，如果还是不行，可以换种支付方式或者给客服留言。"},
    {"question": "如何填写邀请码 ？", "answer": "在【我的】页面点击个人头像或者设置即可跳转页面，然后点击【输入推广码】打开新页面，输入对方的推广码即可(ps:邀请码要注意大小写)。"},
    {"question": "忘记密码，如何找回账号？", "answer": "请保存好个人推广码或注册账号，向客服留言反馈为你重置修改。"},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FullBg(
      child: Scaffold(
          appBar: CustomAppbar(title: "帮助反馈"),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.only(bottom: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "常见问题与反馈",
                        style: const TextStyle(
                            color: const Color(0xffffffff), fontWeight: FontWeight.w600, fontSize: 24.0),
                      ),
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: questionList.map((e) => _getItem(context, e)).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              FloatingCSView()
            ],
          )),
    );
  }

  Widget _getItem(context, item) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            item["question"],
            style:
                const TextStyle(color: const Color(0xffc6c6c6), fontWeight: FontWeight.w700, fontSize: 16.0),
          ),
          SizedBox(height: 5),
          Text(
            item["answer"],
            style:
                const TextStyle(color: const Color(0xff808080), fontWeight: FontWeight.w400, fontSize: 14.0),
          ),
        ]));
  }
}
