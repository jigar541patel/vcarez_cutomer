class CartListModel {
  bool? success;
  String? message;
  List<CartItems>? cartItems;

  CartListModel({this.success, this.message, this.cartItems});

  CartListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['cart_items'] != null) {
      cartItems = <CartItems>[];
      json['cart_items'].forEach((v) {
        cartItems!.add(new CartItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.cartItems != null) {
      data['cart_items'] = this.cartItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartItems {
  int? id;
  int? medicineId;
  String? name;
  String? type;
  var mrp;
  int? quantity;
  String? imageUrl;
  String? packaging;
  String? packInfo;

  CartItems(
      {this.id,
        this.medicineId,
        this.name,
        this.type,
        this.mrp,
        this.quantity,
        this.imageUrl,
        this.packaging,
        this.packInfo});

  CartItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    medicineId = json['medicine_id'];
    name = json['name'];
    type = json['type'];
    mrp = json['mrp'];
    quantity = json['quantity'];
    imageUrl = json['image_url'];
    packaging = json['packaging'];
    packInfo = json['pack_info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['medicine_id'] = this.medicineId;
    data['name'] = this.name;
    data['type'] = this.type;
    data['mrp'] = this.mrp;
    data['quantity'] = this.quantity;
    data['image_url'] = this.imageUrl;
    data['packaging'] = this.packaging;
    data['pack_info'] = this.packInfo;
    return data;
  }
}
