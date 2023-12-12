import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/search/search_tag/search_tag_item/component.dart';
import 'package:flutter_app/page/search/search_tag/search_tag_item/state.dart';
import 'package:flutter_app/page/search/search_tag/state.dart';

// ignore: deprecated_member_use
class SearchTagAdapter extends DynamicFlowAdapter<HotListState> {
  SearchTagAdapter()
      : super(
          pool: <String, Component<Object>>{
            "MyItem": SearchTagItemComponent(),
          },
          connector: _SearchTagConnector(),
        );
}

class _SearchTagConnector extends ConnOp<HotListState, List<ItemBean>> {
  @override
  List<ItemBean> get(HotListState state) {
    if (state.items?.isNotEmpty == true) {
      return state.items
          .map<ItemBean>((SearchTagItemState data) => ItemBean('MyItem', data))
          .toList(growable: true);
    }

    return <ItemBean>[];
  }

  @override
  void set(HotListState state, List<ItemBean> items) {
    if (items?.isNotEmpty == true) {
      state.items = List<SearchTagItemState>.from(
          items.map<SearchTagItemState>((ItemBean bean) => bean.data).toList());
    } else {
      state.items = <SearchTagItemState>[];
    }
  }

  @override
  subReducer(reducer) {
    return super.subReducer(reducer);
  }
}
