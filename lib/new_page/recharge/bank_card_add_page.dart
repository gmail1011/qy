import 'package:flutter/material.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/net/code.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/wallet/alipay_ccdcapi_model.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/net/dio_cli.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';

///添加银行卡
class BankCardAddPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BankCardAddPageState();
  }
}

class _BankCardAddPageState extends State<BankCardAddPage> {
  TextEditingController cardCodeController = TextEditingController();
  TextEditingController cardNameController = TextEditingController();
  TextEditingController cardUserNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _onAddBankCard(String code) async {
    DioCli().getJSON(Address.ALI_CCD_API + code).then((ret) {
      if (ret.err != null) {
        showToast(msg: "银行卡验证失败.");
        return;
      }
      final res = ret.data;
      if (res.statusCode == Code.SUCCESS) {
        ApcApiModel model = ApcApiModel.fromMap(res.data);
        if (model.validated) {
          _addBankCard(model.bank, model.cardType);
        } else {
          showToast(msg: "银行卡验证失败");
        }
      } else {
        showToast(msg: "银行卡验证失败");
      }
    });
  }

  void _addBankCard(String code, String cardType) async {
    String cardUserName = cardUserNameController.text;
    String backNumber = cardCodeController.text;

    try {
      await netManager.client.getAddBankCard(backNumber, cardUserName, code, cardType);

      showToast(msg: "添加成功");
      cardCodeController.clear();
      cardNameController.clear();
      cardUserNameController.clear();
    } catch (e) {
      l.e('getAddAp', e.toString());
      showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FullBg(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppbar(
          title: "添加银行卡",
        ),
        body: Column(
          children: [
            _buildInputWidget("银行名称", cardNameController),
            _buildInputWidget("银行卡号", cardCodeController),
            _buildInputWidget("持卡人名称", cardUserNameController),
            Spacer(),
            // Rectangle 2784
            InkWell(
              onTap: () => _onAddBankCard(cardCodeController.text),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20,horizontal: 16),
                height: 47,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    gradient: LinearGradient(colors: [const Color(0xff84a4f9), const Color(0xff2b5dde)])),
                child: Center(
                  child: // 确定
                      Text(
                    "确定",
                    style: const TextStyle(
                        color: const Color(0xffffffff), fontWeight: FontWeight.w600, fontSize: 14.0),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInputWidget(String title, TextEditingController controller) {
    return Container(
      height: 70,
      margin: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: const Color(0xffffffff), fontWeight: FontWeight.w900, fontSize: 12.0),
              textAlign: TextAlign.center),
          SizedBox(height: 10),
          Container(
            height: 42,
            padding: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(2)), color: const Color(0xff202733)),
            child: TextField(
              controller: controller,
              maxLines: 1,
              autocorrect: true,
              autofocus: false,
              style: TextStyle(fontSize: 14, color: Colors.white, textBaseline: TextBaseline.alphabetic),
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Color(0xff434c55), fontSize: 14),
                hintText: "请输入",
                border: InputBorder.none,
              ),
            ),
          )
        ],
      ),
    );
  }
}
