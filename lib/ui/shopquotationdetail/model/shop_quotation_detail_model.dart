class ShopQuotationDetailModel {
  bool? success;
  String? message;
  Quotation? quotation;

  ShopQuotationDetailModel({this.success, this.message, this.quotation});

  ShopQuotationDetailModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    quotation = json['quotation'] != null
        ? new Quotation.fromJson(json['quotation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.quotation != null) {
      data['quotation'] = this.quotation!.toJson();
    }
    return data;
  }
}

class Quotation {
  int? id;
  int? vendorId;
  int? customerQuotationId;
  int? deliverBy;
  int? subtotal;
  int? discount;
  int? total;
  String? createdAt;
  String? updatedAt;
  List<Medicines>? medicines;

  Quotation(
      {this.id,
        this.vendorId,
        this.customerQuotationId,
        this.deliverBy,
        this.subtotal,
        this.discount,
        this.total,
        this.createdAt,
        this.updatedAt,
        this.medicines});

  Quotation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    customerQuotationId = json['customer_quotation_id'];
    deliverBy = json['deliver_by'];
    subtotal = json['subtotal'];
    discount = json['discount'];
    total = json['total'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['medicines'] != null) {
      medicines = <Medicines>[];
      json['medicines'].forEach((v) {
        medicines!.add(new Medicines.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_id'] = this.vendorId;
    data['customer_quotation_id'] = this.customerQuotationId;
    data['deliver_by'] = this.deliverBy;
    data['subtotal'] = this.subtotal;
    data['discount'] = this.discount;
    data['total'] = this.total;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.medicines != null) {
      data['medicines'] = this.medicines!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Medicines {
  int? id;
  int? vendorQuotId;
  int? medicineId;
  String? medicineName;
  String? type;
  String? prescriptionRequired;
  var mrp;
  var quantity;
  var discount;
  String? expireOn;
  var imageUrl;
  String? createdAt;
  String? updatedAt;

  Medicines(
      {this.id,
        this.vendorQuotId,
        this.medicineId,
        this.medicineName,
        this.type,
        this.prescriptionRequired,
        this.mrp,
        this.quantity,
        this.discount,
        this.expireOn,
        this.imageUrl,
        this.createdAt,
        this.updatedAt});

  Medicines.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorQuotId = json['vendor_quot_id'];
    medicineId = json['medicine_id'];
    medicineName = json['medicine_name'];
    type = json['type'];
    prescriptionRequired = json['prescription_required'];
    mrp = json['mrp'];
    quantity = json['quantity'];
    discount = json['discount'];
    expireOn = json['expire_on'];
    imageUrl = json['image_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_quot_id'] = this.vendorQuotId;
    data['medicine_id'] = this.medicineId;
    data['medicine_name'] = this.medicineName;
    data['type'] = this.type;
    data['prescription_required'] = this.prescriptionRequired;
    data['mrp'] = this.mrp;
    data['quantity'] = this.quantity;
    data['discount'] = this.discount;
    data['expire_on'] = this.expireOn;
    data['image_url'] = this.imageUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
