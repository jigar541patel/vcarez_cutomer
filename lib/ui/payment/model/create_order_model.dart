class CreateOrderModel {
  bool? success;
  String? message;
  Data? data;

  CreateOrderModel({this.success, this.message, this.data});

  CreateOrderModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? cfOrderId;
  String? createdAt;
  CustomerDetails? customerDetails;
  String? entity;
  var orderAmount;
  String? orderCurrency;
  String? orderExpiryTime;
  String? orderId;
  OrderMeta? orderMeta;
  String? orderNote;
  List<dynamic>? orderSplits;
  String? orderStatus;
  var orderTags;
  String? paymentSessionId;
  Payments? payments;
  Payments? refunds;
  Payments? settlements;
  var terminalData;

  Data(
      {this.cfOrderId,
        this.createdAt,
        this.customerDetails,
        this.entity,
        this.orderAmount,
        this.orderCurrency,
        this.orderExpiryTime,
        this.orderId,
        this.orderMeta,
        this.orderNote,
        this.orderSplits,
        this.orderStatus,
        this.orderTags,
        this.paymentSessionId,
        this.payments,
        this.refunds,
        this.settlements,
        this.terminalData});

  Data.fromJson(Map<String, dynamic> json) {
    cfOrderId = json['cf_order_id'];
    createdAt = json['created_at'];
    customerDetails = json['customer_details'] != null
        ? new CustomerDetails.fromJson(json['customer_details'])
        : null;
    entity = json['entity'];
    orderAmount = json['order_amount'];
    orderCurrency = json['order_currency'];
    orderExpiryTime = json['order_expiry_time'];
    orderId = json['order_id'];
    orderMeta = json['order_meta'] != null
        ? new OrderMeta.fromJson(json['order_meta'])
        : null;
    orderNote = json['order_note'];
    if (json['order_splits'] != null) {
      orderSplits = <Null>[];
      json['order_splits'].forEach((v) {
        // orderSplits!.add(new Null.fromJson(v));
      });
    }
    orderStatus = json['order_status'];
    orderTags = json['order_tags'];
    paymentSessionId = json['payment_session_id'];
    payments = json['payments'] != null
        ? new Payments.fromJson(json['payments'])
        : null;
    refunds =
    json['refunds'] != null ? new Payments.fromJson(json['refunds']) : null;
    settlements = json['settlements'] != null
        ? new Payments.fromJson(json['settlements'])
        : null;
    terminalData = json['terminal_data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cf_order_id'] = this.cfOrderId;
    data['created_at'] = this.createdAt;
    if (this.customerDetails != null) {
      data['customer_details'] = this.customerDetails!.toJson();
    }
    data['entity'] = this.entity;
    data['order_amount'] = this.orderAmount;
    data['order_currency'] = this.orderCurrency;
    data['order_expiry_time'] = this.orderExpiryTime;
    data['order_id'] = this.orderId;
    if (this.orderMeta != null) {
      data['order_meta'] = this.orderMeta!.toJson();
    }
    data['order_note'] = this.orderNote;
    if (this.orderSplits != null) {
      data['order_splits'] = this.orderSplits!.map((v) => v.toJson()).toList();
    }
    data['order_status'] = this.orderStatus;
    data['order_tags'] = this.orderTags;
    data['payment_session_id'] = this.paymentSessionId;
    if (this.payments != null) {
      data['payments'] = this.payments!.toJson();
    }
    if (this.refunds != null) {
      data['refunds'] = this.refunds!.toJson();
    }
    if (this.settlements != null) {
      data['settlements'] = this.settlements!.toJson();
    }
    data['terminal_data'] = this.terminalData;
    return data;
  }
}

class CustomerDetails {
  String? customerId;
  String? customerName;
  String? customerEmail;
  String? customerPhone;

  CustomerDetails(
      {this.customerId,
        this.customerName,
        this.customerEmail,
        this.customerPhone});

  CustomerDetails.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    customerEmail = json['customer_email'];
    customerPhone = json['customer_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['customer_email'] = this.customerEmail;
    data['customer_phone'] = this.customerPhone;
    return data;
  }
}

class OrderMeta {
  var returnUrl;
  String? notifyUrl;
  var paymentMethods;

  OrderMeta({this.returnUrl, this.notifyUrl, this.paymentMethods});

  OrderMeta.fromJson(Map<String, dynamic> json) {
    returnUrl = json['return_url'];
    notifyUrl = json['notify_url'];
    paymentMethods = json['payment_methods'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['return_url'] = this.returnUrl;
    data['notify_url'] = this.notifyUrl;
    data['payment_methods'] = this.paymentMethods;
    return data;
  }
}

class Payments {
  String? url;

  Payments({this.url});

  Payments.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}
