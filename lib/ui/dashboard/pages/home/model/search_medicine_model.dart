class SearchResultModel {
  bool? success;
  String? message;
  List<SearchMedicines>? medicines;

  SearchResultModel({this.success, this.message, this.medicines});

  SearchResultModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['medicines'] != null) {
      medicines = <SearchMedicines>[];
      json['medicines'].forEach((v) {
        medicines!.add(new SearchMedicines.fromJson(v));
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

class SearchMedicines {
  int? id;
  String? name;
  String? type;
  var mrp;

  SearchMedicines({this.id, this.name, this.type, this.mrp});

  SearchMedicines.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    mrp = json['mrp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['mrp'] = this.mrp;
    return data;
  }
}
