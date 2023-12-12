class ServerTime {
  String sysDate;
  static ServerTime fromJson(Map<String, dynamic> map) {
    return ServerTime()..sysDate = map['sysDate'];
  }

  Map toJson() => {
        "sysDate": sysDate,
      };
}
