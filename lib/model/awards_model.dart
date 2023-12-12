class AwardsExpire {
  AwardsExpire({
    this.number,
    this.isExpire,
    this.imageUrl,
  });

  int number;
  bool isExpire;
  String imageUrl;

  factory AwardsExpire.fromJson(Map<String, dynamic> json) => AwardsExpire(
        number: json["number"] == null ? null : json["number"],
        isExpire: json["isExpire"] == null ? null : json["isExpire"],
        imageUrl: json["imageUrl"] == null ? null : json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "number": number == null ? null : number,
        "isExpire": isExpire == null ? null : isExpire,
        "imgUrl": imageUrl == null ? null : imageUrl,
      };
}
