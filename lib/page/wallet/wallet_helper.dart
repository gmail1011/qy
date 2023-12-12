import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/model/wallet/withdraw_fee_model.dart';
import 'package:sprintf/sprintf.dart';

String getFee(WithdrawFeeModel feeModel) {
  if (feeModel == null) {
    return "";
  } else {
    return sprintf(Lang.WITHDRAWAL_INSTRUCTIONS, [
      ((feeModel?.minMoney ?? 0) / 100).toString(),
      ((feeModel?.maxMoney ?? 0) / 100).toString(),
      feeModel?.coinTax?.toString() ?? "0"
    ]);
  }
}

// Future<String> _showBottomSheet(
//     AliWithdrawState state, Dispatch dispatch, ViewService ctx) {
//   return showModalBottomSheet<String>(
//       context: ctx.context,
//       builder: (BuildContext context) {
//         return Container(
//           ///MediaQuery.of(context).padding.bottom; 这是底部安全距离计算公示  iphone  系列的手机是有安全区域 如果不考虑这部分容易越界报错
//           height: Dimens.pt120 + (Dimens.pt60 * state.aliList.list.length),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Container(
//                 margin: CustomEdgeInsets.only(left: 16, top: 13),
//                 child: Text(
//                   Lang.SELECTED_ALI_PAY,
//                   style: TextStyle(fontSize: Dimens.pt18, color: Colors.black),
//                 ),
//               ),
//               Container(
//                 margin: CustomEdgeInsets.only(left: 16, top: 2),
//                 child: Text(
//                   Lang.ALI_PAY_TIM,
//                   style: TextStyle(
//                       fontSize: Dimens.pt10, color: Color(0xffa4a4a4)),
//                 ),
//               ),
//               Divider(
//                 color: Colors.black26,
//               ),
//               Expanded(
//                   child: ListView.builder(
//                       shrinkWrap: true,
//                       itemCount:
//                           state.aliList == null ? 0 : state.aliList.list.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         return InkWell(
//                           onTap: () {
//                             state.index = index;
//                             safePopPage();
//                             dispatch(
//                                 AliWithdrawActionCreator.onUpdateAliAccount(
//                                     state.aliList.list[index]));
//                           },
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             mainAxisSize: MainAxisSize.max,
//                             children: <Widget>[
//                               Container(
//                                 margin: CustomEdgeInsets.only(
//                                   top: 10,
//                                 ),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisSize: MainAxisSize.max,
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   children: <Widget>[
//                                     svgAssets(
//                                       AssetsSvg.IC_AP,
//                                       width: Dimens.pt20,
//                                     ),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: <Widget>[
//                                         Text(
//                                           '(${state.aliList.list[index].act.substring(0, 3)}****${state.aliList.list[index].act.substring(7)})',
//                                           style: TextStyle(
//                                               fontSize: Dimens.pt14,
//                                               color: Color(0xff4f4f4f)),
//                                         ),
//                                         Text(
//                                           Lang.WITH_IN_HOURS,
//                                           style: TextStyle(
//                                               fontSize: Dimens.pt10,
//                                               color: Color(0xffa4a4a4)),
//                                         ),
//                                       ],
//                                     ),
//                                     Text(
//                                       state.aliList.list[index].actName,
//                                       style: TextStyle(
//                                           fontSize: Dimens.pt14,
//                                           color: Color(0xff676767)),
//                                     ),
//                                     _buildIcon(state.index == index),
//                                   ],
//                                 ),
//                               ),
//                               Container(
//                                 margin:
//                                     CustomEdgeInsets.only(left: 16, top: 12),
//                                 child: Divider(
//                                   height: Dimens.pt2,
//                                   color: Colors.black26,
//                                 ),
//                               )
//                             ],
//                           ),
//                         );
//                       }))
//             ],
//           ),
//         );
//       });
// }

///计算输入的金钱
// void calculationMoney(AliWithdrawState state, Dispatch dispatch) {
//   if (state.feeModel == null) return;
//   double min = ((state.feeModel?.minMoney ?? 0) / 100);
//   double max = ((state.feeModel?.maxMoney ?? 0) / 100);
//   double cash = (state.feeModel.cashTax / 100);

//   if (state.moneyController.text.toString().isNotEmpty) {
//     double withdrawMoney = double.parse(state.moneyController.text.toString());
//     if (withdrawMoney >= min && withdrawMoney <= max) {
//       double fee = withdrawMoney * cash;
//       String money = (withdrawMoney - fee).toStringAsFixed(2);
//       dispatch(AliWithdrawActionCreator.onUpdateFee(fee.toStringAsFixed(2)));
//       dispatch(AliWithdrawActionCreator.onUpdateMoney(money));
//     } else if (withdrawMoney > max) {
//       state.moneyController.text = max.toInt().toString();
//       double fee = max * cash;
//       String money = (max - fee).toStringAsFixed(2);
//       dispatch(AliWithdrawActionCreator.onUpdateFee(fee.toStringAsFixed(2)));
//       dispatch(AliWithdrawActionCreator.onUpdateMoney(money));
//     } else {
//       dispatch(AliWithdrawActionCreator.onUpdateFee('0'));
//       dispatch(AliWithdrawActionCreator.onUpdateMoney('0'));
//     }
//   } else {
//     dispatch(AliWithdrawActionCreator.onUpdateFee('0'));
//     dispatch(AliWithdrawActionCreator.onUpdateMoney('0'));
//   }
// }
