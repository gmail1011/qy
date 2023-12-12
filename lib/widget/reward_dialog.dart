import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/wallet_model_entity.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/toast_util.dart';

///打賞界面
class RewardDialog extends StatefulWidget {
  final String videoId;

  RewardDialog(this.videoId);

  @override
  RewardDialogState createState() {
    return RewardDialogState();
  }
}

class RewardDialogState extends State<RewardDialog> {
  WalletModelEntity walletInfo;
  String msg = '';
  String cons = '0';
  String labelText1 = Lang.LEAVE_A_MESSAGE1;
  String labelText2 = Lang.LEAVE_A_MESSAGE2;

  @override
  void initState() {
    if (GlobalStore.getWallet().id == null) {
      getWalletInfo();
    } else {
      walletInfo = GlobalStore.getWallet();
    }
    super.initState();
  }

  getWalletInfo() async {
    walletInfo = await GlobalStore.refreshWallet();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    FocusNode blankNode = FocusNode();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(blankNode);
      },
      child: Dialog(
        backgroundColor: Color(0x0),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: Dimens.pt80),
            alignment: Alignment.center,
            width: Dimens.pt274,
            height: Dimens.pt500,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimens.pt16, vertical: Dimens.pt10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Dimens.pt4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(
                            bottom: Dimens.pt10, top: Dimens.pt10),
                        child: Text(
                          Lang.WALLET_MSG,
                          style: TextStyle(
                              color: Colors.black, fontSize: Dimens.pt16),
                        ),
                      ),
                      Container(
                        height: 40,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          autofocus: false,
                          autocorrect: true,
                          cursorColor: Colors.grey,
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                          onChanged: (text) {
                            cons = text;
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            labelText: labelText1,
                            contentPadding: EdgeInsets.all(0),
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                style: BorderStyle.none,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      getHengLine(color: Color.fromRGBO(216, 216, 216, 1)),
                      Container(
                        height: Dimens.pt10,
                      ),
                      Container(
                        height: 40,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          autofocus: false,
                          autocorrect: true,
                          cursorColor: Colors.black,
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                          onChanged: (text) {
                            msg = text;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(0),
                            fillColor: Colors.white,
                            labelText: labelText2,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                style: BorderStyle.none,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      getHengLine(color: Color.fromRGBO(216, 216, 216, 1)),
                      Container(
                        padding: EdgeInsets.only(top: Dimens.pt10),
                        width: double.infinity,
                        child: Text(
                          '${Lang.WALLET_REMAINING}：${GlobalStore.getWallet().amount}',
                          style: TextStyle(
                            fontSize: Dimens.pt8,
                            color: Color.fromRGBO(255, 152, 152, 1),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: AppPaddings.appMargin,
                            horizontal: Dimens.pt26),
                        child: getCommonBtn(Lang.WORD_REWARD, onTap: () {
                          _rewardVideo(context, widget.videoId, cons, msg);
                        }),
                      ),
                      GestureDetector(
                          onTap: () {
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: Dimens.pt10, bottom: Dimens.pt10),
                            child: Container(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                Lang.TOPUP_TO_TEST,
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 152, 152, 1),
                                  fontSize: Dimens.pt10,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    GestureDetector(
                      onTap: () {
                        safePopPage();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: Dimens.pt50),
                        child: Container(
                          width: Dimens.pt274,
                          alignment: Alignment.center,
                          child: svgAssets(AssetsSvg.CLOSE_BTN,
                              width: Dimens.pt24, height: Dimens.pt24),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///打赏
  _rewardVideo(
      BuildContext context, String videoId, String coins, String msg) async {
    var res;
    try {
      res = await netManager.client.reward(videoId, coins, msg);
    } catch (e) {
      l.e("reward_dialog", e.toString());
    }
    if (res != null) {
      showToast(msg: Lang.REWARD_SUCCESS);
      safePopPage();
    }
  }
}
