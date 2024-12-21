class CategoryProductListModel {
  bool? success;
  String? message;
  List<Categories>? categories;

  CategoryProductListModel({this.success, this.message, this.categories});

  CategoryProductListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  var mrp;
  String? packInfo;
  String? imageUrl;
  String? type;
  int? quantity;

  Categories(
      {this.id,
        this.name,
        this.mrp,
        this.packInfo,
        this.imageUrl,
        this.type,
        this.quantity});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mrp = json['mrp'];
    packInfo = json['pack_info'];
    imageUrl = json['image_url'];
    type = json['type'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['mrp'] = this.mrp;
    data['pack_info'] = this.packInfo;
    data['image_url'] = this.imageUrl;
    data['type'] = this.type;
    data['quantity'] = this.quantity;
    return data;
  }
}
