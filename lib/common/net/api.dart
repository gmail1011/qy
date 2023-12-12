import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/net2/http_signature_interceptor.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/base_response.dart';
import 'package:flutter_base/net/dio_cli.dart';
import 'package:flutter_base/utils/log.dart';
import './code.dart';
import './interceptors/header_interceptor.dart';
import './interceptors/log_interceptor.dart';
import './interceptors/response_interceptor.dart';

///http请求
class HttpManager {
  static final HttpManager _instance = HttpManager._internal();

  static const String GET = "get";

  static const String POST = "post";

  static Dio _dioInstance; // 使用默认配置

  var networkResult;

  HttpManager._internal() {
    _dioInstance = createDio(
        options: BaseOptions(
            connectTimeout: 15 * 1000,
            validateStatus: (int status) => status < 600));
    // _dioInstance.transformer = JSONTransformer();
    _dioInstance.interceptors.add(HeaderInterceptors());
//    日志拦截器
    _dioInstance.interceptors.add(LogsInterceptors());

    _dioInstance.interceptors.add(ResponseInterceptors());

    //监听网络状态
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      networkResult = result;
    });
  }

  factory HttpManager() => _instance;

  ///发起GET网络请求
  Future<BaseResponse> get<T>(String url,
      {Map<String, dynamic> params,
      bool needHead = true,
      CancelToken cancelToken}) {
    return _req(url,
        params: params,
        method: GET,
        needHead: needHead,
        cancelToken: cancelToken);
  }

  ///发起post网络请求
  Future<BaseResponse> post<T>(url,
      {Map<String, dynamic> params,
      Future callback,
      needHead = true,
      Future errorCallback}) {
    return _req(url, params: params, method: POST, needHead: needHead);
  }

  /// Post请求
  /// url: api地址
  ///[callback] 数据正确时回调
  ///[errorCallback]数据异常时回
  ///[method]请求方法类型，默认使用get
  Future<BaseResponse> _req(String url,
      {Map<String, dynamic> params,
      String method = GET,
      bool needHead,
      CancelToken cancelToken}) async {
    Uri baseUri;
    if (Address.baseApiPath != null && Address.baseApiPath != "") {
      baseUri = Uri.tryParse(Address.baseApiPath);
      assert(baseUri != null && baseUri.host != ""); //如果设置了 一定有值
    }
    Uri currUri = Uri.tryParse(url);
    assert(currUri != null); //一定有值
    Uri targetUri;
    if (currUri.host == "") {
      assert(baseUri.host != ""); //currUri没有host， base里面必须要有host
      targetUri = Uri(
          scheme: baseUri.scheme,
          host: baseUri.host,
          port: baseUri.port,
          path: baseUri.path + currUri.path);
    } else {
      targetUri = currUri;
    }
    //header配置
    Map<String, dynamic> header = {};
    header["User-Agent"] = await netManager.userAgent();
    header['x-api-key'] = await SignatureInterceptor.sign(targetUri.path);
    if (needHead) {
      header["Authorization"] = await netManager.getToken();
    }
    Response response;
    var option = Options(method: method);
    //option.responseType = ResponseType.plain;
    option.headers = header;
    try {
      if (method == POST) {
        response = await _dioInstance.requestUri(targetUri,
            data: params, options: option, cancelToken: cancelToken);
      } else if (method == GET) {
        ///组装参数
        Map<String, dynamic> queryParams = {};
        var oldParams = targetUri.queryParameters;
        if (oldParams != null) queryParams.addAll(oldParams);
        if (params != null) queryParams.addAll(params);
        queryParams.forEach((key, value) {
          queryParams[key] = "${value == null ? "" : value.toString()}";
        });

        if (queryParams != null && queryParams.isNotEmpty) {
          targetUri = targetUri.replace(queryParameters: queryParams);
        }
        response = await _dioInstance.request<BaseResponse>(
            targetUri.toString(),
            options: option,
            cancelToken: cancelToken);
      }
    } on DioError catch (e) {
      l.e("http_log", "net DioError url:$url in err:$e", saveFile: true);
      // showToast(msg: "DioError url:$url in err:$e");
      return _resultError(e);
    } catch (e) {
      l.e("http_log", "net unknow error url:$url in err:$e", saveFile: true);
      // showToast(msg: "unknow error url:$url in err:$e");
      return _resultError(e);
    }
    //http层请求成功
    return response.data;
  }

  ///错误处理
  BaseResponse _resultError(DioError e) {
    BaseResponse response;
    if (e.type == DioErrorType.CONNECT_TIMEOUT ||
        e.type == DioErrorType.RECEIVE_TIMEOUT ||
        e.type == DioErrorType.SEND_TIMEOUT) {
      //连接超时异常
      response = BaseResponse(Code.NETWORK_TIMEOUT, Lang.BAD_NETWORK, null);
    } else if (e.type == DioErrorType.CANCEL) {
      //取消请求异常
      response = BaseResponse(Code.LOCAL_CANCEL_REQUEST, "请求已取消", null);
    } else {
      //网络服务或服务器异常
      response = BaseResponse(Code.NETWORK_ERROR, Lang.SERVER_ERROR, null);
    }
    return response;
  }

  ///下载地址
  download(String url, ProgressCallback progressCallback) async {
    await _dioInstance.download(url, "", onReceiveProgress: progressCallback);
  }
}
