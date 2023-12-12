import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/tag/liaoba_tag_detail/compont/cell/component.dart';
import 'package:flutter_app/page/tag/liaoba_tag_detail/state.dart';

// ignore: deprecated_member_use
class LiaoBaTagDetailAdapter extends DynamicFlowAdapter<TagState> {
  LiaoBaTagDetailAdapter()
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
    if(state.videoModelList == null || state.videoModelList.isEmpty) {
      return items;
    }
    state.videoModelList.forEach((videoModel) {
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
