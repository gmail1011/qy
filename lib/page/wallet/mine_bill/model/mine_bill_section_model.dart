import 'bill_item_model.dart';

class MineBillSectionModel {
  String income;
  String expenditure;
  List<BillItemModel> mineBillModel;
  bool hasNext;
  int month;
  bool haxNextMonth;
  int year;

  MineBillSectionModel(
      {this.income, this.expenditure, this.mineBillModel, this.hasNext});

  MineBillSectionModel.fromJson(Map<String, dynamic> json) {
    income = json['income'];
    expenditure = json['expenditure'];
    if (json['list'] != null) {
      mineBillModel = new List<BillItemModel>();
      json['list'].forEach((v) {
        mineBillModel.add(BillItemModel.fromJson(v));
      });
    }
    hasNext = json['hasNext'];
    haxNextMonth = json['haxNextMonth'];
    month = json['month'];
    year = json['year'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['income'] = this.income;
    data['expenditure'] = this.expenditure;
    if (this.mineBillModel != null) {
      data['list'] =
          this.mineBillModel.map((v) => v.toJson()).toList();
    }
    data['hasNext'] = this.hasNext;
    data['haxNextMonth'] = this.haxNextMonth;
    data['month'] = this.month;
    data['year'] = this.year;
    return data;
  }
}