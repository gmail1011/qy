import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/page/search/search_page/page.dart';
import 'package:flutter_app/page/search/search_view/search_appbar.dart';

import 'search_default_action.dart';
import 'search_default_state.dart';

Widget buildView(SearchDefaultState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    backgroundColor: AppColors.primaryColor,
    appBar: SearchAppBar(
      controller: state.textEditingController,
      autofocus: false,
      onTap: (){
        JRouter().jumpPage(PAGE_SEARCH);
      },
    ),
  );
}
