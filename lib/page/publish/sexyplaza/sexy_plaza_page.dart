import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/home/post/common_post_adapter/adapter.dart';

import 'sexy_plaza_effect.dart';
import 'sexy_plaza_reducer.dart';
import 'sexy_plaza_state.dart';
import 'sexy_plaza_view.dart';

class SexyPlazaPage extends Page<SexyPlazaState, Map<String, dynamic>> {
  SexyPlazaPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<SexyPlazaState>(
                adapter: NoneConn<SexyPlazaState>() +
                    CommonPostAdapter<SexyPlazaState>(),
                slots: <String, Dependent<SexyPlazaState>>{
                }),
            middleware: <Middleware<SexyPlazaState>>[
            ],);

}
