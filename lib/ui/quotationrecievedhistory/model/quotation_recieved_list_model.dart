class QuotationReceivedListModel {
  bool? success;
  String? message;
  List<Quotations>? quotations;
  var presImage;
  List<Medicines>? medicines;

  QuotationReceivedListModel(
      {this.success,
        this.message,
        this.quotations,
        this.presImage,
        this.medicines});

  QuotationReceivedListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['quotations'] != null) {
      quotations = <Quotations>[];
      json['quotations'].forEach((v) {
        quotations!.add(new Quotations.fromJson(v));
      });
    }
    presImage = json['pres_image'];
    if (json['medicines'] != null) {
      medicines = <Medicines>[];
      json['medicines'].forEach((v) {
        medicines!.add(new Medicines.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.quotations != null) {
      data['quotations'] = this.quotations!.map((v) => v.toJson()).toList();
    }
    data['pres_image'] = this.presImage;
    if (this.medicines != null) {
      data['medicines'] = this.medicines!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Quotations {
  int? id;
  int? vendorId;
  int? total;
  String? shopName;

  Quotations({this.id, this.vendorId, this.total, this.shopName});

  Quotations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    total = json['total'];
    shopName = json['shop_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_id'] = this.vendorId;
    data['total'] = this.total;
    data['shop_name'] = this.shopName;
    return data;
  }
}

class Medicines {
  int? id;
  int? customerQuotationId;
  String? medicineName;
  int? qty;
  String? createdAt;
  String? updatedAt;

  Medicines(
      {this.id,
        this.customerQuotationId,
        this.medicineName,
        this.qty,
        this.createdAt,
        this.updatedAt});

  Medicines.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerQuotationId = json['customer_quotation_id'];
    medicineName = json['medicine_name'];
    qty = json['qty'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_quotation_id'] = this.customerQuotationId;
    data['medicine_name'] = this.medicineName;
    data['qty'] = this.qty;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
