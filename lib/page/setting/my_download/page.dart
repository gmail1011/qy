import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class MyDownloadPage extends Page<MyDownloadState, Map<String, dynamic>> {
  MyDownloadPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<MyDownloadState>(
                adapter: null,
                slots: <String, Dependent<MyDownloadState>>{
                }),
            middleware: <Middleware<MyDownloadState>>[
            ],);

}
