import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/office_item_entity.dart';
import 'package:flutter_base/utils/log.dart';

import 'action.dart';
import 'state.dart';

Effect<BoutiqueAppState> buildEffect() {
  return combineEffects(<Object, Effect<BoutiqueAppState>>{
    Lifecycle.initState: _initState,
  });
}

/// type: 1:下载  2:社区
void _initState(Action action, Context<BoutiqueAppState> ctx) async {
  try {
    List<OfficeItemData> list = await netManager.client.getOfficeList(1);
    l.e("list", "$list");

    if ((list ?? []).isNotEmpty) {
      ctx.state.dataList = list;
      ctx.state.requestController?.requestSuccess();
    } else {
      ctx.state.requestController?.requestDataEmpty();
    }
  } catch (e) {
    l.e("getOfficeList", "$e");
    ctx.state.requestController?.requestFail();
  }
  ctx.dispatch(BoutiqueAppActionCreator.updateUI());
}
