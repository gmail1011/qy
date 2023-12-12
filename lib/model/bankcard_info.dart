import 'package:flutter_app/model/bank_card_model.dart';

class BankcardInfo {


  static final BankcardInfo _instance = BankcardInfo._internal();

  factory BankcardInfo() => _instance;

  BankcardInfo._internal();

  var bankLogoId = [
    'assets/images/bank_card_logo/cmb.png',
    'assets/images/bank_card_logo/boc.png',
    'assets/images/bank_card_logo/abc.png',
    'assets/images/bank_card_logo/comm.png',
    'assets/images/bank_card_logo/ccb.png',
    'assets/images/bank_card_logo/cmbc.png',
    'assets/images/bank_card_logo/citic.png',
    'assets/images/bank_card_logo/ceb.png',
    'assets/images/bank_card_logo/hxbank.png',
    'assets/images/bank_card_logo/icbc.png',
    'assets/images/bank_card_logo/cib.png',
    'assets/images/bank_card_logo/cdb.png'
  ];
  var bankName = ['招商银行', '中国银行', '农业银行', '交通银行', '建设银行', '民生银行', '中信银行', '光大银行', '华夏银行', '工商银行', '兴业银行', '国家开发银行'];
  var bankCardId = ['CMB', 'BOC', 'ABC', 'COMM', 'CCB', 'CMBC', 'CITIC', 'CEB', 'HXBANK', 'ICBC', 'CIB', 'CDB'];

  BankCardModel getBankInfoMap(String bankId) {
    Map<String, dynamic> map = Map();
    for (int i = 0; i < bankCardId.length; i++) {
      BankCardModel model = new BankCardModel(bankLogoId[i], bankName[i], bankCardId[i]);
      map[bankCardId[i]] = model;
    }
    bool contains = map.containsKey(bankId);
    if (contains) {
      return map[bankId];
    }
    return null;
  }

  ///支付宝支持银行
  String getBankName(String bankId) {
    Map<String, String> map = Map();
    map["SRCB"] = "深圳农村商业银行";
    map["BGB"] = "广西北部湾银行";
    map["SHRCB"] = "上海农村商业银行";
    map["BJBANK"] = "北京银行";
    map["WHCCB"] = "威海市商业银行";
    map["BOZK"] = "周口银行";
    map["KORLABANK"] = "库尔勒市商业银行";
    map["SPABANK"] = "平安银行";
    map["SDEB"] = "顺德农商银行";
    map["HURCB"] = "湖北省农村信用社";
    map["WRCB"] = "无锡农村商业银行";
    map["BOCY"] = "朝阳银行";
    map["CZBANK"] = "浙商银行";
    map["HDBANK"] = "邯郸银行";
    map["BOC"] = "中国银行";
    map["BOD"] = "东莞银行";
    map["CCB"] = "中国建设银行";
    map["ZYCBANK"] = "遵义市商业银行";
    map["SXCB"] = "绍兴银行";
    map["GZRCU"] = "贵州省农村信用社";
    map["ZJKCCB"] = "张家口市商业银行";
    map["BOJZ"] = "锦州银行";
    map["BOP"] = "平顶山银行";
    map["HKB"] = "汉口银行";
    map["SPDB"] = "上海浦东发展银行";
    map["NXRCU"] = "宁夏黄河农村商业银行";
    map["NYNB"] = "广东南粤银行";
    map["GRCB"] = "广州农商银行";
    map["BOSZ"] = "苏州银行";
    map["HZCB"] = "杭州银行";
    map["HSBK"] = "衡水银行";
    map["HBC"] = "湖北银行";
    map["JXBANK"] = "嘉兴银行";
    map["HRXJB"] = "华融湘江银行";
    map["BODD"] = "丹东银行";
    map["AYCB"] = "安阳银行";
    map["EGBANK"] = "恒丰银行";
    map["CDB"] = "国家开发银行";
    map["TCRCB"] = "江苏太仓农村商业银行";
    map["NJCB"] = "南京银行";
    map["ZZBANK"] = "郑州银行";
    map["DYCB"] = "德阳商业银行";
    map["YBCCB"] = "宜宾市商业银行";
    map["SCRCU"] = "四川省农村信用";
    map["KLB"] = "昆仑银行";
    map["LSBANK"] = "莱商银行";
    map["YDRCB"] = "尧都农商行";
    map["CCQTGB"] = "重庆三峡银行";
    map["FDB"] = "富滇银行";
    map["JSRCU"] = "江苏省农村信用联合社";
    map["JNBANK"] = "济宁银行";
    map["CMB"] = "招商银行";
    map["JINCHB"] = "晋城银行JCBANK";
    map["FXCB"] = "阜新银行";
    map["WHRCB"] = "武汉农村商业银行";
    map["HBYCBANK"] = "湖北银行宜昌分行";
    map["TZCB"] = "台州银行";
    map["TACCB"] = "泰安市商业银行";
    map["XCYH"] = "许昌银行";
    map["CEB"] = "中国光大银行";
    map["NXBANK"] = "宁夏银行";
    map["HSBANK"] = "徽商银行";
    map["JJBANK"] = "九江银行";
    map["NHQS"] = "农信银清算中心";
    map["MTBANK"] = "浙江民泰商业银行";
    map["LANGFB"] = "廊坊银行";
    map["ASCB"] = "鞍山银行";
    map["KSRB"] = "昆山农村商业银行";
    map["YXCCB"] = "玉溪市商业银行";
    map["DLB"] = "大连银行";
    map["DRCBCL"] = "东莞农村商业银行";
    map["GCB"] = "广州银行";
    map["NBBANK"] = "宁波银行";
    map["BOYK"] = "营口银行";
    map["SXRCCU"] = "陕西信合";
    map["GLBANK"] = "桂林银行";
    map["BOQH"] = "青海银行";
    map["CDRCB"] = "成都农商银行";
    map["QDCCB"] = "青岛银行";
    map["HKBEA"] = "东亚银行";
    map["HBHSBANK"] = "湖北银行黄石分行";
    map["WZCB"] = "温州银行";
    map["TRCB"] = "天津农商银行";
    map["QLBANK"] = "齐鲁银行";
    map["GDRCC"] = "广东省农村信用社联合社";
    map["ZJTLCB"] = "浙江泰隆商业银行";
    map["GZB"] = "赣州银行";
    map["GYCB"] = "贵阳市商业银行";
    map["CQBANK"] = "重庆银行";
    map["DAQINGB"] = "龙江银行";
    map["CGNB"] = "南充市商业银行";
    map["SCCB"] = "三门峡银行";
    map["CSRCB"] = "常熟农村商业银行";
    map["SHBANK"] = "上海银行";
    map["JLBANK"] = "吉林银行";
    map["CZRCB"] = "常州农村信用联社";
    map["BANKWF"] = "潍坊银行";
    map["ZRCBANK"] = "张家港农村商业银行";
    map["FJHXBC"] = "福建海峡银行";
    map["ZJNX"] = "浙江省农村信用社联合社";
    map["LZYH"] = "兰州银行";
    map["JSB"] = "晋商银行";
    map["BOHAIB"] = "渤海银行";
    map["CZCB"] = "浙江稠州商业银行";
    map["YQCCB"] = "阳泉银行";
    map["SJBANK"] = "盛京银行";
    map["XABANK"] = "西安银行";
    map["BSB"] = "包商银行";
    map["JSBANK"] = "江苏银行";
    map["FSCB"] = "抚顺银行";
    map["HNRCU"] = "河南省农村信用";
    map["COMM"] = "交通银行";
    map["CITIC"] = "中信银行";
    map["XTB"] = "邢台银行";
    map["HXBANK"] = "华夏银行";
    map["HNRCC"] = "湖南省农村信用社";
    map["DYCCB"] = "东营市商业银行";
    map["ORBANK"] = "鄂尔多斯银行";
    map["BJRCB"] = "北京农村商业银行";
    map["XYBANK"] = "信阳银行";
    map["ZGCCB"] = "自贡市商业银行";
    map["CDCB"] = "成都银行";
    map["HANABANK"] = "韩亚银行";
    map["CMBC"] = "中国民生银行";
    map["LYBANK"] = "洛阳银行";
    map["GDB"] = "广东发展银行";
    map["ZBCB"] = "齐商银行";
    map["CBKF"] = "开封市商业银行";
    map["H3CB"] = "内蒙古银行";
    map["CIB"] = "兴业银行";
    map["CRCBANK"] = "重庆农村商业银行";
    map["SZSBK"] = "石嘴山银行";
    map["DZBANK"] = "德州银行";
    map["SRBANK"] = "上饶银行";
    map["LSCCB"] = "乐山市商业银行";
    map["JXRCU"] = "江西省农村信用";
    map["ICBC"] = "中国工商银行";
    map["JZBANK"] = "晋中市商业银行";
    map["HZCCB"] = "湖州市商业银行";
    map["NHB"] = "南海农村信用联社";
    map["XXBANK"] = "新乡银行";
    map["JRCB"] = "江苏江阴农村商业银行";
    map["YNRCC"] = "云南省农村信用社";
    map["ABC"] = "中国农业银行";
    map["GXRCU"] = "广西省农村信用";
    map["PSBC"] = "中国邮政储蓄银行";
    map["BZMD"] = "驻马店银行";
    map["ARCU"] = "安徽省农村信用社";
    map["GSRCU"] = "甘肃省农村信用";
    map["LYCB"] = "辽阳市商业银行";
    map["JLRCU"] = "吉林农信";
    map["URMQCCB"] = "乌鲁木齐市商业银行";
    map["XLBANK"] = "中山小榄村镇银行";
    map["CSCB"] = "长沙银行";
    map["JHBANK"] = "金华银行";
    map["BHB"] = "河北银行";
    map["NBYZ"] = "鄞州银行";
    map["LSBC"] = "临商银行";
    map["BOCD"] = "承德银行";
    map["SDRCU"] = "山东农信";
    map["NCB"] = "南昌银行";
    map["TCCB"] = "天津银行";
    map["WJRCB"] = "吴江农商银行";
    map["CBBQS"] = "城市商业银行资金清算中心";
    map["HBRCU"] = "河北省农村信用社";

    return map[bankId];
  }
}
