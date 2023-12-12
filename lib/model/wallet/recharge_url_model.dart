/// oid : "ALP2019112317410596812657"
/// payUrl : "https://estc.ttqhdz.com/pay_cjg.html?oid=ALP2019112317410596812657&sign=7a9ba55119b426e3a114062fac70e010&t=1574502065978&a=https%3A%2F%2Ftlli.tzhljsj.com"
/// sign : "93757dea29cb02e481c3fd5f81aec62b"

class RechargeUrlModel {
  String oid;
  String payUrl;
  String sign;

  /// url打开外部支付链接;sdk/打开可以sdk
  String mode;

  static RechargeUrlModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    RechargeUrlModel bean = RechargeUrlModel();
    bean.oid = map['oid'];
    bean.payUrl = map['payUrl'];
    bean.sign = map['sign'];
    bean.mode = map['mode'];
    return bean;
  }

  Map toJson() => {
        "oid": oid,
        "payUrl": payUrl,
        "sign": sign,
        "mode": mode,
      };
}
