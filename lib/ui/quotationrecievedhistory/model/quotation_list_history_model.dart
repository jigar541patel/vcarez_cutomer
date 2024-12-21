class QuotationHistoryListModel {
  bool? success;
  String? message;
  List<Quotations>? quotations;

  QuotationHistoryListModel({this.success, this.message, this.quotations});

  QuotationHistoryListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['quotations'] != null) {
      quotations = <Quotations>[];
      json['quotations'].forEach((v) {
        quotations!.add(new Quotations.fromJson(v));
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
    return data;
  }
}

class Quotations {
  int? id;
  int? customerId;
  String? quotationNo;
  int? uploadPrescription;
  int? alternative;
  String? deliverOrPickup;
  String? deliveryAddress;
  double? lattitude;
  double? longitude;
  int? active;
  String? createdAt;
  String? updatedAt;
  String? date;
  String? time;
  String? timeLeft;
  int? quotsCount;
  CustomerPrescription? customerPrescription;
  List<QuotationMedicine>? quotationMedicine;

  Quotations(
      {this.id,
        this.customerId,
        this.quotationNo,
        this.uploadPrescription,
        this.alternative,
        this.deliverOrPickup,
        this.deliveryAddress,
        this.lattitude,
        this.longitude,
        this.active,
        this.createdAt,
        this.updatedAt,
        this.date,
        this.time,
        this.timeLeft,
        this.quotsCount,
        this.customerPrescription,
        this.quotationMedicine});

  Quotations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    quotationNo = json['quotation_no'];
    uploadPrescription = json['upload_prescription'];
    alternative = json['alternative'];
    deliverOrPickup = json['deliver_or_pickup'];
    deliveryAddress = json['delivery_address'];
    lattitude = json['lattitude'];
    longitude = json['longitude'];
    active = json['active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    date = json['date'];
    time = json['time'];
    timeLeft = json['time_left'];
    quotsCount = json['quots_count'];
    customerPrescription = json['customer_prescription'] != null
        ? new CustomerPrescription.fromJson(json['customer_prescription'])
        : null;
    if (json['quotation_medicine'] != null) {
      quotationMedicine = <QuotationMedicine>[];
      json['quotation_medicine'].forEach((v) {
        quotationMedicine!.add(new QuotationMedicine.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['quotation_no'] = this.quotationNo;
    data['upload_prescription'] = this.uploadPrescription;
    data['alternative'] = this.alternative;
    data['deliver_or_pickup'] = this.deliverOrPickup;
    data['delivery_address'] = this.deliveryAddress;
    data['lattitude'] = this.lattitude;
    data['longitude'] = this.longitude;
    data['active'] = this.active;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['date'] = this.date;
    data['time'] = this.time;
    data['time_left'] = this.timeLeft;
    data['quots_count'] = this.quotsCount;
    if (this.customerPrescription != null) {
      data['customer_prescription'] = this.customerPrescription!.toJson();
    }
    if (this.quotationMedicine != null) {
      data['quotation_medicine'] =
          this.quotationMedicine!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerPrescription {
  int? id;
  int? customerId;
  int? customerQuotationId;
  String? prescription;
  int? medicineSpecificOrder;
  String? specificMedicineDetails;
  int? callUs;
  String? createdAt;
  String? updatedAt;

  CustomerPrescription(
      {this.id,
        this.customerId,
        this.customerQuotationId,
        this.prescription,
        this.medicineSpecificOrder,
        this.specificMedicineDetails,
        this.callUs,
        this.createdAt,
        this.updatedAt});

  CustomerPrescription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    customerQuotationId = json['customer_quotation_id'];
    prescription = json['prescription'];
    medicineSpecificOrder = json['medicine_specific_order'];
    specificMedicineDetails = json['specific_medicine_details'];
    callUs = json['call_us'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['customer_quotation_id'] = this.customerQuotationId;
    data['prescription'] = this.prescription;
    data['medicine_specific_order'] = this.medicineSpecificOrder;
    data['specific_medicine_details'] = this.specificMedicineDetails;
    data['call_us'] = this.callUs;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class QuotationMedicine {
  int? id;
  int? customerQuotationId;
  String? medicineName;
  int? qty;
  var packaging;
  var packInfo;
  String? createdAt;
  String? updatedAt;

  QuotationMedicine(
      {this.id,
        this.customerQuotationId,
        this.medicineName,
        this.qty,
        this.packaging,
        this.packInfo,
        this.createdAt,
        this.updatedAt});

  QuotationMedicine.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerQuotationId = json['customer_quotation_id'];
    medicineName = json['medicine_name'];
    qty = json['qty'];
    packaging = json['packaging'];
    packInfo = json['pack_info'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_quotation_id'] = this.customerQuotationId;
    data['medicine_name'] = this.medicineName;
    data['qty'] = this.qty;
    data['packaging'] = this.packaging;
    data['pack_info'] = this.packInfo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
