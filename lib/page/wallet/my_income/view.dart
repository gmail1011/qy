import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/widget/common_widget/load_more_footer.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/custom_edge_insets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    MyIncomeState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    appBar: AppBar(
      title: Text(Lang.MY_INCOME),
      //文字title居中
      centerTitle: true,
      leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            dispatch(MyIncomeActionCreator.onBack());
          }),
      actions: <Widget>[],
    ),
    body: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(height: 1.0, indent: 0.0, color: Color(0x805a4f59)),
          Container(
            child: Text(
              Lang.INCOME_BALANCE,
              style: TextStyle(
                color: Colors.white,
                fontSize: Dimens.pt16,
              ),
            ),
            margin: EdgeInsets.only(left: Dimens.pt16, top: Dimens.pt20),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                Dimens.pt10, Dimens.pt25, Dimens.pt16, Dimens.pt53),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textDirection: TextDirection.ltr,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      svgAssets(
                        AssetsSvg.IC_GOLD,
                        width: Dimens.pt27,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: Dimens.pt15),
                        child: Text(
                          state.income ?? "",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Dimens.pt34,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                RaisedButton(
                  padding: EdgeInsets.fromLTRB(Dimens.pt25, 0, Dimens.pt23, 0),
                  color: Color(0xfffc3066),
                  child: Text(
                    Lang.WITHDRAW,
                    style:
                        TextStyle(fontSize: Dimens.pt20, color: Colors.white),
                  ),
                  onPressed: () {
                    //点击事件
                    dispatch(MyIncomeActionCreator.onWithdraw());
                  },
                )
              ],
            ),
          ),
          Divider(height: 1.0, indent: 0.0, color: Color(0x805a4f59)),
          Container(
            margin: EdgeInsets.fromLTRB(
                Dimens.pt16, Dimens.pt20, Dimens.pt16, Dimens.pt20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  Lang.HISTORICAL_INCOME_DETAILS,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Dimens.pt14,
                  ),
                ),
                Text(
                  state.model == null
                      ? ""
                      : Lang.INCOME_TOTAL +
                              state.model?.totalIncome.toString() ??
                          "",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Dimens.pt14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: EasyRefresh(
              controller: state.controller,
              topBouncing: false,
              emptyWidget: state.model == null
                  ? Container()
                  : state.model.list.length > 0 ? null : emptyView(),
              footer: LoadMoreFooter(hasNext: state.model?.hasNext ?? false),
              onLoad: () async {
                if (state.model?.hasNext ?? false) {
                  dispatch(MyIncomeActionCreator.loadData());
                } else {
                  state.controller.finishLoad(success: true, noMore: true);
                }
              },
              child: ListView.separated(
                itemCount: state.model == null ? 0 : state.model.list.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              left: Dimens.pt16,
                              top: Dimens.pt15,
                              bottom: Dimens.pt7),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${Lang.MONEY_VIDEO}${getVideoName(state.model.list[index].title)}',
                                style: TextStyle(
                                    fontSize: Dimens.pt14, color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: Dimens.pt2,
                                    top: Dimens.pt13,
                                    bottom: Dimens.pt10),
                                child: Text(
                                  state.model.list[index].createdAt == null
                                      ? ""
                                      : DateTimeUtil.utc2iso(
                                          state.model.list[index].createdAt),
                                  style: TextStyle(
                                      fontSize: Dimens.pt12,
                                      color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(right: Dimens.pt15),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  '+ ${state.model.list[index].publisherIncome == null ? "0" : state.model.list[index].publisherIncome}',
                                  style: TextStyle(
                                      fontSize: Dimens.pt20,
                                      color: Color(0xfffc3066)),
                                ),
                              ],
                            ))
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: Colors.white30,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

///空数据展示的view
Widget emptyView() {
  return Container(
      margin: CustomEdgeInsets.only(top: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(Lang.NO_INCOME,
              style: TextStyle(color: Colors.white, fontSize: 15)),
        ],
      ));
}

///截取视频名称长度
String getVideoName(String name) {
  if (name.isEmpty) {
    return "";
  } else if (name.length > 12) {
    return name.substring(0, 12) + "..";
  } else {
    return name;
  }
}
