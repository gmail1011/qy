import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/search/search_tag/adapter.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';
/// 最热
class HotListPage extends Page<HotListState, Map<String, dynamic>> {
  HotListPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<HotListState>(
                adapter: NoneConn<HotListState>()+SearchTagAdapter(),
                slots: <String, Dependent<HotListState>>{
                }),
            middleware: <Middleware<HotListState>>[
            ],);

}
