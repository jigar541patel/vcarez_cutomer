class PopularMedicineModel {
  bool? success;
  String? message;
  List<Medicines>? medicines;
  Quantity? quantity;

  PopularMedicineModel(
      {this.success, this.message, this.medicines, this.quantity});

  PopularMedicineModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['medicines'] != null) {
      medicines = <Medicines>[];
      json['medicines'].forEach((v) {
        medicines!.add(new Medicines.fromJson(v));
      });
    }
    quantity = json['quantity'] != null
        ? new Quantity.fromJson(json['quantity'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.medicines != null) {
      data['medicines'] = this.medicines!.map((v) => v.toJson()).toList();
    }
    if (this.quantity != null) {
      data['quantity'] = this.quantity!.toJson();
    }
    return data;
  }
}

class Medicines {
  int? id;
  String? name;
  var mrp;
  String? packInfo;
  String? imageUrl;
  String? type;
  String? prescriptionRequired;
  var quantity;
  var sold;

  Medicines(
      {this.id,
        this.name,
        this.mrp,
        this.packInfo,
        this.imageUrl,
        this.type,
        this.prescriptionRequired,
        this.quantity,
        this.sold});

  Medicines.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mrp = json['mrp'];
    packInfo = json['pack_info'];
    imageUrl = json['image_url'];
    type = json['type'];
    prescriptionRequired = json['prescription_required'];
    quantity = json['quantity'];
    sold = json['sold'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['mrp'] = this.mrp;
    data['pack_info'] = this.packInfo;
    data['image_url'] = this.imageUrl;
    data['type'] = this.type;
    data['prescription_required'] = this.prescriptionRequired;
    data['quantity'] = this.quantity;
    data['sold'] = this.sold;
    return data;
  }
}

class Quantity {
  int? aBC;
  int? xYZ;
  int? xYZ2;
  int? aminoCollagenSachet7gmEachOrange;
  int? dollosPTablet;
  int? dolo650Tablet;
  int? aminoCollagenSachet7gmEach;

  Quantity(
      {this.aBC,
        this.xYZ,
        this.xYZ2,
        this.aminoCollagenSachet7gmEachOrange,
        this.dollosPTablet,
        this.dolo650Tablet,
        this.aminoCollagenSachet7gmEach});

  Quantity.fromJson(Map<String, dynamic> json) {
    aBC = json['ABC'];
    xYZ = json['XYZ'];
    xYZ2 = json['XYZ-2'];
    aminoCollagenSachet7gmEachOrange =
    json['Amino Collagen Sachet (7gm Each) Orange'];
    dollosPTablet = json['Dollos-P Tablet'];
    dolo650Tablet = json['Dolo 650 Tablet'];
    aminoCollagenSachet7gmEach = json['Amino Collagen Sachet (7gm Each)'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ABC'] = this.aBC;
    data['XYZ'] = this.xYZ;
    data['XYZ-2'] = this.xYZ2;
    data['Amino Collagen Sachet (7gm Each) Orange'] =
        this.aminoCollagenSachet7gmEachOrange;
    data['Dollos-P Tablet'] = this.dollosPTablet;
    data['Dolo 650 Tablet'] = this.dolo650Tablet;
    data['Amino Collagen Sachet (7gm Each)'] = this.aminoCollagenSachet7gmEach;
    return data;
  }
}
