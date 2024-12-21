class TrendingMedicineModel {
  bool? success;
  String? message;
  List<Medicines>? medicines;

  TrendingMedicineModel({this.success, this.message, this.medicines});

  TrendingMedicineModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
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
    if (this.medicines != null) {
      data['medicines'] = this.medicines!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Medicines {
  int? id;
  String? name;
  String? type;
  int? mrp;
  String? packInfo;
  String? imageUrl;
  String? prescriptionRequired;
  int? quantity;

  Medicines(
      {this.id,
        this.name,
        this.type,
        this.mrp,
        this.packInfo,
        this.imageUrl,
        this.prescriptionRequired,
        this.quantity});

  Medicines.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    mrp = json['mrp'];
    packInfo = json['pack_info'];
    imageUrl = json['image_url'];
    prescriptionRequired = json['prescription_required'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['mrp'] = this.mrp;
    data['pack_info'] = this.packInfo;
    data['image_url'] = this.imageUrl;
    data['prescription_required'] = this.prescriptionRequired;
    data['quantity'] = this.quantity;
    return data;
  }
}
