import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/weibo_page/message/message_list_entity.dart';
import 'package:flutter_app/weibo_page/message/official_message_cell.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/weibo_page/message/message_detail/MessageDetails.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';

class OfficalMessagePage extends StatefulWidget {
  final MessageListDataList model;

  OfficalMessagePage({Key key, this.model}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OfficalMessagePageState();
  }
}

class _OfficalMessagePageState extends State<OfficalMessagePage> {
  RefreshController _refreshController = RefreshController();
  List<ListElement> _messageList;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData(currentPage, 10);
    });
  }

  ///请求数据
  void _loadData(int page, int size) async {
    try {
      dynamic messageDetail = await netManager.client
          .getMessageDetail(page, size, widget.model?.sessionId);
      Data messageDetailData = Data.fromJson(messageDetail);
      if(_messageList == null) _messageList = [];
      if ((messageDetailData?.list ?? []).isNotEmpty) {
        currentPage = page;
        if (page == 1) {
          _messageList.clear();
        }
        _messageList.addAll(messageDetailData?.list);
        //判断是否还有数据
        if (!(messageDetailData?.hasNext ?? false) && page == 1) {
          _refreshController?.loadNoData();
        } else {
          _refreshController?.loadComplete();
        }
      } else {
        currentPage = page;
        _refreshController?.loadNoData();
      }
    } catch (e) {
      l.e("加载消息列表-error:", "$e");
      if(_messageList == null) _messageList = [];
      _refreshController?.loadComplete();
    }
    String _datePre = "";
    for(int i = 0; i < _messageList.length; i++){
      var model = _messageList[i];
      if(model.yydDate != _datePre){
        model.isShowDate = true;
        _datePre = model.yydDate;
      }else {
        model.isShowDate = false;
      }
    }

    _refreshController.refreshCompleted();
    setState(() {});
  }


  void _loadMore(){
    _loadData(currentPage+1, 10);
  }
  void _refreshData(){
    _loadData(1, 10);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        titleSpacing: .0,
        title: Text(
          "官方消息",
          style: TextStyle(
              fontSize: AppFontSize.fontSize18,
              color: Colors.white,
              height: 1.4),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => safePopPage(),
        ),
      ),
      body: (_messageList == null) ? LoadingWidget() : Container(
        padding: EdgeInsets.only(top: 12),
        child: SmartRefresher(
          controller: _refreshController,
          enablePullUp: _messageList == null ? false : true,
          onLoading: _loadMore,
          onRefresh: _refreshData,
          child: ListView.builder(
            itemBuilder: (context, index) {
              return OfficialMessageCell(model: _messageList[index]);
            },
            itemCount: _messageList.length ?? 0,
          ),
        ),
      ),
    );
  }
}
