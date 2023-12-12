import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/user/product_item.dart';

import 'action.dart';
import 'state.dart';

Effect<VIPState> buildEffect() {
  return combineEffects(<Object, Effect<VIPState>>{
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _dispose,
    VIPAction.retryLoadData: _initState,
  });
}

void _initState(Action action, Context<VIPState> ctx) {
  _getNewVipList(ctx);
}

///获取vip充值列表
_getNewVipList(Context<VIPState> ctx) async {
  try {
    var model = await netManager.client.getNewVipTypeList();
    ctx.state.vipListModel = model;
    ctx.state.defaultTabVipItem = model.list?.first;
    List<ProductItemBean> vipList = model.list?.first?.vips;
    if (ctx.state.specifyVipCardId != "") {
      print(ctx.state.specifyVipCardId);
      for (int i = 0; i < model.list.first.vips.length; i++) {
        if (ctx.state.defaultTabVipItem.vips[i].productID ==
            ctx.state.specifyVipCardId) {
          List<ProductItemBean> lastVipList = vipList.sublist(0, i);
          List<ProductItemBean> firstVipList = vipList.sublist(i);
          ctx.state.defaultTabVipItem.vips = [...firstVipList, ...lastVipList];
          ctx.state.selectVipItem = model?.list?.first?.vips?.first;
        }
      }
    } else {
      ctx.state.selectVipItem = model?.list?.first?.vips?.first;
    }

    ctx.dispatch(VIPActionCreator.updateUI());
    if ((model?.list?.length ?? 0) == 0) {
      ctx.state.requestController.requestDataEmpty();
    } else {
      ctx.state.requestController.requestSuccess();
    }
  } catch (e) {
    ctx.state.requestController.requestFail();
  }
}

void _dispose(Action action, Context<VIPState> ctx) {
  ctx.state.swiperController?.dispose();
}
