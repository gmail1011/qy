import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///推广记录
class PromotionRecordPage extends Page<PromotionRecordState, Map<String, dynamic>> {
  PromotionRecordPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<PromotionRecordState>(
                adapter: null,
                slots: <String, Dependent<PromotionRecordState>>{
                }),
            middleware: <Middleware<PromotionRecordState>>[
            ],);

}
