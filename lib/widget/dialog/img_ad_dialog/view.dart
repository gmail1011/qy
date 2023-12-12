import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'state.dart';

Widget buildView(ImgAdDialogState state, Dispatch dispatch, ViewService viewService) {
  return Dialog(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Image(
                image: null,
                width: Dimens.pt280,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
