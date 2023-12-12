import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/tag/tag_home/compont/cell/component.dart';
import 'package:flutter_app/page/tag/tag_home/state.dart';

// ignore: deprecated_member_use
class TagDetailAdapter extends DynamicFlowAdapter<TagState> {
  TagDetailAdapter()
      : super(
          pool: <String, Component<Object>>{
            'cell' : TagDetailCellComponent(),
          },
          connector: _TagDetailConnector(),
        );
}

class _TagDetailConnector extends ConnOp<TagState, List<ItemBean>> {
  @override
  List<ItemBean> get(TagState state) {
    List<ItemBean> items = [];
    if(state.tagLists == null || state.tagLists.isEmpty) {
      return items;
    }
    state.tagLists.forEach((videoModel) {
      items.add(ItemBean('cell',videoModel));
    });
    return items;
  }

  @override
  void set(TagState state, List<ItemBean> items) {

  }

  @override
  subReducer(reducer) {
    return super.subReducer(reducer);
  }
}
