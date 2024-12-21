class VerifyCFModel {
  bool? success;
  String? message;
  Data? data;

  VerifyCFModel({this.success, this.message, this.data});

  VerifyCFModel.fromJson(Map<String, dynamic> json) {
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
  int? cfPaymentId;
  String? entity;
  bool? isCaptured;
  String? paymentGroup;
  String? paymentCurrency;
  String? paymentStatus;
  String? paymentMessage;

  Data(
      {this.cfPaymentId,
        this.entity,
        this.isCaptured,
        this.paymentGroup,
        this.paymentCurrency,
        this.paymentStatus,
        this.paymentMessage});

  Data.fromJson(Map<String, dynamic> json) {
    cfPaymentId = json['cf_payment_id'];
    entity = json['entity'];
    isCaptured = json['is_captured'];
    paymentGroup = json['payment_group'];
    paymentCurrency = json['payment_currency'];
    paymentStatus = json['payment_status'];
    paymentMessage = json['payment_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cf_payment_id'] = this.cfPaymentId;
    data['entity'] = this.entity;
    data['is_captured'] = this.isCaptured;
    data['payment_group'] = this.paymentGroup;
    data['payment_currency'] = this.paymentCurrency;
    data['payment_status'] = this.paymentStatus;
    data['payment_message'] = this.paymentMessage;
    return data;
  }
}

