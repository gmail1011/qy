import 'package:fish_redux/fish_redux.dart';

class PublishHelpState implements Cloneable<PublishHelpState> {
  List questionList = [
    {"question": "Q: 我上传收费视频可以挣多少钱？", "answer": "平台和up主收益分成是4/6，up主拿总收益60%"},
    {
      "question": "Q: 为什么我的上传视频时设置了价格，通过审核后成免费视频了？",
      "answer": "免费视频和收费视频的比例为2:1，即上传2个免费视频就可以上传1个收费视频。\n且在个人主页同分类下，不能连续出现收费作品"
    },
    {
      "question": "Q：为什么我的金币视频被修改价格？",
      "answer":
          "请参考上传规则中的定价 \n1.非原创短片，建议定价1-10金币\n2.原创剪辑作品，建议定价10-20金币\n3.原创举牌作品，建议定价30-50金币\n4.认证UP主发布原创举牌长视频，建议定价50-200金币"
    },
    {"question": "Q：为什么我总是上传不成功？", "answer": "平台限制视频大小上限为300m，且视频不能低于30S。"},
    {
      "question": "Q：封面上传规则是什么？",
      "answer": "视频时长低于5分钟，横屏视频用横板封面，竖屏视频用竖板封面。\n超过5分钟的就是长视频-影视，封面全部为横板封面"
    },
    {"question": "Q：审核未通过的原因是什么呢？", "answer": "您可在[创作中心-作品管理]，点击未通过按钮可查看具体原因。"},
    {"question": "Q：多久才能审核通过？", "answer": "审核时间为3-5工作日内，请在[创作中心]查收反馈。"},
  ];
  @override
  PublishHelpState clone() {
    return PublishHelpState()..questionList = questionList;
  }
}

PublishHelpState initState(Map<String, dynamic> args) {
  return PublishHelpState();
}
