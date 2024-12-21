class MyOrderListModel {
  bool? success;
  String? message;
  List<NewOrders>? newOrders;
  List<PastOrders>? pastOrders;

  MyOrderListModel(
      {this.success, this.message, this.newOrders, this.pastOrders});

  MyOrderListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['new_orders'] != null) {
      newOrders = <NewOrders>[];
      json['new_orders'].forEach((v) {
        newOrders!.add(new NewOrders.fromJson(v));
      });
    }
    if (json['past_orders'] != null) {
      pastOrders = <PastOrders>[];
      json['past_orders'].forEach((v) {
        pastOrders!.add(new PastOrders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.newOrders != null) {
      data['new_orders'] = this.newOrders!.map((v) => v.toJson()).toList();
    }
    if (this.pastOrders != null) {
      data['past_orders'] = this.pastOrders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NewOrders {
  int? id;
  String? orderNumber;
  String? shop;
  String? shopAddress;
  String? deliverOrPickup;
  int? deliverBy;
  int? orderStatus;
  var subtotal;
  var totalDiscount;
  var deliveryCharge;
  var total;
  var deliveredAt;

  NewOrders(
      {this.id,
        this.orderNumber,
        this.shop,
        this.shopAddress,
        this.deliverOrPickup,
        this.deliverBy,
        this.orderStatus,
        this.subtotal,
        this.totalDiscount,
        this.deliveryCharge,
        this.total,
        this.deliveredAt});

  NewOrders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['order_number'];
    shop = json['shop'];
    shopAddress = json['shop_address'];
    deliverOrPickup = json['deliver_or_pickup'];
    deliverBy = json['deliver_by'];
    orderStatus = json['order_status'];
    subtotal = json['subtotal'];
    totalDiscount = json['total_discount'];
    deliveryCharge = json['delivery_charge'];
    total = json['total'];
    deliveredAt = json['delivered_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_number'] = this.orderNumber;
    data['shop'] = this.shop;
    data['shop_address'] = this.shopAddress;
    data['deliver_or_pickup'] = this.deliverOrPickup;
    data['deliver_by'] = this.deliverBy;
    data['order_status'] = this.orderStatus;
    data['subtotal'] = this.subtotal;
    data['total_discount'] = this.totalDiscount;
    data['delivery_charge'] = this.deliveryCharge;
    data['total'] = this.total;
    data['delivered_at'] = this.deliveredAt;
    return data;
  }
}
class PastOrders {
  int? id;
  String? orderNumber;
  String? shop;
  String? shopAddress;
  String? deliverOrPickup;
  int? deliverBy;
  int? orderStatus;
  var subtotal;
  var totalDiscount;
  var deliveryCharge;
  var total;
  var deliveredAt;

  PastOrders(
      {this.id,
        this.orderNumber,
        this.shop,
        this.shopAddress,
        this.deliverOrPickup,
        this.deliverBy,
        this.orderStatus,
        this.subtotal,
        this.totalDiscount,
        this.deliveryCharge,
        this.total,
        this.deliveredAt});

  PastOrders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['order_number'];
    shop = json['shop'];
    shopAddress = json['shop_address'];
    deliverOrPickup = json['deliver_or_pickup'];
    deliverBy = json['deliver_by'];
    orderStatus = json['order_status'];
    subtotal = json['subtotal'];
    totalDiscount = json['total_discount'];
    deliveryCharge = json['delivery_charge'];
    total = json['total'];
    deliveredAt = json['delivered_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_number'] = this.orderNumber;
    data['shop'] = this.shop;
    data['shop_address'] = this.shopAddress;
    data['deliver_or_pickup'] = this.deliverOrPickup;
    data['deliver_by'] = this.deliverBy;
    data['order_status'] = this.orderStatus;
    data['subtotal'] = this.subtotal;
    data['total_discount'] = this.totalDiscount;
    data['delivery_charge'] = this.deliveryCharge;
    data['total'] = this.total;
    data['delivered_at'] = this.deliveredAt;
    return data;
  }
}
