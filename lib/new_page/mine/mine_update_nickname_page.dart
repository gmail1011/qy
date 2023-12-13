import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';

///消息中心
class MineUpdateNamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MineUpdateNamePageState();
  }
}

class _MineUpdateNamePageState extends State<MineUpdateNamePage> {
  TextEditingController nickController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    nickController.text = GlobalStore.getMe()?.name ?? "";
    setState(() {});
  }

  /// 修改用户昵称
  void _editNickName() async {
    String nickNameStr = nickController?.text?.trim() ?? "";

    try {
      if (nickNameStr.isEmpty) {
        showToast(msg: "昵称不能为空～");
        return;
      }
      if (nickNameStr.length > 9) {
        showToast(msg: "昵称不能超过9个字符～");
        return;
      }
      Map<String, dynamic> editInfo = {
        'name': nickNameStr,
      };
      var userInfo = await GlobalStore.updateUserInfo(editInfo);
      if (null != userInfo) {
        showToast(msg: "更新昵称成功");
        nickController?.clear();
        _init();
        // safePopPage("update");
      }
    } catch (e) {
      l.e("_editNickName-error:", "$e");
      showToast(msg: "更新昵称失败");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FullBg(
      child: Scaffold(
        appBar: getCommonAppBar(
          "修改昵称",
          actions: [
            Container(
              padding: EdgeInsets.only(right: 16),
              alignment: Alignment.centerRight,
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () => _editNickName(),
                child: Container(
                  width: 54,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryTextColor,
                        AppColors.primaryTextColor,
                      ],
                    ),
                  ),
                  child: Text(
                    "保存",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        body: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "你的昵称",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  TextField(
                    cursorColor: Colors.white.withOpacity(0.7),
                    controller: nickController,
                    maxLines: 1,
                    autocorrect: true,
                    autofocus: nickController.text == null || nickController.text.isEmpty,
                    keyboardType: TextInputType.text,
                    inputFormatters: [LengthLimitingTextInputFormatter(9)],
                    maxLength: 9,
                    style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9)),
                    decoration: InputDecoration(
                      // border: InputBorder.none,
                      hintText: "输入新的昵称",
                      counter: SizedBox(),
                      hintStyle: TextStyle(color: Color(0xff999999), fontSize: 14),
                      counterStyle: TextStyle(
                        color: AppColors.publishTextColor,
                        fontSize: 12,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 16,
                    child: GestureDetector(
                      onTap: () {
                        nickController?.clear();
                      },
                      child: Image(
                        image: AssetImage(AssetsImages.ICON_NICK_DEL),
                        width: 22,
                        height: 22,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                "昵称30天内可修改4次",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xff999999),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
