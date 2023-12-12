import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/api_exception.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/lou_feng_model.dart';
import 'package:flutter_app/model/verifyreport_model.dart';
import 'package:flutter_app/utils/event_tracking_manager.dart';
import 'package:flutter_app/widget/dialog/confirm_dialog.dart';
import 'package:flutter_app/widget/goldcoin_recharge_dialog.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';
import '../LouFengDisCountBuy.dart';
import 'action.dart';
import 'state.dart';
import 'package:dio/dio.dart';

// 是否点击
bool _collectClick = false;
bool _buyClick = false;

Effect<YuePaoDetailsState> buildEffect() {
  return combineEffects(<Object, Effect<YuePaoDetailsState>>{
    YuePaoDetailsAction.onCollect: _onCollect,
    YuePaoDetailsAction.onBuy: _onBuy,
    YuePaoDetailsAction.renZhengZhuanQuYuYue: _onRenZhengYuYue,
    YuePaoDetailsAction.onBuyWithDiscountCard: _onBuyWithDiscountCard,
    YuePaoDetailsAction.loadMoreData: _loadMoreData,
    YuePaoDetailsAction.onClickReport: _onClickReport,
    YuePaoDetailsAction.onVerification: _onVerification,
    YuePaoDetailsAction.onNextLouFeng: _onNextLouFeng,
    YuePaoDetailsAction.goVip: _goVip,
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _dispose,
  });
}

void _goVip(Action action, Context<YuePaoDetailsState> ctx) async {
  Config.payFromType = PayFormType.user;
  _getData(action, ctx, ctx.state.louFengItem.id);
}

/// 初始化方法
void _initState(Action action, Context<YuePaoDetailsState> ctx) {
  _setBrowse(ctx, ctx.state.id);
  _collectClick = false;
  _buyClick = false;
  Future.delayed(Duration(milliseconds: 500), () async {
    //eaglePage(ctx.state.selfId(), sourceId: ctx.state.eagleId(ctx.context));
    _getData(action, ctx, ctx.state.id);
  });
}

void _dispose(Action action, Context<YuePaoDetailsState> ctx) {
  GlobalStore.updateUserInfo(null);
}

_getData(Action action, Context<YuePaoDetailsState> ctx, String id) async {
  try {
    var model = await netManager.client.getLouFengItem(id);
    ctx.dispatch(
        YuePaoDetailsActionCreator.onReplaceLouFengItem(model.loufeng));
    ctx.dispatch(
        YuePaoDetailsActionCreator.productItemBean(model.productItemBean));
    ctx.state.pullController.requestSuccess(isFirstPageNum: true);


    ctx.dispatch(YuePaoDetailsActionCreator.loadMoreData());
  } catch (e) {
    ctx.state.pullController.requestFail(isFirstPageNum: true);
  }
}

/// 下一个楼凤
bool _clickNext = false;
void _onNextLouFeng(Action action, Context<YuePaoDetailsState> ctx) async {
  if (_clickNext) return;
  _clickNext = true;
  ctx.state.pullController.requesting();
  // 切换楼凤初始化pageNumber
  ctx.dispatch(YuePaoDetailsActionCreator.initPageNumber());
  try {
    LouFengModel louFengModel = await netManager.client.getNextLouFeng();
    var list = louFengModel.list;
    if (list.isNotEmpty) {
      ctx.dispatch(YuePaoDetailsActionCreator.onReplaceLouFengItem(list[0]));
      _setBrowse(ctx, list[0].id);
    }
    ctx.state.pullController.requestSuccess(isFirstPageNum: true);
  } catch (e) {
    l.e('getNextLouFeng', e.toString());
    ctx.state.pullController.requestFail(isFirstPageNum: true);
  }
  _clickNext = false;
}

/// 举报
void _onClickReport(Action action, Context<YuePaoDetailsState> ctx) async {
  var item = ctx.state.louFengItem;
  if(item == null)return;
  if (item.isBought) {
    JRouter().go(YUEPAOREPORTPAGE, arguments: {'id': item.id});
  } else {
    await showConfirm(ctx.context,
        title: Lang.WARM_TIPS, content: Lang.YUE_PAO_MSG9, sureText: Lang.KNOW);
  }
}

/// 验证
void _onVerification(Action action, Context<YuePaoDetailsState> ctx) async {
  var item = ctx.state.louFengItem;
  if(item == null)return;
  if (item.isBought) {
    JRouter().go(YUE_PAO_VERIFICATION_PAGE, arguments: {'productID': item.id});
  } else {
    await showConfirm(ctx.context,
        title: Lang.WARM_TIPS,
        content: Lang.YUE_PAO_MSG10,
        sureText: Lang.KNOW);
  }
}

/// 添加浏览次数
void _setBrowse(Context<YuePaoDetailsState> ctx, String id) async {
  try {
    await netManager.client.postBrowse(id);
    ctx.dispatch(YuePaoDetailsActionCreator.onChangeCountBrowse());
  } catch (e) {
    l.e('postBrowse', e.toString());
  }
}

/// 收藏/取消收藏
void _onCollect(Action action, Context<YuePaoDetailsState> ctx) async {
  var item = ctx.state.louFengItem;
  if(item == null)return;
  if (_collectClick) return;
  try {
    _collectClick = true;
    String objId = item.id;
    await netManager.client.postCollect(objId, 'loufeng', action.payload);
    ctx.dispatch(YuePaoDetailsActionCreator.onChangeItem(action.payload));
    String msg =
        action.payload ? Lang.COLLECTION_SUCCESS : Lang.CANCEL_COLLECTION;
    showToast(msg: msg);
  } catch (e) {
    l.e('postCollect=', e.toString());
  } finally {
    _collectClick = false;
  }
}

/// 获取验证报告
void _loadMoreData(Action action, Context<YuePaoDetailsState> ctx) async {
  try {
    VerifyReportModel model = await netManager.client.getLoufengVerifyReport(
        ctx.state.louFengItem.id, ctx.state.pageNumber, ctx.state.pageSize);
    var list = model.list ?? [];
    ctx.dispatch(YuePaoDetailsActionCreator.onChangeList(list));
    if (model.hasNext) {
      ctx.dispatch(YuePaoDetailsActionCreator.onChangePageNumber());
    }
    ctx.state.pullController.requestSuccess(
        isFirstPageNum: false, hasMore: model.hasNext, isEmpty: list.isEmpty);
  } catch (e) {
    ctx.state.pullController.requestFail(isFirstPageNum: false);
    l.e('getLoufengVerifyReport', e.toString());
  }
}

/// 购买（解锁）
void _onBuy(Action action, Context<YuePaoDetailsState> ctx) async {
  var item = ctx.state.louFengItem;
  if(item == null)return;
  if (_buyClick) return;
  try {
    _buyClick = true;
    String productID = ctx.state.louFengItem.id;
    String name = ctx.state.louFengItem.title;
    int amount = ctx.state.louFengItem.contactPrice;

    if(Config.isAbleClickProductBuy){
      await netManager.client.postBuyVideo(productID, name, amount, 7);
      showToast(msg: Lang.BUY_SUCCESS);
      _getData(action, ctx, ctx.state.louFengItem.id);
    }else{
      showToast(msg: "服务器繁忙，请稍后再试呦...");
    }

  } on DioError catch (e) {
    var error = e.error;
    if (error is ApiException) {
      if (error.code == 8000) {
      }
    }
    l.e('postBuyVideo=', e.toString());
  } finally {
    _buyClick = false;
  }
}


/// 购买（解锁 + 优惠卷）
void _onBuyWithDiscountCard(Action action, Context<YuePaoDetailsState> ctx) async {
  var item = ctx.state.louFengItem;
  if(item == null)return;
  if (_buyClick) return;
  try {
    _buyClick = true;
    String productID = ctx.state.louFengItem.id;
    String name = ctx.state.louFengItem.title;
    int amount = ctx.state.louFengItem.contactPrice;

    if(Config.isAbleClickProductBuy){
      await netManager.client.postBuyLouFengWithDisCountCard(productID, name, (action.payload as LouFengDisCountBuy).amount , 7, (action.payload as LouFengDisCountBuy).id);
      showToast(msg: Lang.BUY_SUCCESS);
      _getData(action, ctx, ctx.state.louFengItem.id);
    }else{
      showToast(msg: "服务器繁忙，请稍后再试呦...");
    }

  } on DioError catch (e) {
    var error = e.error;
    if (error is ApiException) {
      if (error.code == 8000) {
      }
    }
    l.e('postBuyVideo=', e.toString());
  } finally {
    _buyClick = false;
  }
}



///认证专区预约
void _onRenZhengYuYue(Action action, Context<YuePaoDetailsState> ctx) async {
  var item = ctx.state.louFengItem;
  if(item == null)return;
  if (_buyClick) return;
  try {
    _buyClick = true;
    String productID = ctx.state.louFengItem.id;
    String name = ctx.state.louFengItem.title;
    int amount = ctx.state.louFengItem.originalBookPrice;

    if(GlobalStore.isVIP()){
      //amount = ((((100 - ctx.state.productItemBean.louFengDiscount) / 10).round() * ctx.state.louFengItem.originalBookPrice) /10 ).round();
    }else{

    }

    if(Config.isAbleClickProductBuy){
      await netManager.client.postBuyVideo(productID, name, amount, 15);
      showToast(msg: Lang.BUY_SUCCESS);
      _getData(action, ctx, ctx.state.louFengItem.id);
    }else{
      showToast(msg: "服务器繁忙，请稍后再试呦...");
    }

  } on DioError catch (e) {
    var error = e.error;
    if (error is ApiException) {
      if (error.code == 8000) {
      }
    }
    l.e('postBuyVideo=', e.toString());
  } finally {
    _buyClick = false;
  }
}
