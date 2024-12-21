class UploadPrescriptionModel {
  bool? success;
  int? cPrescriptionId;
  String? message;

  UploadPrescriptionModel({this.success, this.cPrescriptionId, this.message});

  UploadPrescriptionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    cPrescriptionId = json['c_prescription_id'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['c_prescription_id'] = this.cPrescriptionId;
    data['message'] = this.message;
    return data;
  }
}

