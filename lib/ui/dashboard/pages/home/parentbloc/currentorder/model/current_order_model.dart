class CurrentOrdersModel {
  bool? success;
  String? message;
  List<Orders>? orders;

  CurrentOrdersModel({this.success, this.message, this.orders});

  CurrentOrdersModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  int? id;
  String? quotationNo;
  int? quotCount;

  Orders({this.id, this.quotationNo, this.quotCount});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quotationNo = json['quotation_no'];
    quotCount = json['quot_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quotation_no'] = this.quotationNo;
    data['quot_count'] = this.quotCount;
    return data;
  }
}

