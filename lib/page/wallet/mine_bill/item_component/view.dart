import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/page/wallet/mine_bill/model/bill_item_model.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';

import 'state.dart';

Widget buildView(
    MineBillItemState state, Dispatch dispatch, ViewService viewService) {
  return Container(
    margin: EdgeInsets.only(left: Dimens.pt18, right: Dimens.pt16),
    child: Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: Dimens.pt15, bottom: Dimens.pt11),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "${state.billModel?.desc ??= ""}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimens.pt13,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Padding(padding: EdgeInsets.only(top: Dimens.pt5)),
                          Text(
                            "${state.billModel?.tranType ??= ""}",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: Dimens.pt12),
                            overflow: TextOverflow.ellipsis,
                          ),
                          // Padding(padding: EdgeInsets.only(top: Dimens.pt5)),
                          //
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      padding:
                          EdgeInsets.fromLTRB(Dimens.pt9, 0, Dimens.pt9, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${state.billModel?.createdAt ??= ""}",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: Dimens.pt11),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          _buildGoldcoinTag("${state.billModel?.actualAmount}",
                              state.billModel),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(padding: EdgeInsets.only(top: Dimens.pt11)),
        Container(
          color: Colors.white.withOpacity(0.1),
          width: screen.screenWidth,
          height: Dimens.pt2,
        )
      ],
    ),
  );
}

bool isAiRecord(int tranTypeInt) {
  return tranTypeInt == 77 ||
      tranTypeInt == 78 ||
      tranTypeInt == 79 ||
      tranTypeInt == 80 ||
      tranTypeInt == 81;
}

///创建金币标签UI
Widget _buildGoldcoinTag(String goldCoin, BillItemModel model) {
  if (goldCoin == null) {
    return Container(); //
  }
  //String newGoldCoin = "${goldCoin.replaceAll("-", "")}";
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      /*svgAssets(goldCoin.startsWith("-")
          ? AssetsSvg.ICON_BILL_REDUCE
          : AssetsSvg.ICON_BILL_PLUS),*/
      const SizedBox(width: 3),
      Text(
        isAiRecord(model.tranTypeInt) ? "$goldCoin次" : "$goldCoin金币",
        style: TextStyle(color: Color(0xfff6d85d), fontSize: Dimens.pt14),
      ),
    ],
  );
}
