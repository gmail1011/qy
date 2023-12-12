import 'dart:io';
import 'package:chat_online_customers/chat_widget/chat_core/network/connection/socket_manager.dart';
import 'package:dio/dio.dart';

/*
 * 封装 restful 请求
 *
 * GET、POST、DELETE、PATCH
 * 主要作用为统一处理相关事务：
 *  - 统一处理请求前缀；
 *  - 统一打印请求信息；
 *  - 统一打印响应信息；
 *  - 统一打印报错信息；
 */
class DioUtils {
  /// global dio object
  static Dio dio;

  /// default options
  static const int CONNECT_TIMEOUT = 10000;
  static const int RECEIVE_TIMEOUT = 3000;

  /// http request methods
  static const String GET = 'get';
  static const String POST = 'post';
  static const String PUT = 'put';
  static const String PATCH = 'patch';
  static const String DELETE = 'delete';

  /// 创建 dio 实例对象
  static Dio createInstance() {
    if (dio == null) {
      /// 全局属性：请求前缀、连接超时时间、响应超时时间
      var options = BaseOptions(
          connectTimeout: 150000,
          receiveTimeout: 150000,
          responseType: ResponseType.json,
          validateStatus: (status) {
            // 不使用http状态码判断状态，使用AdapterInterceptor来处理（适用于标准REST风格）
            return true;
          },
          baseUrl: SocketManager().model.baseUrl,
          headers: httpHeaders);

      dio = new Dio(options);
    }

    return dio;
  }

  /// 清空 dio 对象
  static clear() {
    dio = null;
  }

  ///Get请求
  static void getHttp<T>(
    String url, {
    parameters,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    ///定义请求参数
    parameters = parameters ?? {};
    //参数处理
    parameters.forEach((key, value) {
      if (url.indexOf(key) != -1) {
        url = url.replaceAll(':$key', value.toString());
      }
    });

    try {
      Response response;
      Dio dio = createInstance();
      response = await dio.get(url, queryParameters: parameters);
      var responseData = response.data;
      print('getHttp响应数据：' + responseData.toString());
      if (responseData['erroCode'] == 2000) {
        if (onSuccess != null) {
          onSuccess(responseData['result']);
        }
      } else {
        throw Exception('erroMsg:${responseData['erroMsg']}');
      }
      print('getHttp响应数据：' + response.toString());
    } catch (e) {
      print('-getHttp--请求出错：' + e.toString());
      onError(e.toString());
    }
  }

  ///Post请求
  static void postHttp<T>(
    String url, {
    parameters,
    Function(T) onSuccess,
    Function(String error) onError,
  }) async {
    ///定义请求参数
    parameters = parameters ?? {};
    //参数处理
    parameters.forEach((key, value) {
      if (url.indexOf(key) != -1) {
        url = url.replaceAll(':$key', value.toString());
      }
    });

    try {
      Response response;
      Dio dio = createInstance();

      response = await dio.post(url, data: parameters);
      var responseData = response.data;
      print('postHttp响应数据：'+url + responseData.toString());
      if (responseData != null) {
        // if (responseData['code'] == 200) {
        //   if (onSuccess != null) {
        //     onSuccess(responseData);
        //   }
        // } else {
        //   throw Exception('erroMsg:${responseData['erroMsg']}');
        // }
        onSuccess(responseData);
      }else{
        onError(response.toString());
      }

      print('postHttp响应数据：' + response.toString());
    } catch (e) {
      print('postHttp请求出错：' + e.toString());
      onError(e.toString());
    }
  }

  /// request Get、Post 请求
  //url 请求链接
  //parameters 请求参数
  //method 请求方式
  //onSuccess 成功回调
  //onError 失败回调
  static void requestHttp<T>(String url,
      {parameters,
      method,
      Function(T t) onSuccess,
      Function(String error) onError}) async {
    parameters = parameters ?? {};
    method = method ?? 'GET';
    print("requestHttp-----------------$url");
    if (method == DioUtils.GET) {
      getHttp(
        url,
        parameters: parameters,
        onSuccess: (data) {
          onSuccess(data);
        },
        onError: (error) {
          onError(error);
        },
      );
    } else if (method == DioUtils.POST) {
      postHttp(
        url,
        parameters: parameters,
        onSuccess: (data) {
          onSuccess(data);
        },
        onError: (error) {
          onError(error);
        },
      );
    }
  }

  //图片上传
  static void upFileHttp<T>(String url,
      {path,
      filename,
      method,
      appId,
      authorization,
      contentType,
      Function(T t) onSuccess,
      Function(String error) onError,
      Function() onCatch,
      Function() onFinally}) async {
    method = method ?? 'POST';
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        path,
        filename: filename,
      )
    });
    Dio dio = createInstance();
    dio.options.headers[HttpHeaders.contentTypeHeader] = contentType;
    dio.options.headers["Authorization"] = authorization;
    //"${Api.baseUrl}/file/$name";
    String uri = "$url/file/$filename";
    try {
      var response = await dio.post(uri, data: formData,
          onSendProgress: (int sent, int total) {
        // double t = sent / total;
      });

      if (response.data["data"] != null) {
        onSuccess(response.data['data']);
      } else {
        print("图片上传失败");
        onError(response.toString());
      }
    } catch (e) {
      onCatch();
      throw UnimplementedError(e.toString());
    } finally {
      onFinally();
    }
  }
}

/// 自定义Header
Map<String, dynamic> httpHeaders = {
  'Accept': 'application/json,*/*',
  'Content-Type': 'application/json',
};
