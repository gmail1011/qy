import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class AudiobookMorePage extends Page<AudiobookMoreState, Map<String, dynamic>> {
  AudiobookMorePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<AudiobookMoreState>(
                adapter: null,
                slots: <String, Dependent<AudiobookMoreState>>{
                }),
            middleware: <Middleware<AudiobookMoreState>>[
            ],);

}
