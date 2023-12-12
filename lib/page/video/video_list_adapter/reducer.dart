import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/page/video/video_item_commponent/state.dart';
import 'package:flutter_app/page/video/video_list_adapter/action.dart';
import 'package:path/path.dart' as path;

Reducer<T> buildReducer<T extends MutableSource>() {
  return asReducer(
    <Object, Reducer<T>>{
      VideoListAdapterAction.buyProductSuccess: _buyProductSuccess,
      VideoListAdapterAction.refreshItemUI: _refreshItemUI,
      VideoListAdapterAction.commentSuccess: _commentSuccess,
    },
  );
}

///购买商品成功
T _buyProductSuccess<T extends MutableSource>(T state, Action action) {
  // print("videoList _buyProductSuccess");
  VideoItemState itemState = action.payload;
  if (null == itemState) return state;
  itemState.videoModel.vidStatus.hasPaid = true;
  if (itemState.videoModel.isImg()) {
    for (int i = 0; i < itemState.videoModel.seriesCover.length; i++) {
      itemState.videoModel.seriesCover[i] =
          path.join(Address.baseImagePath, itemState.videoModel.seriesCover[i]);
    }
  }
  if (state is MutableSource) {
    return state.updateItemData(itemState.index, itemState, false);
  }
  return state;
}

/// 刷新item
T _refreshItemUI<T extends MutableSource>(T state, Action action) {
  VideoItemState itemState = action.payload;
  if (null == itemState) return state;
  if (state is MutableSource) {
    return state.updateItemData(itemState.index, itemState, false);
  }
  return state;
}

///评论成功
T _commentSuccess<T extends MutableSource>(T state, Action action) {
  VideoItemState itemState = action.payload;
  if (null == itemState) return state;
  itemState.videoModel.commentCount++;
  if (state is MutableSource) {
    return state.updateItemData(itemState.index, itemState, false);
  }
  return state;
}
