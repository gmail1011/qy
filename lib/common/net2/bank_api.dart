// import 'package:app/pojo/bank_card_info.dart';
// import 'package:dio/dio.dart';
// import 'package:retrofit/retrofit.dart';

// part 'bank_api.g.dart';

// @RestApi(baseUrl: "https://ccdcapi.alipay.com")
// abstract class BankApi {
//   factory BankApi(Dio dio, {String baseUrl}) = _BankApi;

//   /// 获取银行卡信息
//   @GET("/validateAndCacheCardInfo.json")
//   Future<BankCardInfo> getBankCardInfo(@Query("cardNo") String cardNo,
//       [@Query("cardBinCheck") bool cardBinCheck = true]);
// }
