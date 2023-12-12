///金币列表返回值
class RewardCoinRes {
  List<String> coins;

  static RewardCoinRes fromJson(Map<String, dynamic> map) {
    RewardCoinRes res = RewardCoinRes();
    res.coins = List()..addAll((map['coins'] as List ?? []).map((o) => o));
    return res;
  }
}