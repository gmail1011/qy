

///支付列表展示
class PayType {

  String type;

  String typeName;

  String channel;
  ///支付类型图片
  String localImgPath;

  bool isOfficial = false;

  int payMethod;

  String increaseAmount;//增加的优惠额度

  String incTax;//按比率增加额外优惠额 0-1之间 ,如果 incrAmount 与 incrTax 同时存在 以 incrAmount 为准
}