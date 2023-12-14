// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_api.dart';
// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _ClientApi implements ClientApi {
  _ClientApi(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<WalletModelEntity> getWallet() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/mine/wallet',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = WalletModelEntity.fromJson(_result.data);
    return value;
  }

  @override
  Future<dynamic> clickAdEvent(id) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'id': id};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/ads/click',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<DomainSourceModel> getRemoteConfig(pageNumber, pageSize) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageNumber': pageNumber, r'pageSize': pageSize};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/ping/domain',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = DomainSourceModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<NearbyBean> getCityVideoList(pageNumber, pageSize, city, newsType) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(city, 'city');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageNumber': pageNumber,
      r'pageSize': pageSize,
      r'city': city,
      r'newsType': newsType,
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/vid/location/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = NearbyBean.fromJson(_result.data);
    return value;
  }

  @override
  Future<SearchHotRankModel> loadHotRankData(pageNumber, pageSize) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageNumber': pageNumber, r'pageSize': pageSize};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/rank/hotsearch/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = SearchHotRankModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<TagBean> requestTagListData(pageNumber, pageSize, tagID, {sortType}) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(tagID, 'tagID');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'tagID': tagID,
      'sortType': sortType,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/tag/vid/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = TagBean.fromJson(_result.data);
    return value;
  }

  @override
  Future<TagBean> requestTagListDataByType(pageNumber, pageSize, tagID, newsType) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(tagID, 'tagID');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageNumber': pageNumber,
      r'pageSize': pageSize,
      r'tagID': tagID,
      r'newsType': newsType,
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/tag/vid/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = TagBean.fromJson(_result.data);
    return value;
  }

  @override
  Future<dynamic> requestLiaoBaTagListData(pageNumber, pageSize, sectionID) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(sectionID, 'sectionID');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageNumber': pageNumber,
      r'pageSize': pageSize,
      r'sectionID': sectionID,
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/vid/section',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    //final value = TagBean.fromJson(_result.data);
    LiaoBaTagsDetailData liaoBaTagsDetailData = LiaoBaTagsDetailData().fromJson(_result.data);
    return liaoBaTagsDetailData;
  }

  @override
  Future<dynamic> requestSelectedTagListData(pageNumber, pageSize, sectionID, sortType, playTimeType) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(sectionID, 'sectionID');
    ArgumentError.checkNotNull(sortType, 'sortType');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageNumber': pageNumber,
      r'pageSize': pageSize,
      'sortType': sortType,
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/vid/section/' + sectionID,
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    LiaoBaTagsDetailData liaoBaTagsDetailData = LiaoBaTagsDetailData().fromJson(_result.data);
    return liaoBaTagsDetailData;
  }

  @override
  Future<OrCodeModel> getQrCodeInfo() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/mine/certificate/qr',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = OrCodeModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<TagDetailModel> getTagDetail(tagID) async {
    ArgumentError.checkNotNull(tagID, 'tagID');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'tagID': tagID};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/tag/info',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = TagDetailModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<VipBuyHistory> getVipHistory(pageSize, pageNumber) async {
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageSize': pageSize, r'pageNumber': pageNumber};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/vip/history',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = VipBuyHistory.fromJson(_result.data);
    return value;
  }

  @override
  Future<MineVideo> getMineWorks(pageSize, pageNumber, newsType, type, [uid]) async {
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(newsType, 'newsType');
    ArgumentError.checkNotNull(type, 'type');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageSize': pageSize,
      r'pageNumber': pageNumber,
      r'uid': uid,
      r'newsType': newsType,
      r'type': type,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/mine/collection',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = MineVideo.fromJson(_result.data);
    return value;
  }

  @override
  Future<MineVideo> getMineBuy(int pageSize, int pageNumber, String newsType, int uid) async {
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(newsType, 'newsType');
    ArgumentError.checkNotNull(uid, 'uid');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageSize': pageSize,
      r'pageNumber': pageNumber,
      r'newsType': newsType,
      r'uid': uid
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/mine/buyVid',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = MineVideo.fromJson(_result.data);
    return value;
  }

  @override
  Future<MineVideo> getMineLike(pageSize, pageNumber, uid) async {
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(uid, 'uid');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageSize': pageSize, r'pageNumber': pageNumber, r'uid': uid};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/mine/like',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = MineVideo.fromJson(_result.data);
    return value;
  }

  @override
  Future<ProxyIncome> getProxyIncome(pageSize, pageNumber) async {
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageSize': pageSize, r'pageNumber': pageNumber};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/proxy/incomes',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = ProxyIncome.fromJson(_result.data);
    return value;
  }

  @override
  Future<ProxyInfo> getProxyInfo() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/proxy/info',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = ProxyInfo.fromJson(_result.data);
    return value;
  }

  @override
  Future<TokenModel> getOnlineCustomerImToken(mid, appId, sign) async {
    ArgumentError.checkNotNull(mid, 'mid');
    ArgumentError.checkNotNull(appId, 'appId');
    ArgumentError.checkNotNull(sign, 'sign');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'mid': mid, r'appId': appId, r'sign': sign};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/im/token',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = TokenModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<CommentListRes> getCommentList(objID, curTime, pageNumber, pageSize) async {
    ArgumentError.checkNotNull(objID, 'objID');
    ArgumentError.checkNotNull(curTime, 'curTime');
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'objID': objID,
      r'curTime': curTime,
      r'pageNumber': pageNumber,
      r'pageSize': pageSize
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/comment/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = CommentListRes.fromJson(_result.data);
    return value;
  }

  @override
  Future<ReplyListRes> getReplyList(objID, cmtId, curTime, pageNumber, pageSize, [fstID]) async {
    ArgumentError.checkNotNull(objID, 'objID');
    ArgumentError.checkNotNull(cmtId, 'cmtId');
    ArgumentError.checkNotNull(curTime, 'curTime');
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'objID': objID,
      r'cmtId': cmtId,
      r'curTime': curTime,
      r'pageNumber': pageNumber,
      r'pageSize': pageSize,
      r'fstID': fstID
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/comment/info',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = ReplyListRes.fromJson(_result.data);
    return value;
  }

  @override
  Future<WatchCount> getPlayStatus([vid]) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'vid': vid};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/vid/user/count',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = WatchCount.fromJson(_result.data);
    return value;
  }

  @override
  Future<HotTopicObj> getHotTopicList(pageNumber, pageSize) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageNumber': pageNumber, r'pageSize': pageSize};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/hotspot/htag',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = HotTopicObj.fromJson(_result.data);
    return value;
  }

  @override
  Future<PopularityObj> getPopularityList(pageNumber, pageSize) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageNumber': pageNumber, r'pageSize': pageSize};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/hotspot/rank',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = PopularityObj.fromJson(_result.data);
    return value;
  }

  @override
  Future<VideoObj> getTodayHottestVideoList(pageNumber, pageSize) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageNumber': pageNumber, r'pageSize': pageSize};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/hotspot/hotvid/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = VideoObj.fromJson(_result.data);
    return value;
  }

  @override
  Future<GoldObj> getGoldCoinAreaList() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/hotspot/area',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = GoldObj.fromJson(_result.data);
    return value;
  }

  @override
  Future<FindObj> getFindWonderfulList(pageNumber, pageSize) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageNumber': pageNumber, r'pageSize': pageSize};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/hotspot/wonder/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = FindObj.fromJson(_result.data);
    return value;
  }

  @override
  Future getPostList(pageNumber, pageSize, type, subType, reqDate, [city, version]) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(type, 'type');
    ArgumentError.checkNotNull(subType, 'subType');
    ArgumentError.checkNotNull(reqDate, 'reqDate');
    const _extra = <String, dynamic>{};

    final queryParameters = <String, dynamic>{
      r'pageNumber': pageNumber,
      r'pageSize': pageSize,
      r'type': type,
      r'subType': subType,
      r'reqDate': reqDate,
      r'city': city,
      r'version': version
    };

    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/vid/news/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    var value;
    if (_result.data != null && _result.data["version"] == "1.0.0") {
      value = CommonPostResNew.fromJson(_result.data);
    } else {
      value = CommonPostRes.fromJson(_result.data);
    }
    return value;
  }

  @override
  Future<ApBankListModel> getAliPayList() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/mine/txnact/alipay/get',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = ApBankListModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<ApBankListModel> getBankCardList() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/mine/txnact/yh/get',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = ApBankListModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<WithdrawDetailsModel> getWithdrawDetails(pageNumber, pageSize) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageNumber': pageNumber, r'pageSize': pageSize};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/withdraw/order',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = WithdrawDetailsModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<WithdrawDetailsModel> getIncomeDetails(pageNumber, pageSize) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageNumber': pageNumber, r'pageSize': pageSize};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/mine/iIncomes',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = WithdrawDetailsModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<WithdrawFeeModel> getAliPayFee(payType) async {
    ArgumentError.checkNotNull(payType, 'payType');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'payType': payType};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/withdraw/type',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = WithdrawFeeModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<WithdrawFeeModel> getBankCardFee(payType) async {
    ArgumentError.checkNotNull(payType, 'payType');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'payType': payType};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/withdraw/type',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = WithdrawFeeModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<HistoryIncomeModel> getIncomeList(pageNumber, pageSize) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageNumber': pageNumber, r'pageSize': pageSize};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/mine/income/works',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = HistoryIncomeModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<RechargeHistoryObj> getRechargeHistory(pageNumber, pageSize) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageNumber': pageNumber, r'pageSize': pageSize};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/mine/rchg/order',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = RechargeHistoryObj.fromJson(_result.data);
    return value;
  }

  @override
  Future<SpecialModel> getGroup(pageNumber, pageSize) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageNumber': pageNumber, r'pageSize': pageSize};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/tag/group',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = SpecialModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<TagsLiaoBaData> getTagsList() async {
    //ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    //ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageNumber': 1,
      r'pageSize': 100,
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/tag/conf/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = TagsLiaoBaData().fromJson(_result.data);
    Config.tagsLiaoBaData = value;
    return value;
  }

  @override
  Future<dynamic> getAnnounce() async {
    //ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    //ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      //r'pageNumber': pageNumber,
      // r'pageSize': pageSize
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/modules/announce',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = AnnounceLiaoBaData().fromJson(_result.data);
    return value;
  }

  @override
  Future<dynamic> getAnnounceLouFeng() async {
    //ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    //ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      //r'pageNumber': pageNumber,
      // r'pageSize': pageSize
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/loufeng/announce',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = AnnounceLiaoBaData().fromJson(_result.data);
    return value;
  }

  @override
  Future<dynamic> getTagsMarkList() async {
    //ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    //ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      //r'pageNumber': pageNumber,
      // r'pageSize': pageSize
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request('/modules/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    //final value = AnnounceLiaoBaData().fromJson(_result.data);

    List<TabsTagData> data = [];
    // _result.data.forEach((element) {
    //   TabsTagData tabsTagData = TabsTagData().fromJson(element);
    //   Config.homeDataTags.add(tabsTagData);
    // });
    TagsListModel tagsListModel = TagsListModel.fromJson(_result.data);
    Config.homeDataTags = tagsListModel.homePage;
    Config.communityDataTags = tagsListModel.community;
    Config.deepWeb = tagsListModel.deepWeb;
    return data;
  }

  @override
  Future<FansObj> getFansList(pageNumber, pageSize) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageNumber': pageNumber, r'pageSize': pageSize};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/follow/fans/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = FansObj.fromJson(_result.data);
    return value;
  }

  @override
  Future<LaudModel> getLikeList(pageNumber, pageSize) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageNumber': pageNumber, r'pageSize': pageSize};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/like/record/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = LaudModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<dynamic> getRecommendList(pageNumber, pageSize) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageNumber': pageNumber, r'pageSize': pageSize};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/recommend/user/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = FansObj.fromJson(_result.data);
    return _result.data;
  }

  @override
  Future<Countdown> getCutDown() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/vip/tiroCountdown',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = Countdown.fromJson(_result.data);
    return value;
  }

  @override
  Future<ReplyListModel> getCommentReplyList(pageNumber, pageSize) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageNumber': pageNumber, r'pageSize': pageSize};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/comment/reply/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = ReplyListModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<MessageObjModel> getNoticeList(pageNumber, pageSize, sender) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(sender, 'sender');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageNumber': pageNumber,
      r'pageSize': pageSize,
      r'sender': sender
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/inform/notice/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = MessageObjModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<HotCityModel> getHotCityList() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/loufeng/cities',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = HotCityModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<LouFengModel> getLouFengList(pageNumber, pageSize, city, hasAD, pageTitle, pageType) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(city, 'city');
    ArgumentError.checkNotNull(hasAD, 'hasAD');
    ArgumentError.checkNotNull(pageTitle, 'pageTitle');
    ArgumentError.checkNotNull(pageType, 'pageType');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageNumber': pageNumber,
      r'pageSize': pageSize,
      r'city': city,
      r'hasAD': hasAD,
      r'pageTitle': pageTitle,
      r'pageType': pageType
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/loufeng/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = LouFengModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<LouFengModel> getLouFengListNew(pageNumber, pageSize, city, hasAD, pageTitle, pageType) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(city, 'city');
    ArgumentError.checkNotNull(hasAD, 'hasAD');
    ArgumentError.checkNotNull(pageTitle, 'pageTitle');
    ArgumentError.checkNotNull(pageType, 'pageType');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageNumber': pageNumber,
      r'pageSize': pageSize,
      r'city': city,
      r'hasAD': hasAD,
      r'pageTitle': pageTitle,
      r'pageType': pageType
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/loufeng/list/new',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = LouFengModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<LouFengModel> getLouFengAgentList(pageNumber, pageSize, agent) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageNumber': pageNumber,
      r'pageSize': pageSize,
      'agent': agent
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/loufeng/agent/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = LouFengModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<dynamic> verifyReport(productID, serviceDetails, imgs, videos) async {
    ArgumentError.checkNotNull(productID, 'productID');
    ArgumentError.checkNotNull(serviceDetails, 'serviceDetails');
    ArgumentError.checkNotNull(imgs, 'imgs');
    ArgumentError.checkNotNull(videos, 'videos');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'productID': productID, 'serviceDetails': serviceDetails, 'imgs': imgs, 'videos': videos};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/loufeng/verifyReport',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> reportErrFiction() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request('/fiction/feedback',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<NoveDetailsModel> fictionGet(id) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'id': id};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/fiction/get',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = NoveDetailsModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<NovelModel> getFictionSearch(keyword, pageNumber, pageSize) async {
    ArgumentError.checkNotNull(keyword, 'keyword');
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'keyword': keyword,
      r'pageNumber': pageNumber,
      r'pageSize': pageSize
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/fiction/search',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = NovelModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<NovelModel> getFictionList(fictionType, pageNumber, pageSize) async {
    ArgumentError.checkNotNull(fictionType, 'fictionType');
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'fictionType': fictionType,
      r'pageNumber': pageNumber,
      r'pageSize': pageSize
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/fiction/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = NovelModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<FictionModel> getFictionTypes() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/fiction/fictionTypes',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = FictionModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<VerifyReportModel> getLoufengVerifyReport(productID, pageNumber, pageSize) async {
    ArgumentError.checkNotNull(productID, 'productID');
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'productID': productID,
      r'pageNumber': pageNumber,
      r'pageSize': pageSize
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/loufeng/verifyReport',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = VerifyReportModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<LouFengModel> getSearchList(pageNumber, pageSize, keyword) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(keyword, 'keyword');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageNumber': pageNumber,
      r'pageSize': pageSize,
      r'keyword': keyword
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/loufeng/search',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = LouFengModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<LouFengModel> getBuyList(pageNumber, pageSize) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageNumber': pageNumber, r'pageSize': pageSize};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/loufeng/buylog',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = LouFengModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<LouFengModel> getReserveList(pageNumber, pageSize) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageNumber': pageNumber, r'pageSize': pageSize};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/loufeng/book/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = LouFengModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<LouFengModel> getCollectList(pageNumber, pageSize, uid, type) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(uid, 'uid');
    ArgumentError.checkNotNull(type, 'type');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageNumber': pageNumber,
      r'pageSize': pageSize,
      r'uid': uid,
      r'type': type
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/mine/collect/infoList',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = LouFengModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<NovelModel> getFictionCollectList(pageNumber, pageSize, uid, type) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(uid, 'uid');
    ArgumentError.checkNotNull(type, 'type');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageNumber': pageNumber,
      r'pageSize': pageSize,
      r'uid': uid,
      r'type': type
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/mine/collect/infoList',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = NovelModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<dynamic> fictionBrowse(id) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'id': id};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/fiction/browse',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<AudioBookListModel> getAudioHots(pageNumber, pageSize) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageNumber': pageNumber, r'pageSize': pageSize};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/audiobook/hots',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = AudioBookListModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<NovelModel> getFictionHots(pageNumber, pageSize) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageNumber': pageNumber, r'pageSize': pageSize};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/fiction/hots',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = NovelModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<LouFengObj> getLouFengItem(id) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'id': id};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/loufeng/get',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = LouFengObj.fromJson(_result.data);
    return value;
  }

  @override
  Future<LouFengModel> getNextLouFeng([size = 1]) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'size': size};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/loufeng/random',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = LouFengModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<NovelModel> getNextNovel([size = 1]) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'size': size};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/fiction/random',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = NovelModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<dynamic> postBrowse(id) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'id': id};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/loufeng/browse',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> postCollect(objId, type, isCollect) async {
    ArgumentError.checkNotNull(objId, 'objId');
    ArgumentError.checkNotNull(type, 'type');
    ArgumentError.checkNotNull(isCollect, 'isCollect');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'objId': objId, 'type': type, 'isCollect': isCollect};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/mine/collect',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> postNakeChatCollect(id, action) async {
    ArgumentError.checkNotNull(id, 'id');
    ArgumentError.checkNotNull(action, 'action');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      'id': id,
      'action': action,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/nude/chat/collect',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> postFeedBack(loufengID, feedbackType, imgs, content) async {
    ArgumentError.checkNotNull(loufengID, 'loufengID');
    ArgumentError.checkNotNull(feedbackType, 'feedbackType');
    ArgumentError.checkNotNull(imgs, 'imgs');
    ArgumentError.checkNotNull(content, 'content');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'loufengID': loufengID, 'feedbackType': feedbackType, 'imgs': imgs, 'content': content};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/loufeng/feedback',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> postNakeChatFeedBack(loufengID, feedbackType, imgs, content) async {
    ArgumentError.checkNotNull(loufengID, 'nudeChatId');
    ArgumentError.checkNotNull(feedbackType, 'type');
    ArgumentError.checkNotNull(imgs, 'images');
    ArgumentError.checkNotNull(content, 'content');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'nudeChatId': loufengID, 'type': feedbackType, 'images': imgs, 'content': content};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/nude/chat/feedback',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<MessageTypeModel> getNoticeTypeList() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/inform/preview',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = MessageTypeModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<dynamic> postDelWork(ids) async {
    ArgumentError.checkNotNull(ids, 'ids');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'ids': ids};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/vid/remove',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> postExchangeCode(code) async {
    ArgumentError.checkNotNull(code, 'code');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'code': code};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/code/exchange',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> postSendSms(mobile, [type]) async {
    ArgumentError.checkNotNull(mobile, 'mobile');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {'mobile': mobile, 'type': type};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/sms/captcha',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> postBindPhoneNew(mobile, code, devID, smsId, sysType, ver, devType, applicationID) async {
    ArgumentError.checkNotNull(mobile, 'mobile');
    ArgumentError.checkNotNull(code, 'code');
    ArgumentError.checkNotNull(devID, 'devID');
    ArgumentError.checkNotNull(smsId, 'smsId');
    ArgumentError.checkNotNull(sysType, 'sysType');
    ArgumentError.checkNotNull(ver, 'ver');
    ArgumentError.checkNotNull(devType, 'devType');
    ArgumentError.checkNotNull(applicationID, 'applicationID');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      'mobile': mobile,
      'code': code,
      'devID': devID,
      'smsId': smsId,
      'sysType': sysType,
      'ver': ver,
      'devType': devType,
      'applicationID': applicationID
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/mine/mobileBind',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<VideoObj> postSearch(pageNumber, pageSize, tagID) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(tagID, 'tagID');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'pageNumber': pageNumber, 'pageSize': pageSize, 'tagID': tagID};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/wonder/vid/list',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = VideoObj.fromJson(_result.data);
    return value;
  }

  ///提现
  @override
  Future<dynamic> withdraw(
    String payType,
    String act,
    int money,
    String name,
    String actName,
    String devID,
    String bankCode,
    int withdrawType,
    int productType,
  ) async {
    ArgumentError.checkNotNull(payType, 'payType');
    ArgumentError.checkNotNull(act, 'act');
    ArgumentError.checkNotNull(money, 'money');
    ArgumentError.checkNotNull(name, 'name');
    ArgumentError.checkNotNull(actName, 'actName');
    ArgumentError.checkNotNull(devID, 'devID');
    ArgumentError.checkNotNull(bankCode, 'bankCode');
    ArgumentError.checkNotNull(withdrawType, 'withdrawType');
    ArgumentError.checkNotNull(productType, 'productType');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      'payType': payType,
      'act': act,
      'money': money,
      'name': name,
      'actName': actName,
      'devID': devID,
      'bankCode': bankCode,
      'withdrawType': withdrawType,
      'productType': productType,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/withdraw',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<RechargeUrlModel> postRecharge(rechargeType, [productId, vipID]) async {
    ArgumentError.checkNotNull(rechargeType, 'rechargeType');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {'rechargeType': rechargeType, 'productId': productId, 'vipID': vipID};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/mine/recharge',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = RechargeUrlModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<dynamic> getAddBankCard(act, actName, bankCode, cardType) async {
    ArgumentError.checkNotNull(act, 'act');
    ArgumentError.checkNotNull(actName, 'actName');
    ArgumentError.checkNotNull(bankCode, 'bankCode');
    ArgumentError.checkNotNull(cardType, 'cardType');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'act': act, 'actName': actName, 'bankCode': bankCode, 'cardType': cardType};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/mine/txnact/yh/add',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getAddAp(act, actName) async {
    ArgumentError.checkNotNull(act, 'act');
    ArgumentError.checkNotNull(actName, 'actName');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'act': act, 'actName': actName};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/mine/txnact/alipay/add',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> sendVideoRecord(videoID, playWay, longer, progress, via, [tagID]) async {
    ArgumentError.checkNotNull(videoID, 'videoID');
    ArgumentError.checkNotNull(playWay, 'playWay');
    ArgumentError.checkNotNull(longer, 'longer');
    ArgumentError.checkNotNull(progress, 'progress');
    ArgumentError.checkNotNull(via, 'via');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {
      'videoID': videoID,
      'playWay': playWay,
      'longer': longer,
      'progress': progress,
      'via': via,
      'tagID': tagID
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/vid/play',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> shareReport(objType, objID, types, uid, objUID) async {
    ArgumentError.checkNotNull(objType, 'objType');
    ArgumentError.checkNotNull(objID, 'objID');
    ArgumentError.checkNotNull(types, 'types');
    ArgumentError.checkNotNull(uid, 'uid');
    ArgumentError.checkNotNull(objUID, 'objUID');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'objType': objType, 'objID': objID, 'types': types, 'uid': uid, 'objUID': objUID};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/mine/report',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<CommentModel> sendComment(objID, level, content) async {
    ArgumentError.checkNotNull(objID, 'objID');
    ArgumentError.checkNotNull(level, 'level');
    ArgumentError.checkNotNull(content, 'content');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'objID': objID, 'level': level, 'content': content};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/comment/send',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = CommentModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<ReplyModel> sendReply(objID, level, content, [cid, rid, userID]) async {
    ArgumentError.checkNotNull(objID, 'objID');
    ArgumentError.checkNotNull(level, 'level');
    ArgumentError.checkNotNull(content, 'content');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {
      'objID': objID,
      'level': level,
      'content': content,
      'cid': cid,
      'rid': rid,
      'userID': userID
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/comment/send',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = ReplyModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<dynamic> cancelLike(objID, type) async {
    ArgumentError.checkNotNull(objID, 'objID');
    ArgumentError.checkNotNull(type, 'type');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'objID': objID, 'type': type};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/thumbsDown',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> sendLike(objID, type) async {
    ArgumentError.checkNotNull(objID, 'objID');
    ArgumentError.checkNotNull(type, 'type');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'objID': objID, 'type': type};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/thumbsUp',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> postExChangeCode(code) async {
    ArgumentError.checkNotNull(code, 'code');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'code': code};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/code/exchange',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getProxyBind(promotionCode) async {
    ArgumentError.checkNotNull(promotionCode, 'promotionCode');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'promotionCode': promotionCode};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/proxy/bind',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> postBuyVideo(productID, name, amount, productType) async {
    ArgumentError.checkNotNull(productID, 'productID');
    ArgumentError.checkNotNull(name, 'name');
    ArgumentError.checkNotNull(amount, 'amount');
    ArgumentError.checkNotNull(productType, 'productType');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      'productID': productID,
      'name': name,
      'amount': amount,
      'productType': productType,
    };
    _data.removeWhere((k, v) => v == null);

    final _result = await _dio.request('/product/buy',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> postBuyVideoWithDiscountCard(productID, name, amount, productType, gold) async {
    ArgumentError.checkNotNull(productID, 'productID');
    ArgumentError.checkNotNull(name, 'name');
    ArgumentError.checkNotNull(amount, 'amount');
    ArgumentError.checkNotNull(productType, 'productType');
    ArgumentError.checkNotNull(gold, 'goldVideoCouponNum');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      'productID': productID,
      'name': name,
      'amount': amount,
      'productType': productType,
      'goldVideoCouponNum': gold,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/product/buy',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> postBuyLouFengWithDisCountCard(productID, name, amount, productType, couponId) async {
    ArgumentError.checkNotNull(productID, 'productID');
    ArgumentError.checkNotNull(name, 'name');
    ArgumentError.checkNotNull(amount, 'amount');
    ArgumentError.checkNotNull(productType, 'productType');
    ArgumentError.checkNotNull(productType, 'couponId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      'productID': productID,
      'name': name,
      'amount': amount,
      'productType': productType,
      'couponId': couponId,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/product/buy',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> postBuyNakeChat(
    String productID,
    int productType,
    String serviceId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      'productID': productID,
      'productType': productType,
      'serviceId': serviceId,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/product/buy',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> postBuyNovel(productType, productID, [chapterID]) async {
    ArgumentError.checkNotNull(productType, 'productType');
    ArgumentError.checkNotNull(productID, 'productID');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {'productType': productType, 'productID': productID, 'chapterID': chapterID};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/product/buy',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> reward(vid, coins, msg) async {
    ArgumentError.checkNotNull(vid, 'vid');
    ArgumentError.checkNotNull(coins, 'coins');
    ArgumentError.checkNotNull(msg, 'msg');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'vid': vid, 'coins': coins, 'msg': msg};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/mine/reward',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getFollow(followUID, isFollow) async {
    ArgumentError.checkNotNull(followUID, 'followUID');
    ArgumentError.checkNotNull(isFollow, 'isFollow');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'followUID': followUID, 'isFollow': isFollow};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/mine/follow',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> changeTagStatus(objID, isCollect, type) async {
    ArgumentError.checkNotNull(objID, 'objID');
    ArgumentError.checkNotNull(isCollect, 'isCollect');
    ArgumentError.checkNotNull(type, 'type');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'objID': objID, 'isCollect': isCollect, 'type': type};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/mine/collect',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<SearchTopicModel> loadSearchTopicData(pageNumber, pageSize, theme) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(theme, 'theme');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'pageNumber': pageNumber, 'pageSize': pageSize, 'theme': theme};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/tone/vid/list',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = SearchTopicModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<dynamic> clickCollect(objID, type, isCollect) async {
    ArgumentError.checkNotNull(objID, 'objID');
    ArgumentError.checkNotNull(type, 'type');
    ArgumentError.checkNotNull(isCollect, 'isCollect');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'objID': objID, 'type': type, 'isCollect': isCollect};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/mine/collect',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> isWantGoCity(objID, type, isCollect) async {
    ArgumentError.checkNotNull(objID, 'objID');
    ArgumentError.checkNotNull(type, 'type');
    ArgumentError.checkNotNull(isCollect, 'isCollect');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'objID': objID, 'type': type, 'isCollect': isCollect};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/mine/collect',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<LouFengModel> getSearchData(pageNumber, pageSize, keyWords, realm) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(keyWords, 'keyWords');
    ArgumentError.checkNotNull(realm, 'realm');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'pageNumber': pageNumber, 'pageSize': pageSize, 'keyWords': keyWords, 'realm': realm};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/search/list',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = LouFengModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<SearchTalkObj> getTalkData(pageNumber, pageSize, keyWords, realm) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(keyWords, 'keyWords');
    ArgumentError.checkNotNull(realm, 'realm');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'pageNumber': pageNumber, 'pageSize': pageSize, 'keyWords': keyWords, 'realm': realm};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/search/list',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = SearchTalkObj.fromJson(_result.data);
    return value;
  }

  @override
  Future<SearchVideoObj> getVideoData(pageNumber, pageSize, keyWords, realm) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(keyWords, 'keyWords');
    ArgumentError.checkNotNull(realm, 'realm');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'pageNumber': pageNumber, 'pageSize': pageSize, 'keyWords': keyWords, 'realm': realm};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/search/list',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = SearchVideoObj.fromJson(_result.data);
    return value;
  }

  @override
  Future<SearchUserObj> getUserData(pageNumber, pageSize, keyWords, realm) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(keyWords, 'keyWords');
    ArgumentError.checkNotNull(realm, 'realm');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'pageNumber': pageNumber, 'pageSize': pageSize, 'keyWords': keyWords, 'realm': realm};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/search/list',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = SearchUserObj.fromJson(_result.data);
    return value;
  }

  @override
  Future<UserInfoModel> devLogin(devID, qrCnt, devType, sysType, ver, buildID, devToken,
      [cutInfos = ""]) async {
    ArgumentError.checkNotNull(devID, 'devID');
    ArgumentError.checkNotNull(qrCnt, 'qrCnt');
    ArgumentError.checkNotNull(devType, 'devType');
    ArgumentError.checkNotNull(sysType, 'sysType');
    ArgumentError.checkNotNull(ver, 'ver');
    ArgumentError.checkNotNull(buildID, 'buildID');
    ArgumentError.checkNotNull(devToken, 'devToken');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {
      'devID': devID,
      'qrCnt': qrCnt,
      'devType': devType,
      'sysType': sysType,
      'ver': ver,
      'buildID': buildID,
      'devToken': devToken,
      'cutInfos': cutInfos
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/mine/login',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);

    ///goldVideoCoupon
    final value = UserInfoModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<MobileLoginModel> mobileLogin(mobile, code, devID, devType, sysType, ver, buildID,
      [cutInfos = ""]) async {
    ArgumentError.checkNotNull(mobile, 'mobile');
    ArgumentError.checkNotNull(code, 'code');
    ArgumentError.checkNotNull(devID, 'devID');
    ArgumentError.checkNotNull(devType, 'devType');
    ArgumentError.checkNotNull(sysType, 'sysType');
    ArgumentError.checkNotNull(ver, 'ver');
    ArgumentError.checkNotNull(buildID, 'buildID');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {
      'mobile': mobile,
      'code': code,
      'devID': devID,
      'devType': devType,
      'sysType': sysType,
      'ver': ver,
      'buildID': buildID,
      'cutInfos': cutInfos
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/mine/mobileLoginOnly',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = MobileLoginModel.fromJson(_result.data);
    return value;
  }

  @override
  Future updateUserInfo(map) async {
    ArgumentError.checkNotNull(map, 'map');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map ?? <String, dynamic>{});
    final _result = await _dio.request('/mine/info',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<UserInfoModel> getUserInfo([uid = 0]) async {
    const _extra = <String, dynamic>{};

    final queryParameters = <String, dynamic>{r'uid': uid};
    if (GlobalStore.isMe(uid)) {
      queryParameters.clear();
    }
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/mine/info',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = UserInfoModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<MineBillSectionModel> getMineBillList(pageNumber, pageSize, year, month) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(year, 'year');
    ArgumentError.checkNotNull(month, 'month');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageNumber': pageNumber,
      r'pageSize': pageSize,
      r'year': year,
      r'month': month
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/mine/zhangdan',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = MineBillSectionModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<RechargeRecordModel> getMineTransaction(pageNumber, pageSize) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};

    final _data = <String, dynamic>{
      r'pageNumber': pageNumber,
      r'pageSize': pageSize,
    };
    final _result = await _dio.request<Map<String, dynamic>>('/mine/transaction',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = RechargeRecordModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<String> bankCardDelete(id) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'id': id};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<String>('/mine/txnact/del',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'DELETE', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<LocationBean> autoLocation() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/mine/autoLocate',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = LocationBean.fromJson(_result.data);
    return value;
  }

  @override
  Future<CityDetailModel> getCityDetail(id) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'id': id};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/vid/location/info',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = CityDetailModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<RewardListModel> getRewardUserList(pageNumber, [pageSize = Config.PAGE_SIZE]) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageNumber': pageNumber, r'pageSize': pageSize};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/mine/reward/log',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = RewardListModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<ServerTime> getReqDate() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/ping/sysDate',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = ServerTime.fromJson(_result.data);
    return value;
  }

  @override
  Future<String> publishPost(
    title,
    content,
    newsType, {
    tags,
    playTime,
    cover,
    coverThumb,
    seriesCover,
    via,
    coins,
    size,
    mimeType,
    actor,
    sourceURL,
    sourceID,
    filename,
    resolution,
    ratio,
    md5,
    freeTime,
    location,
    coin,
    taskID,
  }) async {
    ArgumentError.checkNotNull(title, 'title');
    ArgumentError.checkNotNull(content, 'content');
    ArgumentError.checkNotNull(newsType, 'newsType');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = taskID == null || taskID == ""
        ? {
            'title': title,
            'content':content,
            'newsType': newsType,
            'tags': tags,
            'playTime': playTime,
            'cover': cover,
            'coverThumb': coverThumb,
            'seriesCover': seriesCover,
            'via': via,
            'coins': coins,
            'size': size,
            'mimeType': mimeType,
            'actor': actor,
            'sourceURL': sourceURL,
            'sourceID': sourceID,
            'filename': filename,
            'resolution': resolution,
            'ratio': ratio,
            'md5': md5,
            'freeTime': freeTime,
            'location': location,
          }
        : {
            'title': title,
            'newsType': newsType,
            'tags': tags,
            'playTime': playTime,
            'cover': cover,
            'coverThumb': coverThumb,
            'seriesCover': seriesCover,
            'via': via,
            'coins': coins,
            'size': size,
            'mimeType': mimeType,
            'actor': actor,
            'sourceURL': sourceURL,
            'sourceID': sourceID,
            'filename': filename,
            'resolution': resolution,
            'ratio': ratio,
            'md5': md5,
            'freeTime': freeTime,
            'location': location,
            'taskID': taskID
          };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<String>('/vid/submit',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<TagListModel> getTags(pageNumber, [pageSize = Config.PAGE_SIZE]) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageNumber': pageNumber, r'pageSize': pageSize};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/tag/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = TagListModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<HotTagModel> getHotTags() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/search/hotTag',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = HotTagModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<TagDetailModel> createTag(tagName) async {
    ArgumentError.checkNotNull(tagName, 'tagName');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'tagName': tagName};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/tag/add/new',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = TagDetailModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<ServicesModel> getServices() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/im/newSign',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = ServicesModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<NewProductList> getNewVipTypeList() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/vip/product',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = NewProductList.fromJson(_result.data);
    return value;
  }

  @override
  Future<RechargeListModel> getRechargeTypeList() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/mine/rechargeTypeList',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = RechargeListModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<RechargeListModel> getNakeChatRechargeTypeList(int type) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'type': type,
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/mine/currencys',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = RechargeListModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<dynamic> buyVipProduct(productType, productID, productName, discountedPrice, {couponId}) async {
    ArgumentError.checkNotNull(productType, 'productType');
    ArgumentError.checkNotNull(productID, 'productID');
    ArgumentError.checkNotNull(productName, 'productName');
    ArgumentError.checkNotNull(discountedPrice, 'discountedPrice');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      'productType': productType,
      'productID': productID,
      'productName': productName,
      'discountedPrice': discountedPrice,
      'couponId': couponId
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/product/buy',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<RecommendListRes> getRecommendVideoList(pageNumber, [pageSize = Config.PAGE_SIZE]) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageNumber': pageNumber, r'pageSize': pageSize};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/recommend/vid/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = RecommendListRes.fromJson(_result.data);
    value.vInfo.removeWhere((element) => element.newsType == "COVER");
    return value;
  }

  @override
  Future<dynamic> getCoupon(
    int productType,
    String productId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      "productType": productType,
      "productId": productId,
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request('/product/coupon',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<RecommendListRes> getFollowList(pageNumber, [pageSize = Config.PAGE_SIZE]) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageNumber': pageNumber, r'pageSize': pageSize};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/follow/dynamics/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = RecommendListRes.fromJson(_result.data);
    return value;
  }

  @override
  Future<WatchlistModel> getFollowedUserList(pageNumber, [pageSize = Config.PAGE_SIZE]) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageNumber': pageNumber, r'pageSize': pageSize};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/follow/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = WatchlistModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<WatchlistModel> getBloggerFollowedUserList(pageNumber, uid, [pageSize = Config.PAGE_SIZE]) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageNumber': pageNumber,
      r'pageSize': pageSize,
      r'uid': uid,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/follow/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = WatchlistModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<dynamic> feedback(content) async {
    ArgumentError.checkNotNull(content, 'content');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'content': content};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/mine/feedback',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<FeedbackModel> feedbackList(pageNumber, [pageSize = Config.PAGE_SIZE]) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageNumber': pageNumber, r'pageSize': pageSize};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/mine/feedback/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = FeedbackModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<dynamic> deleteBuyWork(id) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'productID': id};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/product/delBrought',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<PublishTagModel> getPublishTags(pageNumber, [pageSize = Config.PAGE_SIZE]) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageNumber': pageNumber, r'pageSize': pageSize};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/tag/v2/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = PublishTagModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<List<String>> getReportList() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>('/mine/report/types/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data.cast<String>();
    return value;
  }

  @override
  Future<PromotionModel> getProxyBindRecord(pageSize, pageNumber) async {
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'pageSize': pageSize, 'pageNumber': pageNumber};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/userinvite/userlist',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = PromotionModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<InviteIncomeModel> getInviteIncomeList(pageSize, pageNumber) async {
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'pageSize': pageSize, 'pageNumber': pageNumber};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/userinvite/incomelist',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = InviteIncomeModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<VideoIncomeModel> getVideoIncomeList(pageSize, pageNumber) async {
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'pageSize': pageSize, 'pageNumber': pageNumber};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/userinvite/videolist',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = VideoIncomeModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<UserIncomeModel> getUserAllIncomeInfo() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/userinvite/info',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = UserIncomeModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<UserIncomeModel> getGameAllIncomeInfo() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/userinvite/info/wali',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = UserIncomeModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<GamePromotionData> getIncomeInfo(pageSize, pageNumber) async {
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'pageSize': pageSize, 'pageNumber': pageNumber};
    final _result = await _dio.request<Map<String, dynamic>>('/userinvite/incomelist/wali',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = GamePromotionData().fromJson(_result.data);
    return value;
  }

  @override
  Future<AudioBookHomeModel> getAudioBookHome() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/audiobook/home',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = AudioBookHomeModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<AudioBook> getAudioBookDetail(id) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'id': id};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/audiobook/get',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = AudioBook.fromJson(_result.data);
    return value;
  }

  @override
  Future<AnchorModel> getAnchorList(pageSize, pageNumber) async {
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageSize': pageSize, r'pageNumber': pageNumber};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/audiobook/anchor',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = AnchorModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<AudioBookListModel> getAnchorAudioBookList(pageSize, pageNumber, name) async {
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(name, 'name');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageSize': pageSize,
      r'pageNumber': pageNumber,
      r'name': name
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/audiobook/anchorList',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = AudioBookListModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<AudioBookTypeModel> getAudioBookType() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/audiobook/audiobookTypes',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = AudioBookTypeModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<AudioBookListModel> getAudioBookList(pageSize, pageNumber, audiobookType) async {
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(audiobookType, 'audiobookType');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageSize': pageSize,
      r'pageNumber': pageNumber,
      r'audiobookType': audiobookType
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/audiobook/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = AudioBookListModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<AudioBookListModel> getAudioBookBuylogList(pageSize, pageNumber) async {
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageSize': pageSize, r'pageNumber': pageNumber};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/audiobook/buylog',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = AudioBookListModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<AudioBookListModel> getAudioBookRandomList(size) async {
    ArgumentError.checkNotNull(size, 'size');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'size': size};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/audiobook/random',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = AudioBookListModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<AudioBookListModel> getAudioBookCollectList(pageNumber, pageSize, uid, {type = 'audiobook'}) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(uid, 'uid');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageNumber': pageNumber,
      r'pageSize': pageSize,
      r'uid': uid,
      r'type': type
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/mine/collect/infoList',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = AudioBookListModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<AnchorModel> getAnchorCollectList(pageNumber, pageSize, uid, {type = 'audioAnchor'}) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(uid, 'uid');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageNumber': pageNumber,
      r'pageSize': pageSize,
      r'uid': uid,
      r'type': type
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/mine/collect/infoList',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = AnchorModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<dynamic> audioBookBrowse(id) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'id': id};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/audiobook/browse',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<AudioBookListModel> seachAudioBook(pageSize, pageNumber, keyword) async {
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(keyword, 'keyword');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageSize': pageSize,
      r'pageNumber': pageNumber,
      r'keyword': keyword
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/audiobook/search',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = AudioBookListModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<AnchorModel> getAnchorRandomList(size) async {
    ArgumentError.checkNotNull(size, 'size');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'size': size};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/audiobook/anchor/random',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = AnchorModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<dynamic> receiveLouFengDiscount() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request('/product/receiveLouFengDiscount',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<UpGradeVipInfo> getUpVipInfo() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/vip/upInfo',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = UpGradeVipInfo.fromJson(_result.data);
    return value;
  }

  @override
  Future<ListAnnounInfo> getVipAnnoun() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/vip/Announ',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = ListAnnounInfo.fromJson(_result.data);
    return value;
  }

  @override
  Future<dynamic> upgradVip() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request('/vip/up',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<List<NewHotCity>> getHotCity() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>('/vid/location/hot',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    var value = _result.data.map((dynamic i) => NewHotCity.fromJson(i as Map<String, dynamic>)).toList();
    return value;
  }

  @override
  Future<dynamic> getBalance() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request('/game/dongfang/getBalance',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    Config.gameBalanceEntity = GameBalanceEntity().fromJson(value);
    return value;
  }

  @override
  Future<dynamic> getGameUrl(String gameId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      'game': gameId,
    };
    final _result = await _dio.request('/game/dongfang/gameEnter',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future transfer(int amount) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      //"credit": amount,
    };
    final _data = <String, dynamic>{
      "credit": amount,
    };
    final _result = await _dio.request('/game/dongfang/transfer',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);

    final value = _result;
    return value;
  }

  @override
  Future<RechargeListModel> getGameAmountList() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request('/game/dongfang/jine/list',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = RechargeListModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<RechargeUrlModel> postGameRecharge(String rechargeType,
      [String productId, String vipID, int productType, int money]) async {
    ArgumentError.checkNotNull(rechargeType, 'rechargeType');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {
      'rechargeType': rechargeType,
      'productId': productId,
      'vipID': vipID,
      'productType': 1,
      'money': money
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/mine/recharge',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = RechargeUrlModel.fromJson(_result.data);
    return value;
  }

  ///详情页面通过直充购买购买裸聊服务
  @override
  Future<RechargeUrlModel> postNakeChatRecharge(String rechargeType,
      [String productId, String serviceId]) async {
    ArgumentError.checkNotNull(rechargeType, 'rechargeType');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {
      'rechargeType': rechargeType,
      'productId': productId,
      'serviceId': serviceId,
      'productType': 0,
      'productChildType': 4,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/mine/recharge',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = RechargeUrlModel.fromJson(_result.data);
    return value;
  }

  ///果币钱包通过直充购买购买果币
  @override
  Future<RechargeUrlModel> postNakeChatWalletRecharge(String rechargeType, [String productId]) async {
    ArgumentError.checkNotNull(rechargeType, 'rechargeType');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {
      'rechargeType': rechargeType,
      'productId': productId,
      'productType': 0,
      'productChildType': 3,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/mine/recharge',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = RechargeUrlModel.fromJson(_result.data);
    return value;
  }

  @override
  Future withdrawGame(
      String payType, String act, int money, String actName, String deviceType, int productType) async {
    ArgumentError.checkNotNull(payType, 'payType');
    ArgumentError.checkNotNull(act, 'act');
    ArgumentError.checkNotNull(money, 'money');
    ArgumentError.checkNotNull(actName, 'actName');
    ArgumentError.checkNotNull(deviceType, 'deviceType');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      'payType': payType,
      'Act': act,
      'money': money,
      'ActName': actName,
      'deviceType': deviceType,
      'productType': 1,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/withdraw',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future transferTax() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/game/dongfang/transfer',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    Config.transferTax = value["transferTax"];
    return value;
  }

  @override
  Future<dynamic> getGameMineBillList(int pageNumber, [int pageSize = Config.PAGE_SIZE]) async {
    // TODO: implement getGameMineBillList
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{
      'pageNum': pageNumber,
      'pageSize': pageSize,
    };
    final _result = await _dio.request<Map<String, dynamic>>('/game/dongfang/translog',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getNakeChatMineBillList(int pageNumber, [int pageSize = Config.PAGE_SIZE]) async {
    // TODO: implement getGameMineBillList
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/mine/fruitCoin/bill',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getAVData(int pageNumber, [int pageSize = Config.PAGE_SIZE]) async {
    // TODO: implement getGameMineBillList
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{
      'PageNumber': pageNumber,
      'PageSize': pageSize,
    };
    final _result = await _dio.request<Map<String, dynamic>>('/avcomment/list',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    dynamic value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getAVCommentaryDetail(String id) async {
    // TODO: implement getGameMineBillList
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{
      'id': id,
    };
    final _result = await _dio.request<Map<String, dynamic>>('/avcomment/one',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    dynamic value = _result.data;
    return value;
  }

  @override
  Future<dynamic> postBuyAVCommentary(productID, name, amount, productType) async {
    ArgumentError.checkNotNull(productID, 'productID');
    ArgumentError.checkNotNull(name, 'name');
    ArgumentError.checkNotNull(amount, 'amount');
    ArgumentError.checkNotNull(productType, 'productType');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'productID': productID, 'name': name, 'amount': amount, 'productType': productType};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/product/buy',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> postTuiGuangCode(code) async {
    ArgumentError.checkNotNull(code, 'code');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'promotionCode': code};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/mine/inviteBind',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> QUERY_TUI_GUANG() async {
    // TODO: implement QUERY_TUI_GUANG
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request('/mine/inviter',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    var value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getGameAnnouncement() async {
    // TODO: implement QUERY_TUI_GUANG
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request('/game/dongfang/announcement',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    var value = _result.data;
    return value;
  }

  @override
  Future getFirstEnterGame() async {
    // TODO: implement QUERY_TUI_GUANG
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request('/game/dongfang/firstEnter',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    var value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getAVCommentaryCollectList(pageNumber, pageSize, uid, type) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(uid, 'uid');
    ArgumentError.checkNotNull(type, 'type');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageNumber': pageNumber,
      r'pageSize': pageSize,
      r'uid': uid,
      r'type': type
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/mine/collect/infoList',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future cancelLikeAVCommentary(String objID, String type, String tagID) async {
    ArgumentError.checkNotNull(objID, 'objID');
    ArgumentError.checkNotNull(type, 'type');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      'objID': objID,
      'type': type,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/thumbsDown',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getAVCommentaryBuyList(pageNumber, pageSize) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageNumber': pageNumber,
      r'pageSize': pageSize,
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/avcomment/buylog',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getNakeChatBuyList(pageNumber, pageSize) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageNumber': pageNumber,
      r'pageSize': pageSize,
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/nude/chat/buy/record',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getNakeChatCollectList(pageNumber, pageSize) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageNumber': pageNumber,
      r'pageSize': pageSize,
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/nude/chat/collect/record',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getDayMark() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/task/sign',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> postDayMark(String id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      'id': id,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/task/sign',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getTask() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/task',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getBox(String id, int type) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      'id': id,
      'type': type,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/task/boon',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getYouHuiJuan(int Status, int Page, int Limit) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      "status": Status,
      "page": Page,
      "limit": Limit,
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request('/backpack',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getTaskDetail(int type) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      "type": type,
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request('/task/detail',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future getLouFengDiscountCard(String id, int type) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      "productId": id,
      "productType": type,
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request('/product/coupon',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getNakeList(
      int pageNumber, int pageSize, int ageInterval, int heightInterval, int cup) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "ageInterval": ageInterval,
      "heightInterval": heightInterval,
      "cup": cup,
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request('/nude/chat',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getNakeChatPay(String id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'id': id,
    };
    final _data = {};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/nude/chat/pay/method',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getNakeChatDetail(
    String id,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'id': id,
    };
    final _data = {};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/nude/chat/detail',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> chargeGame(
    String rechargeType, [
    String productId,
    int productType,
  ]) async {
    ArgumentError.checkNotNull(rechargeType, 'rechargeType');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {
      'rechargeType': rechargeType,
      'productId': productId,
      'buyType': productType,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/mine/topay',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = RechargeUrlModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<dynamic> chargeGoldCoin(
    String rechargeType, [
    String productId,
    bool isVip,
    String cId,
  ]) async {
    ArgumentError.checkNotNull(rechargeType, 'rechargeType');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = cId == ""
        ? {
            'rechargeType': rechargeType,
            'productId': productId,
            'buyType': isVip ? 4 : 1,
          }
        : {
            'rechargeType': rechargeType,
            'productId': productId,
            'buyType': isVip ? 4 : 1,
            'cId': cId,
          };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/mine/topay',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = RechargeUrlModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<dynamic> chargeNakeChatCoin(
    String rechargeType, [
    String productId,
    int productType,
  ]) async {
    ArgumentError.checkNotNull(rechargeType, 'rechargeType');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {
      'rechargeType': rechargeType,
      'productId': productId,
      'buyType': productType,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/mine/topay',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = RechargeUrlModel.fromJson(_result.data);
    return value;
  }

  @override
  Future getVipCardAnnounce() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request('/mine/announce',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    dynamic announce = _result.data.toString();
    return announce;
  }

  @override
  @override
  Future<dynamic> getTagsDetails(
    String id, [
    int sectionSize,
    int sectionPage,
    int moduleSort,
  ]) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'pageSize': 10,
      'pageNumber': sectionPage,
      'moduleSort': moduleSort,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {};
    _data.removeWhere((k, v) => v == null);
    final result = await _dio.request('/vid/module/' + id,
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);

    // List<TagsDetailDataSections> sections = [];
    //
    // (result.data["sections"] as List).forEach((element) {
    //   TagsDetailDataSections tabsTagDetails =
    //       TagsDetailDataSections().fromJson(element);
    //   sections.add(tabsTagDetails);
    // });

    TagsVideoDataModel tagsVideoDataModel = TagsVideoDataModel.fromJson(result.data);
    return tagsVideoDataModel;
  }

  @override
  Future<SelectedTagsData> getTagsListDetail(
      int type, int model, String tag, int paymentType, int pageNumber, int pageSize) async {
    const _extra = <String, dynamic>{};
    final queryParameters = tag == ""
        ? model == 1 || model == 5
            ? <String, dynamic>{
                "type": type,
                "model": model,
                "paymentType": paymentType,
                "pageNumber": pageNumber,
                "pageSize": pageSize,
                "time": DateTimeUtil.format2utc(DateTime.now()),
              }
            : <String, dynamic>{
                "type": type,
                "model": model,
                "paymentType": paymentType,
                "pageNumber": pageNumber,
                "pageSize": pageSize,
              }
        : model == 1 || model == 5
            ? <String, dynamic>{
                "type": type,
                "model": model,
                "tag": tag,
                "paymentType": paymentType,
                "pageNumber": pageNumber,
                "pageSize": pageSize,
                "time": DateTimeUtil.format2utc(DateTime.now()),
              }
            : <String, dynamic>{
                "type": type,
                "model": model,
                "tag": tag,
                "paymentType": paymentType,
                "pageNumber": pageNumber,
                "pageSize": pageSize,
              };
    final _data = <String, dynamic>{};
    final _result = await _dio.request('/vid/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;

    SelectedTagsData selectedTagsEntity = SelectedTagsData().fromJson(_result.data);

    return selectedTagsEntity;
  }

  @override
  Future<SelectedTagsData> getSquareListDetail(
      int type, int model, int pageNumber, int pageSize, int uid) async {
    const _extra = <String, dynamic>{};
    final queryParameters = uid == 0
        ? <String, dynamic>{
            "type": type,
            "pageNumber": pageNumber,
            "pageSize": pageSize,
          }
        : <String, dynamic>{
            "type": type,
            "model": model,
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            "uid": uid,
          };
    final _data = <String, dynamic>{};
    final _result = await _dio.request('/vid/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);

    final value = _result.data;

    SelectedTagsData selectedTagsEntity = SelectedTagsData().fromJson(_result.data);

    return selectedTagsEntity;
  }

  @override
  Future<dynamic> getLiaoBaTabHistory(pageNumber, pageSize) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageNumber': pageNumber,
      r'pageSize': pageSize,
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/mine/watch_record/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getEntryVideo(activityId, type, pageNumber, pageSize) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = activityId == null
        ? <String, dynamic>{
            'type': type,
            'pageNumber': pageNumber,
            'pageSize': pageSize,
          }
        : <String, dynamic>{
            'activityId': activityId,
            'type': type,
            'pageNumber': pageNumber,
            'pageSize': pageSize,
          };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/video_activity/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getEntryVideoHistory(pageNumber, pageSize) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/video_activity/history_record',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getPublishDetail() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request('/publish/details',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getBangDanList() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request('/publish/leaderboard',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getSearchDefault() async {
    // TODO: implement getSearchDefault
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request('/search/hotVid/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getSearchDefaultBlogger() async {
    // TODO: implement getSearchDefaultBlogger
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request('/search/hotPublisher/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getPostListNew(
    pageNumber,
    pageSize,
    type,
    reqDate,
  ) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(type, 'type');
    ArgumentError.checkNotNull(reqDate, 'reqDate');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageNumber': pageNumber,
      r'pageSize': pageSize,
      r'type': type,
      r'reqDate': reqDate,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/vid/news/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    var value;
    value = CommonPostRes.fromJson(_result.data);
    return value;
  }

  @override
  Future getVideoDetail(String videoID, String sectionId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{"videoID": videoID, "sectionId": sectionId};
    final _data = <String, dynamic>{};
    final _result = await _dio.request('/vid/info',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = FilmTvVideoDetailEntity().fromJson(_result.data);
    return value;
  }

  @override
  Future<MineVideo> getRecommandVideoList(
      int pageSize, int pageNumber, String newsType, String type, int uid) async {
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageSize': pageSize,
      r'pageNumber': pageNumber,
      r'newsType': newsType,
      r'type': type,
      r'uid': uid
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/mine/collection',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = MineVideo.fromJson(_result.data);
    return value;
  }

  @override
  Future<dynamic> forward(
    vid,
  ) async {
    ArgumentError.checkNotNull(vid, 'vid');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{
      'vid': vid,
    };
    final _result = await _dio.request<Map<String, dynamic>>('/vid/forward',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    var value;
    //ResponseResult responseResultData = ResponseResult.fromJson(_result.data);
    //value = CommonPostRes.fromJson(_result.data);
    return value;
  }

  @override
  Future<dynamic> hotRecommend() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request('/search/hotVid/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    //ResponseResult responseResultData = ResponseResult.fromJson(_result.data);
    //value = CommonPostRes.fromJson(_result.data);
    return _result.data;
  }

  @override
  Future<dynamic> guessLike(
    pageNumber,
    pageSize,
  ) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageNumber': pageNumber,
      r'pageSize': pageSize,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/recommend/user/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    return _result.data;
  }

  @override
  Future<TagBean> requestTopicDetail(pageNumber, pageSize, tagID, newsType) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(tagID, 'tagID');
    ArgumentError.checkNotNull(newsType, 'newsType');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageNumber': pageNumber,
      r'pageSize': pageSize,
      r'tagID': tagID,
      r'newsType': newsType
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/tag/vid/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = TagBean.fromJson(_result.data);
    return value;
  }

  @override
  Future<dynamic> getSearchDataNew(int pageNumber, int pageSize, List<String> keyWords, String realm) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(keyWords, 'keyWords');
    ArgumentError.checkNotNull(realm, 'realm');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'pageNumber': pageNumber, 'pageSize': pageSize, 'keyWords': keyWords, 'realm': realm};
    _data.removeWhere((k, v) => v == null);

    final _result = await _dio.request<Map<String, dynamic>>('/search/list',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);

    return _result.data;
  }

  @override
  Future<dynamic> publisherTags() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {};
    _data.removeWhere((k, v) => v == null);

    final _result = await _dio.request<Map<String, dynamic>>('/search/publisher/list',
        queryParameters: queryParameters,
        options:
        RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);

    return _result.data;
  }

  @override
  Future<dynamic> getSearchVideo(pageNumber, pageSize, keyword, videoType) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(keyword, 'keyword');
    ArgumentError.checkNotNull(videoType, 'videoType');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'keyword': keyword,
      'videoType': videoType
    };
    final _data = {};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/vid/search',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    //final value = LouFengModel.fromJson(_result.data);
    return _result.data;
  }

  @override
  Future<dynamic> setTopVideo(action, videoId, type) async {
    ArgumentError.checkNotNull(action, 'action');
    ArgumentError.checkNotNull(videoId, 'videoId');
    ArgumentError.checkNotNull(type, 'type');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      'action': action,
      'videoId': videoId,
      'type': type,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/vid/work/top',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> setPromoteVideo(action, videoId, type, actionPop, popId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = action == null
        ? {
            'videoId': videoId,
            'type': type,
            'actionPop': actionPop,
            'popId': popId,
          }
        : {
            'action': action,
            'videoId': videoId,
            'type': type,
            'actionPop': actionPop,
            'popId': popId,
          };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/vid/work/top',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> rewardBlogger(uid, coins, msg) async {
    ArgumentError.checkNotNull(uid, 'uid');
    ArgumentError.checkNotNull(coins, 'coins');
    ArgumentError.checkNotNull(msg, 'msg');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'uid': uid, 'coins': coins, 'msg': msg};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/mine/reward',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<MineBillSectionModel> getMyBillList(int pageNumber, int pageSize) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageNumber': pageNumber,
      r'pageSize': pageSize,
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/mine/zqzhangdan',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = MineBillSectionModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<dynamic> getMessageList(int pageNumber, int pageSize) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };
    final _data = {};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/msg/session/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    return _result.data;
  }

  @override
  Future<dynamic> getMessageDetail(int pageNumber, int pageSize, String sessionId) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(sessionId, 'sessionId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'sessionId': sessionId,
    };
    final _data = {};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/msg/message/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    return _result.data;
  }

  @override
  Future<dynamic> sendMessage(takeUid, content) async {
    ArgumentError.checkNotNull(takeUid, 'takeUid');
    ArgumentError.checkNotNull(content, 'content');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      'takeUid': takeUid,
      'content': content,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/msg/priLetter/add',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> sendImageMessage(takeUid,imgUrl) async {
    ArgumentError.checkNotNull(takeUid, 'takeUid');
    ArgumentError.checkNotNull(imgUrl, 'imgUrl');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      'takeUid': takeUid,
      'imgUrl': imgUrl,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/msg/priLetter/add',
        queryParameters: queryParameters,
        options:
        RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getSessionId(int takeUid) async {
    ArgumentError.checkNotNull(takeUid, 'takeUid');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'takeUid': takeUid,
    };
    final _data = {};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/msg/session/get',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    return _result.data;
  }

  @override
  Future<dynamic> getDynamic(int pageNumber, int pageSize, {int dynamicMsgType}) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'dynamicMsgType': dynamicMsgType,
    };
    final _data = {};
    _data.removeWhere((k, v) => v == null);
    queryParameters.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/msg/dynamic/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    return _result.data;
  }

  @override
  Future<dynamic> getInCome(int pageNumber, int pageSize) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };
    final _data = {};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/mine/iIncomes',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    return _result.data;
  }

  @override
  Future<dynamic> getDynamicAnnounce(int pageNumber, int pageSize) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };
    final _data = {};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/annou/msg/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    return _result.data;
  }

  @override
  Future<dynamic> reportBlogger(
    content,
    imgs,
    objType,
    objUID,
    types,
    uid,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      'content': content,
      'imgs': imgs,
      'objType': objType,
      'objUID': objUID,
      'types': types,
      'uid': uid,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/mine/report',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<TaskCenterData> getMyTaskList() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/task/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    return TaskCenterData.fromJson(_result.data);
  }

  @override
  Future<List<OfficeItemData>> getOfficeList(int type) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'type': type,
    };
    final _data = {};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<dynamic>('/official/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    return OfficeItemData.toList(_result.data);
  }

  @override
  Future<MineVideo> getMyWorks(int pageSize, int pageNumber, String status) async {
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(status, 'status');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageSize': pageSize,
      r'pageNumber': pageNumber,
      r'status': status,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/mine/collection',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = MineVideo.fromJson(_result.data);
    return value;
  }

  @override
  Future<MineWorkUnit> getWorkUnitList(int page, int limit, int uid, int type) async {
    ArgumentError.checkNotNull(page, 'page');
    ArgumentError.checkNotNull(limit, 'limit');
    ArgumentError.checkNotNull(uid, 'uid');
    const _extra = <String, dynamic>{};
    final queryParameters = {
      'page': page,
      'limit': limit,
      'uid': uid,
      'type': type,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request('/video_collection/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = MineWorkUnit.fromJson(_result.data);
    return value;
  }

  ///合集视频列表
  @override
  Future<MineWorkUnitDetail> getWorkUnitVideoList(
    int page,
    int limit,
    String reqDate,
    String cid,
    int uid,
    int type,
  ) async {
    ArgumentError.checkNotNull(page, 'page');
    ArgumentError.checkNotNull(limit, 'limit');
    ArgumentError.checkNotNull(uid, 'uid');
    ArgumentError.checkNotNull(reqDate, 'reqDate');
    ArgumentError.checkNotNull(cid, 'cid');
    ArgumentError.checkNotNull(type, 'type');
    const _extra = <String, dynamic>{};
    final queryParameters = {
      'page': page,
      'limit': limit,
      'uid': uid,
      'reqDate': reqDate,
      'cid': cid,
      'type': type,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request('/video_collection/videoList',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = MineWorkUnitDetail.fromJson(_result.data);
    return value;
  }

  ///我的模块 - 新增合集
  @override
  Future postWorkUnitAdd(
    String collectionName,
    String collectionDesc,
    String coverImg,
    int price,
    int type,
  ) async {
    ArgumentError.checkNotNull(collectionName, 'collectionName');
    ArgumentError.checkNotNull(collectionDesc, 'collectionDesc');
    ArgumentError.checkNotNull(coverImg, 'coverImg');
    ArgumentError.checkNotNull(price, 'price');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      'collectionName': collectionName,
      'collectionDesc': collectionDesc,
      'coverImg': coverImg,
      'price': price,
      'type': type,
    };
    final _result = await _dio.request('/video_collection/add',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    // final value = MineVideo.fromJson(_result.data);
    return _result;
  }

  ///我的模块 - 新增合集视频
  @override
  Future postWorkUnitVideoAdd(
    String cid, // 合集id
    List<String> vIds, // 视频id
  ) async {
    ArgumentError.checkNotNull(cid, 'cid');
    ArgumentError.checkNotNull(vIds, 'vIds');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{
      'cid': cid,
      'vIds': vIds,
    };
    final _result = await _dio.request('/video_collection/addVideos',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    // final value = MineVideo.fromJson(_result.data);
    return _result;
  }

  ///我的模块 - 新增合集视频
  @override
  Future postWorkUnitVideoDelete(
    String cid, // 合集id
    List<String> vIds, // 视频id
  ) async {
    ArgumentError.checkNotNull(cid, 'cid');
    ArgumentError.checkNotNull(vIds, 'vIds');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      'cid': cid,
      'vIds': vIds,
    };
    final _result = await _dio.request('/video_collection/delVideos',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    // final value = MineVideo.fromJson(_result.data);
    return _result;
  }

  ///我的模块 - 推广作品列表
  @override
  Future getWorkUnitVideoPop(
    int page,
    int limit,
    int uid, //
    String vidTitle,
  ) async {
    ArgumentError.checkNotNull(page, 'page');
    ArgumentError.checkNotNull(limit, 'limit');
    ArgumentError.checkNotNull(uid, 'uid');
    const _extra = <String, dynamic>{};
    final queryParameters = {
      'page': page,
      'limit': limit,
      'uid': uid,
      'vidTitle': vidTitle,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request('/mine/videoPop',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = MineWorkUnitDetail.fromJson(_result.data);
    return value;
  }

  @override
  Future submitMyCertificaiton() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/mine/officialcert/submit',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    return _result;
  }

  @override
  Future<WishListData> getWishList(int pageNumber, int pageSize, [String uid]) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageSize': pageSize,
      r'pageNumber': pageNumber,
      r'uid': uid,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/desire/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = WishListData().fromJson(_result.data);
    return value;
  }

  @override
  Future<CommentListRes> getDesireCmtList(String objID, int pageNumber, int pageSize) async {
    ArgumentError.checkNotNull(objID, 'objID');
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'objID': objID,
      r'pageNumber': pageNumber,
      r'pageSize': pageSize
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/desire/cmt/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = CommentListRes.fromJson(_result.data);
    return value;
  }

  @override
  Future submitDesire(int bountyGold, List<String> images, String question) async {
    ArgumentError.checkNotNull(bountyGold, 'bountyGold');
    ArgumentError.checkNotNull(images, 'images');
    ArgumentError.checkNotNull(question, 'question');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'bountyGold': bountyGold, 'images': images, 'question': question};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/desire/add',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    return _result;
  }

  @override
  Future adoption(String commentId, String desireId) async {
    ArgumentError.checkNotNull(commentId, 'commentId');
    ArgumentError.checkNotNull(desireId, 'desireId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'commentId': commentId, 'desireId': desireId};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/desire/adoption',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    return _result;
  }

  @override
  Future<WithdrawConfig> withdrawConfig() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/withdraw/cfg',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    return WithdrawConfig.fromJson(_result.data);
  }

  @override
  Future<dynamic> getBloggerBackground(pageNumber, pageSize, [String type]) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'type': type,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };
    final _data = {};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<dynamic>('/mine/userresource/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    return _result.data;
  }

  @override
  Future<dynamic> setBackground(background, type, isDefaultSource) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      type: type == "portrait" ? background[0] : background,
      "isDefaultSource": isDefaultSource,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/mine/info',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getWordImageDetail(String videoID) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{"videoID": videoID};
    final _data = <String, dynamic>{};
    final _result = await _dio.request('/vid/info',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);

    ///final value = FilmTvVideoDetailEntity().fromJson(_result.data);
    return _result.data;
  }

  @override
  Future postNotificationSms(String mobile, [int type]) async {
    ArgumentError.checkNotNull(mobile, 'mobile');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {'mobile': mobile, 'type': type};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/notification/captcha',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    return _result;
  }

  @override
  Future postBindPhone(String mobile, String code) async {
    ArgumentError.checkNotNull(mobile, 'mobile');
    ArgumentError.checkNotNull(code, 'code');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      'mobile': mobile,
      'code': code,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/mine/mobileBind',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    return _result;
  }

  @override
  Future<CommentModel> sendWishComment(String objID, int level, String content,
      [String cid, String rid, String cmtType]) async {
    ArgumentError.checkNotNull(objID, 'objID');
    ArgumentError.checkNotNull(level, 'level');
    ArgumentError.checkNotNull(content, 'content');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      'objID': objID,
      'level': level,
      'content': content,
      'cid': cid,
      'rid': rid,
      'cmtType': cmtType,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/comment/sendV2',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = CommentModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<ReplyModel> sendWishReply(String objID, int level, String content,
      [String cid, String rid, String cmtType]) async {
    ArgumentError.checkNotNull(objID, 'objID');
    ArgumentError.checkNotNull(level, 'level');
    ArgumentError.checkNotNull(content, 'content');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {
      'objID': objID,
      'level': level,
      'content': content,
      'cid': cid,
      'rid': rid,
      'cmtType': cmtType,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/comment/sendV2',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = ReplyModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<FansObj> getBloggerFansList(pageNumber, pageSize, uid) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageNumber': pageNumber, r'pageSize': pageSize, r'uid': uid};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/follow/fans/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = FansObj.fromJson(_result.data);
    return value;
  }

  @override
  Future<dynamic> getRewardAvatar(pageNumber, pageSize, uid) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'pageNumber': pageNumber, r'pageSize': pageSize, r'uid': uid};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/mine/reward/log',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = FansObj.fromJson(_result.data);
    return _result.data;
  }

  @override
  Future getOfficialCertStatus() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/mine/officialcert/get',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);

    return UserCertificationData.fromJson(_result.data);
  }

  @override
  Future postBuyOfficicalCert(String productID, int productType) async {
    ArgumentError.checkNotNull(productID, 'productID');
    ArgumentError.checkNotNull(productType, 'productType');

    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};

    final _data = <String, dynamic>{'productID': productID, 'productType': productType};

    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/product/buy',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    return _result.data;
  }

  @override
  Future wishDetailReq(String id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'id': id};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/desire/info',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);

    return _result.data;
  }

  @override
  Future getCommunityRecommentList(int pageNumber, int pageSize, String tag, String reqDate) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(tag, 'tag');
    ArgumentError.checkNotNull(reqDate, 'reqDate');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageNumber': pageNumber,
      r'pageSize': pageSize,
      r'tag': tag,
      r'reqDate': reqDate,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/vid/community/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    var value;
    value = CommonPostRes.fromJson(_result.data);
    return value;
  }

  Future communityHotlist(int pageNumber, int pageSize, String newsType, String reqDate) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(newsType, 'newsType');
    ArgumentError.checkNotNull(reqDate, 'reqDate');
    const _extra = <String, dynamic>{};
    final queryParameters = {
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'newsType': newsType,
      'reqDate': reqDate,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/vid/community/hot/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    var value = CommonPostRes.fromJson(_result.data);
    return value;
  }

  @override
  Future getCommunityRecommentListHotVideo(
      int pageNumber, int pageSize, String tag, String reqDate, bool isPopping) async {
    ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    ArgumentError.checkNotNull(pageSize, 'pageSize');
    ArgumentError.checkNotNull(tag, 'tag');
    ArgumentError.checkNotNull(reqDate, 'reqDate');
    const _extra = <String, dynamic>{};
    final queryParameters = {
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'tag': tag,
      'reqDate': reqDate,
      'isPopping': true,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/vid/community/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    var value;
    value = CommonPostRes.fromJson(_result.data);
    return value;
  }

  @override
  Future getRecommendChangeFuncList() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>('/recommend/user/rand/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);

    List<GuessLikeDataList> dataList = [];
    List result = _result.data;
    if ((result ?? []).isNotEmpty) {
      result.forEach((element) {
        GuessLikeDataList dataItem = GuessLikeDataList().fromJson(element);
        dataList.add(dataItem);
      });
    }
    return dataList ?? [];
  }

  @override
  Future getRecommendChangeFuncListDetail() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>('/recommend/user/rand/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);

    /*List<GuessLikeDataList> dataList = [];
    List result = _result.data;
    if ((result ?? []).isNotEmpty) {
      result.forEach((element) {
        GuessLikeDataList dataItem = GuessLikeDataList().fromJson(element);
        dataList.add(dataItem);
      });
    }*/
    return _result.data;
  }

  @override
  Future delMsgSession(String sessionId) async {
    ArgumentError.checkNotNull(sessionId, 'sessionId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      'sessionId': sessionId,
    };

    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/msg/session/del',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    return _result.data;
  }

  @override
  Future<dynamic> getExchangeMarQuee() async {
    //ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    //ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      //r'pageNumber': pageNumber,
      // r'pageSize': pageSize
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<dynamic>('/modules/exchange_announce',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    //final value = AnnounceLiaoBaData().fromJson(_result.data);
    //ExchangeMarquee.fromJson(dynamic json);

    return _result.data;
  }

  @override
  Future<dynamic> getPromoteConfig() async {
    //ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    //ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      //r'pageNumber': pageNumber,
      // r'pageSize': pageSize
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<dynamic>('/vid/pop_config/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    //final value = AnnounceLiaoBaData().fromJson(_result.data);
    //ExchangeMarquee.fromJson(dynamic json);

    return _result.data;
  }

  @override
  Future<dynamic> getExample() async {
    //ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    //ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      //r'pageNumber': pageNumber,
      // r'pageSize': pageSize
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<dynamic>('/vid/example_config/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    //final value = AnnounceLiaoBaData().fromJson(_result.data);
    //ExchangeMarquee.fromJson(dynamic json);

    return _result.data;
  }

  @override
  Future<dynamic> getTickets(
    int pageNumber,
    int pageSize,
    int type,
  ) async {
    //ArgumentError.checkNotNull(pageNumber, 'pageNumber');
    //ArgumentError.checkNotNull(pageSize, 'pageSize');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pageNumber': pageNumber,
      r'pageSize': pageSize,
      r'type': type,
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<dynamic>('/coupon/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);

    //final value = AnnounceLiaoBaData().fromJson(_result.data);
    //ExchangeMarquee.fromJson(dynamic json);

    return _result.data;
  }

  /// 获取AI脱衣记录列表
  @GET("/ai/undress/list") // 1、进行中 2、生成成功 3、生成失败
  Future<AiRecordEntity> getAiRecordList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    @Query("type") int status,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'status': status,
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<dynamic>('/ai/undress/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = AiRecordEntity.fromJson(_result.data);
    //ExchangeMarquee.fromJson(dynamic json);
    return value;
  }

  /// 获取AI视频换脸记录列表
  @GET("/ai/changeface/list") // 1、进行中 2、生成成功 3、生成失败
  Future<AiRecordEntity> getAiFaceRecordList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    @Query("type") int status,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'status': status,
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<dynamic>('/ai/changeface/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = AiRecordEntity.fromJson(_result.data);
    //ExchangeMarquee.fromJson(dynamic json);
    return value;
  }

  /// 获取AI图片换脸记录列表
  @GET("/ai/img/list") // 1、进行中 2、生成成功 3、生成失败
  Future<AiRecordEntity> getAiFacePictureRecordList(
      @Query("pageNumber") int pageNumber,
      @Query("pageSize") int pageSize,
      @Query("type") int status,
      ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'status': status,
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<dynamic>('/ai/img/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = AiRecordEntity.fromJson(_result.data);
    //ExchangeMarquee.fromJson(dynamic json);
    return value;
  }

  //生成AI脱衣记录
  @POST("/ai/undress/generate")
  Future<dynamic> aiGenerate(
    @Query("originPic") List<String> originPics,
  ) async {
    ArgumentError.checkNotNull(originPics, 'originPic');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      'originPic': originPics,
    };
    final _result = await _dio.request('/ai/undress/generate',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getTradeTopicList() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    List<TradeTopic> list = [];
    final _result = await _dio.request('/trade/cate/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    if (_result != null && _result.data != null) {
      _result.data.forEach((element) {
        if (element != null) {
          var tradeTopic = TradeTopic.fromJson(element);
          list.add(tradeTopic);
        }
      });
    }
    return list;
  }

  @override
  Future<dynamic> getTradeList(pageNumber, pageSize, typeID) async {
    const _extra = <String, dynamic>{};
    var queryParameters;
    if ("全部" == typeID) {
      queryParameters = <String, dynamic>{
        "pageNumber": pageNumber,
        "pageSize": pageSize,
      };
    } else {
      queryParameters = <String, dynamic>{
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "typeID": typeID,
      };
    }
    final _data = <String, dynamic>{};
    List<TradeTopic> list = [];
    final _result = await _dio.request('/trade/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    TradeList tradeList = TradeList.fromJson(_result.data);
    return tradeList;
  }

  @override
  Future<dynamic> getMyTradeList(pageNumber, pageSize, verifyStatus) async {
    const _extra = <String, dynamic>{};
    var queryParameters;
    if ("0" == verifyStatus) {
      queryParameters = <String, dynamic>{
        "pageNumber": pageNumber,
        "pageSize": pageSize,
      };
    } else {
      queryParameters = <String, dynamic>{
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "tradeStatus": verifyStatus,
      };
    }
    final _data = <String, dynamic>{};
    List<TradeTopic> list = [];
    final _result = await _dio.request('/trade/mine',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    TradeList tradeList = TradeList.fromJson(_result.data);
    return tradeList;
  }

  @override
  Future<dynamic> orderTrade(tradeId, leaveMsg) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      // "id": tradeId,
      // "leaveMsg": leaveMsg
    };
    final _data = <String, dynamic>{"id": tradeId, "leaveMsg": leaveMsg};
    final _result = await _dio.request('/trade/order',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    return _result.data;
  }

  @override
  Future<dynamic> cancelTrade(tradeId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      "id": tradeId,
    };
    final _data = <String, dynamic>{
      "id": tradeId,
    };
    final _result = await _dio.request('/trade/cancel',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    return _result.data;
  }

  @override
  Future<dynamic> finishTrade(tradeId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      "id": tradeId,
    };
    final _data = <String, dynamic>{
      "id": tradeId,
    };
    final _result = await _dio.request('/trade/finish',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    return _result.data;
  }

  //生成AI视频换脸记录
  @POST("/ai/changeface/generate")
  Future<dynamic> aiFaceGenerate(@Query("picture") List<String> picture, @Query("vidModId") String vidModId,
      {@Query("discount") List<String> discount}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'picture': picture, 'vidModId': vidModId, 'discount': discount};

    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/ai/changeface/generate',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  //生成AI图片换脸记录
  @POST("/ai/img/generate")
  Future<dynamic> aiFacegenerateByPicture(@Query("originPic") String originPic, @Query("mId") String mId,
      {@Query("discount") List<String> discount}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'originPic': originPic, 'mId': mId};

    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/ai/img/generate',
        queryParameters: queryParameters,
        options:
        RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }


  @GET("/ai/changeface/mod/list")
  Future<dynamic> getAIFaceModel(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  ) async {
    const _extra = <String, dynamic>{};

    final queryParameters = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };

    final _data = <String, dynamic>{};

    final _result = await _dio.request<dynamic>('/ai/changeface/mod/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);

    final value = _result.data;

    return value;
  }


  //AI模版列表
  @GET("/ai/mod/list")
  Future<dynamic> getAIModelList(
      ) async {
    const _extra = <String, dynamic>{};

    final queryParameters = <String, dynamic>{
    };

    final _data = <String, dynamic>{};

    final _result = await _dio.request<dynamic>('/ai/mod/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);

    final value = _result.data;

    return value;
  }


  //AI模版列表
  @GET("/ai/changeface/mod/getById")
  Future<dynamic> getAIModelDetail(
      ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
    };

    final _data = <String, dynamic>{};
    final _result = await _dio.request<dynamic>('/ai/changeface/mod/getById',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);

    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> deleteAiBill(
    String id,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      'id': id,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/ai/undress/hide',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> deleteAiFaceBill(
    String id,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      'id': id,
    };
    //_data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/ai/changeface/hide',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }


  @override
  Future<dynamic> deleteAiImageFaceBill(
      String id,
      ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      'id': id,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/ai/img/hide',
        queryParameters: queryParameters,
        options:
        RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<TopListModel> getTopList(String rankType, {String seriesID}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = {"rankType": rankType, "seriesID": seriesID};
    final _data = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/top/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = TopListModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<TopListUPModel> getHMUpList({int count = 20}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = {"count": count};
    final _data = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/top/fans/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = TopListUPModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<TopListCircleModel> getTopSeriesList(int pageNumber, int pageSize) async {
    const _extra = <String, dynamic>{};
    final queryParameters = {"pageNumber": pageNumber, "pageSize": pageSize};
    final _data = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/top/series/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = TopListCircleModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<dynamic> freezeAmount() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request('/mine/freeze',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = FreezeAmount.fromJson(_result.data);
    return value;
  }

  //获取投票接口
  @override
  Future<dynamic> voteList() async {
    const _extra = <String, dynamic>{};
    var queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    List<VoteItemModel> voteList = [];
    final _result = await _dio.request('/vote/list',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    if (_result != null && _result.data != null && (_result.data is List)) {
      _result.data.forEach((element) {
        if (element != null) {
          var voteItemModel = VoteItemModel.fromJson(element);
          voteList.add(voteItemModel);
        }
      });
    }
    return voteList;
  }

  //用户投票
  @override
  Future<dynamic> voteSubmit(List<String> voteIDs, String optionID) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'optionID': voteIDs, 'voteID': optionID};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/vote/submit',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> topInfo(String vid) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'vid': vid,
    };
    final _data = {
      'vid': vid,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/top/vid/topInfo',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    var rankInfoModel = null;
    if (_result != null && _result.data != null) {
      rankInfoModel = RankInfoModel.fromJson(_result.data);
    }
    return rankInfoModel;
  }

  @override
  Future<dynamic> tradeInfo(String tradeId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'id': tradeId,
    };
    final _data = {
      'id': tradeId,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/trade/info',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    TradeItemModel tradeItemModel;
    if (_result != null && _result.data != null) {
      tradeItemModel = TradeItemModel.fromJson(_result.data);
    }
    return tradeItemModel;
  }

  @override
  Future<dynamic> collectBatch(List<String> ids, String type, bool isCollect) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'objIDs': ids,
      'type': type,
      'isCollect': isCollect,
    };
    final _data = {
      'objIDs': ids,
      'type': type,
      'isCollect': isCollect,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/mine/collect/batch',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);

    return _result.data;
  }

  @override
  Future<dynamic> collectionDel(String cId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'cId': cId,
    };
    final _data = {
      'cId': cId,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/video_collection/del',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);

    return _result.data;
  }

  //获取小红点消息
  @override
  Future<dynamic> checkMessageTip() async {
    const _extra = <String, dynamic>{};
    var queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request('/ping/checkMessageTip',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    NewMessageTip newMessageTip;
    if (_result != null && _result.data != null) {
      newMessageTip = NewMessageTip.fromJson(_result.data);
    }
    return newMessageTip;
  }

  //获取小红点消息
  @override
  Future<dynamic> exchangeIntegral(@Field() String id) async {
    const _extra = <String, dynamic>{};
    var queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{"id": id};
    final _result = await _dio.request(
      '/product/exchangeIntegral',
      queryParameters: queryParameters,
      options: RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
      data: _data,
    );
    return _result.data;
  }

  @override
  Future<dynamic> doTask(String taskId, int type) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'taskId': taskId, 'type': type};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/task/do',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> receiveTask(String taskId, int type) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'taskId': taskId, 'type': type};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/task/receive',
        queryParameters: queryParameters,
        options:
            RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }


  @override
  Future<dynamic> useDownLoadCount() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {};
    final _result = await _dio.request('/mine/download/use',
        queryParameters: queryParameters,
        options:
        RequestOptions(method: 'POST', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getAwVip() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {};
    final _result = await _dio.request('/product/getAwVip',
        queryParameters: queryParameters,
        options:
        RequestOptions(method: 'GET', headers: <String, dynamic>{}, extra: _extra, baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    Config.anWangVipCard = AnWangVipCard.fromJson(value);
    return value;
  }


  @override
  Future<dynamic> happyList() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/recreation/list',
        queryParameters: queryParameters,
        options: Options(
          method: 'GET',
          headers: <String, dynamic>{},
          extra: _extra,
        ),
        data: _data);
    final value = _result.data;
    return HappyModel.fromJson(value);
  }




  //娱乐模块点击统计事件接口
  // id  点击id
  // type  广告类型. app 或 adv
  @override
  Future<dynamic> recreationList(String id,String type) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      "id":id,
      "type":type,
      "sysType":"android",
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/recreation/click',
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ),
        data: _data);
    final value = _result.data;
    return HappyModel.fromJson(value);
  }

  Future<dynamic>  getSystemMessage(int pageNumber, int pageSize) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      "pageNumber": pageNumber,
      "pageSize": pageSize,
    };
    final _data = {};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request('/msg/system',
        queryParameters: queryParameters,
        options: Options(
          method: 'GET',
          headers: <String, dynamic>{},
          extra: _extra,
        ),
        data: _data);
    final value = _result.data;
    return value;
  }

}
