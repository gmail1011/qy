import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
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
  TextEditingController controller;
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  List questionTitleList = [
    {"question": "充值提现问题？", "index": "0"},
    {"question": "观看使用问题", "index": "1"},
    {"question": "收货地址信息", "index": "2"},
  ];
  List questionList = [
    {"question": "所在地区", "hitText": " 例:浙江杭州", "index": "0"},
    {"question": "设备信息", "hitText": " 例:苹果14", "index": "1"},
    {"question": "网络运营山", "hitText": " 例:电信/联通/移动", "index": "2"},
    {"question": "联系方式", "hitText": " QQ/微信/邮箱等", "index": "3"},
  ];
  TextEditingController _controller = TextEditingController();
  int selectTabIndex = 0;
  var inputText = '';
  bool isClear = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return FullBg(
      child: Scaffold(
          appBar: CustomAppbar(title: "意见反馈"),
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
                        "我遇到的问题",
                        style: const TextStyle(
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w300,
                            fontSize: 14.0),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 35,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: questionTitleList
                                .map((e) => InkWell(
                                      onTap: () {
                                        selectTabIndex =
                                            int.parse(e["index"] ?? 0);
                                        setState(() {});
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(right: 7),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        height: 33,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                            color:
                                                "$selectTabIndex" == e["index"]
                                                    ? Color(0xFF0387FE)
                                                    : Color.fromARGB(
                                                        255, 51, 51, 51)),
                                        child: Text(
                                          e["question"] ?? "",
                                          style: TextStyle(
                                              color: "$selectTabIndex" ==
                                                      e["index"]
                                                  ? Colors.white
                                                  : Colors.white),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "问题描述(必填)",
                        style: const TextStyle(
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w300,
                            fontSize: 14.0),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 270,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color.fromARGB(255, 38, 38, 38)),
                        child: TextField(
                          maxLines: 100,
                          keyboardType: TextInputType.text,
                          autofocus: true,
                          autocorrect: true,
                          textInputAction: TextInputAction.search,
                          cursorColor: Colors.white,
                          textAlign: TextAlign.left,
                          controller: controller,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                          onChanged: (text) {
                            inputText = text;
                          },
                          onSubmitted: (text) {
                            // _onExChangeCode();
                          },
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 10),
                              hintText:
                                  "充值提现问题：请在此处描述具体情况，并且提交图片处提交订单截图/扣款截图\n\n观看使用问题：请在此处描述具体操作情况，并且提交图片处提交出现问题的APP界面截图\n收货地址信息：请按照以下格式在此处填写收货地址，缺少信息将导致无法发\n\n姓名：张三\n电话：18888888\n地址：北京市朝阳区望京666小区6号楼6单元666",
                              hintStyle: TextStyle(color: Color(0xff434c55))),
                        ),
                      ),
                      SizedBox(height: 18),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: questionList
                            .map((e) => _getItem(context, e))
                            .toList(),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "选择图片/视频",
                        style: const TextStyle(
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w300,
                            fontSize: 14.0),
                      ),
                      SizedBox(height: 12),
                      InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 51, 51, 51)),
                          width: 111,
                          height: 111,
                          child: Icon(
                            Icons.add,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                         "以方便我们给您回复,有效的改进建议,有惊喜赠送哟!",
                        style: const TextStyle(
                            color: const Color(0xff808080),
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0),
                      ),
                      SizedBox(height: 59),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 45),
                        decoration: BoxDecoration(
                          color: AppColors.primaryTextColor,
                          borderRadius: BorderRadius.all(Radius.circular(40))
                        ),
                        width:double.maxFinite,
                        height: 44,
                        alignment: Alignment.center,
                        child: Text("提交意见",style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                        ),),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget _getItem(context, item) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start,

                children: [
             Container(width: 110,child:  Text(
               item["question"],
               style: const TextStyle(
                   color: const Color(0xffc6c6c6),
                   fontWeight: FontWeight.w700,
                   fontSize: 16.0),
             ),),
              Text(
                item["hitText"] ?? "",
                style: const TextStyle(
                    color: const Color(0xff808080),
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0),
              ),
            ]),
            SizedBox(height: 9,),
            Divider(
              height: 1,
              color: Colors.white.withOpacity(0.2),
            )
          ],
        ));
  }

  Container buildText(Map<String, String> data) {
    return Container(
      height: 47,
      width: 200,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                data["question"],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Divider(
            height: 0.5,
            color: Color.fromARGB(125, 102, 102, 102),
          )
        ],
      ),
    );
  }
}
