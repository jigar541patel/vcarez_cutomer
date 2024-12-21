class BuyPlanSuccessModel {
  bool? success;
  String? message;
  Membership? membership;

  BuyPlanSuccessModel({this.success, this.message, this.membership});

  BuyPlanSuccessModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    membership = json['membership'] != null
        ? new Membership.fromJson(json['membership'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.membership != null) {
      data['membership'] = this.membership!.toJson();
    }
    return data;
  }
}

class Membership {
  String? title;
  var price;
  int? duration;
  String? type;
  int? customerId;
  String? purchaseToken;
  String? updatedAt;
  String? createdAt;
  int? id;

  Membership(
      {this.title,
        this.price,
        this.duration,
        this.type,
        this.customerId,
        this.purchaseToken,
        this.updatedAt,
        this.createdAt,
        this.id});

  Membership.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    price = json['price'];
    duration = json['duration'];
    type = json['type'];
    customerId = json['customer_id'];
    purchaseToken = json['purchase_token'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['price'] = this.price;
    data['duration'] = this.duration;
    data['type'] = this.type;
    data['customer_id'] = this.customerId;
    data['purchase_token'] = this.purchaseToken;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}

