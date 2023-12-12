import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/common/config/varibel_config.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/navigator_util.dart';

class WorkRuleDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FullBg(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              safePopPage();
            },
          ),
          title: Text(
            "合集规则",
            style: TextStyle(fontSize: AppFontSize.fontSize18),
          ),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(16, 10, 16, 70),
          child: Column(
            children: [
              _buildRuleCell(
                  title: "什么是合集？",
                  content: "合集是一种新的内容组织方式，您可以将已经发布的多个关联视频依照同一类型风格重新组织在一起。"),
              SizedBox(height: 20),
              _buildRuleCell(
                  title: "合集创建费用？",
                  content:
                      "创建费用为${VariableConfig.videoCollectionPrice}金币/1个，合集创建后有效期为永久。"),
              SizedBox(height: 20),
              _buildRuleCell(
                  title: "如何添加视频到合集内？",
                  content: "您可在作品管理全部中，点击右上角编辑按钮，将同一类型的视频添加在对应合集内。"),
              Spacer(),
              Center(
                child: InkWell(
                  onTap: (){
                    safePopPage();
                  },
                  child: Container(
                    height: 44,
                    width: 252,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        gradient: LinearGradient(
                          colors: AppColors.buttonWeiBo,
                        )),
                    child: Text(
                      "确定",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 68),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRuleCell({String title, String content}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 16,
              decoration: BoxDecoration(
                color: Color(0xffee7e31),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                color: Color(0xffe6e6e6),
                fontSize: 16,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          content,
          style: TextStyle(
            color: Color(0xffbfbfbf),
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
