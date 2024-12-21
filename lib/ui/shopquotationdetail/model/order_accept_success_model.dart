class OrderAcceptSuccessModel {
  bool? success;
  String? message;
  Order? order;

  OrderAcceptSuccessModel({this.success, this.message, this.order});

  OrderAcceptSuccessModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
    return data;
  }
}

class Order {
  var subtotal;
  var deliveryCharge;
  var totalDiscount;
  var total;
  String? orderDate;
  var cgst;
  var sgst;
  List<SubOrders>? subOrders;

  Order(
      {this.subtotal,
        this.deliveryCharge,
        this.totalDiscount,
        this.total,
        this.orderDate,
        this.cgst,
        this.sgst,
        this.subOrders});

  Order.fromJson(Map<String, dynamic> json) {
    subtotal = json['subtotal'];
    deliveryCharge = json['delivery_charge'];
    totalDiscount = json['total_discount'];
    total = json['total'];
    orderDate = json['order_date'];
    cgst = json['cgst'];
    sgst = json['sgst'];
    if (json['sub_orders'] != null) {
      subOrders = <SubOrders>[];
      json['sub_orders'].forEach((v) {
        subOrders!.add(new SubOrders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subtotal'] = this.subtotal;
    data['delivery_charge'] = this.deliveryCharge;
    data['total_discount'] = this.totalDiscount;
    data['total'] = this.total;
    data['order_date'] = this.orderDate;
    data['cgst'] = this.cgst;
    data['sgst'] = this.sgst;
    if (this.subOrders != null) {
      data['sub_orders'] = this.subOrders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubOrders {
  String? shopName;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? shopContact;
  var subtotal;
  var totalDiscount;
  var deliveryCharge;
  var total;
  List<OrderItems>? orderItems;

  SubOrders(
      {this.shopName,
        this.address1,
        this.address2,
        this.city,
        this.state,
        this.shopContact,
        this.subtotal,
        this.totalDiscount,
        this.deliveryCharge,
        this.total,
        this.orderItems});

  SubOrders.fromJson(Map<String, dynamic> json) {
    shopName = json['shop_name'];
    address1 = json['address_1'];
    address2 = json['address_2'];
    city = json['city'];
    state = json['state'];
    shopContact = json['shop_contact'];
    subtotal = json['subtotal'];
    totalDiscount = json['total_discount'];
    deliveryCharge = json['delivery_charge'];
    total = json['total'];
    if (json['order_items'] != null) {
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v) {
        orderItems!.add(new OrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shop_name'] = this.shopName;
    data['address_1'] = this.address1;
    data['address_2'] = this.address2;
    data['city'] = this.city;
    data['state'] = this.state;
    data['shop_contact'] = this.shopContact;
    data['subtotal'] = this.subtotal;
    data['total_discount'] = this.totalDiscount;
    data['delivery_charge'] = this.deliveryCharge;
    data['total'] = this.total;
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderItems {
  String? name;
  var mrp;
  var quantity;
  var discount;
  String? expireOn;
  String? imageUrl;
  String? packInfo;

  OrderItems(
      {this.name,
        this.mrp,
        this.quantity,
        this.discount,
        this.expireOn,
        this.imageUrl,
        this.packInfo});

  OrderItems.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mrp = json['mrp'];
    quantity = json['quantity'];
    discount = json['discount'];
    expireOn = json['expire_on'];
    imageUrl = json['image_url'];
    packInfo = json['pack_info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mrp'] = this.mrp;
    data['quantity'] = this.quantity;
    data['discount'] = this.discount;
    data['expire_on'] = this.expireOn;
    data['image_url'] = this.imageUrl;
    data['pack_info'] = this.packInfo;
    return data;
  }
}

