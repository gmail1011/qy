import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/wallet/mine_bill/item_component/component.dart';
import 'package:flutter_app/page/wallet/mine_bill/section_component/component.dart';
import 'package:flutter_app/page/wallet/mine_bill/page/state.dart';
import 'reducer.dart';

class MineBillAdapter extends SourceFlowAdapter<MineBillState> {
  MineBillAdapter()
      : super(
          pool: <String, Component<Object>>{
            'bill_item':MineBillItemComponent(),
            'bill_section':SectionComponent()
          },
          reducer: buildReducer(),
        );
}
