/// monthlyMoney : 4702
/// monthlyPer : 47025
/// monthlyProxyCount : 3
/// totalLv1 : 1
/// totalLv2 : 1
/// totalLv3 : 1
/// totalLv4 : 0
/// totalMoney : 4702
/// totalPer : 47020

class ProxyInfo {
  int monthlyPer;
  int monthlyProxyCount;
  int totalLv1;
  int totalLv2;
  int totalLv3;
  int totalLv4;
  double monthlyIncome;
  double totalIncome;
  int totalPer;

  static ProxyInfo fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    ProxyInfo proxyInfoBean = ProxyInfo();
    proxyInfoBean.monthlyPer = map['monthlyPer'];
    proxyInfoBean.monthlyProxyCount = map['monthlyProxyCount'];
    proxyInfoBean.totalLv1 = map['totalLv1'];
    proxyInfoBean.totalLv2 = map['totalLv2'];
    proxyInfoBean.totalLv3 = map['totalLv3'];
    proxyInfoBean.totalLv4 = map['totalLv4'];
    proxyInfoBean.totalPer = map['totalPer'];
    proxyInfoBean.monthlyIncome = map['monthlyIncome']?.toDouble() ?? .0;
    proxyInfoBean.totalIncome = map['totalIncome']?.toDouble() ?? .0;
    return proxyInfoBean;
  }

  Map toJson() => {
        "monthlyPer": monthlyPer,
        "monthlyProxyCount": monthlyProxyCount,
        "totalLv1": totalLv1,
        "totalLv2": totalLv2,
        "totalLv3": totalLv3,
        "totalLv4": totalLv4,
        "totalPer": totalPer,
        "monthlyIncome": monthlyIncome,
        "totalIncome": totalIncome,
      };
}
