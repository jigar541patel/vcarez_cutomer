class MyPrescriptionModel {
  bool? success;
  String? message;
  List<PrescriptionList>? prescriptionList;

  MyPrescriptionModel({this.success, this.message, this.prescriptionList});

  MyPrescriptionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['prescriptionList'] != null) {
      prescriptionList = <PrescriptionList>[];
      json['prescriptionList'].forEach((v) {
        prescriptionList!.add(new PrescriptionList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.prescriptionList != null) {
      data['prescriptionList'] =
          this.prescriptionList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PrescriptionList {
  int? id;
  int? customerId;
  int? customerQuotationId;
  String? prescription;
  int? medicineSpecificOrder;
  String? specificMedicineDetails;
  int? callUs;
  String? createdAt;
  String? updatedAt;

  PrescriptionList(
      {this.id,
        this.customerId,
        this.customerQuotationId,
        this.prescription,
        this.medicineSpecificOrder,
        this.specificMedicineDetails,
        this.callUs,
        this.createdAt,
        this.updatedAt});

  PrescriptionList.fromJson(Map<String, dynamic> json) {
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

