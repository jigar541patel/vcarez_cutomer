class SearchDetailResultModel {
  bool? success;
  String? message;
  List<MedicinesSearchDetailList>? medicines;

  SearchDetailResultModel({this.success, this.message, this.medicines});

  SearchDetailResultModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['medicines'] != null) {
      medicines = <MedicinesSearchDetailList>[];
      json['medicines'].forEach((v) {
        medicines!.add(new MedicinesSearchDetailList.fromJson(v));
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

class MedicinesSearchDetailList {
  int? id;
  String? name;
  String? type;
  var mrp;
  var packaging;
  var packInfo;
  var imageUrl;

  MedicinesSearchDetailList(
      {this.id,
        this.name,
        this.type,
        this.mrp,
        this.packaging,
        this.packInfo,
        this.imageUrl});

  MedicinesSearchDetailList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    mrp = json['mrp'];
    packaging = json['packaging'];
    packInfo = json['pack_info'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['mrp'] = this.mrp;
    data['packaging'] = this.packaging;
    data['pack_info'] = this.packInfo;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
