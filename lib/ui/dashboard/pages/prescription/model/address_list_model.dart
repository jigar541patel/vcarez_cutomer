class AddressListModel {
  bool? success;
  String? message;
  List<Addresses>? addresses;

  AddressListModel({this.success, this.message, this.addresses});

  AddressListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['addresses'] != null) {
      addresses = <Addresses>[];
      json['addresses'].forEach((v) {
        addresses!.add(new Addresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.addresses != null) {
      data['addresses'] = this.addresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Addresses {
  int? id;
  String? address;
  double? lattitude;
  double? longitude;
  int? cityId;
  int? stateId;
  String? pincode;

  Addresses(
      {this.id,
        this.address,
        this.lattitude,
        this.longitude,
        this.cityId,
        this.stateId,
        this.pincode});

  Addresses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    lattitude = json['lattitude'];
    longitude = json['longitude'];
    cityId = json['city_id'];
    stateId = json['state_id'];
    pincode = json['pincode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    data['lattitude'] = this.lattitude;
    data['longitude'] = this.longitude;
    data['city_id'] = this.cityId;
    data['state_id'] = this.stateId;
    data['pincode'] = this.pincode;
    return data;
  }
}

